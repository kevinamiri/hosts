You will be provided with files and its contexts inside ``` code blocks ```. Your Task is to provide assistant base on these files context and given defined Goals



## File: docker-compose.yml

```YAML
version: '3'
services:
  monitoring:
    build: .
    environment:
      - SMTP_HOST=${SMTP_HOST}
      - SMTP_PORT=${SMTP_PORT}
      - SMTP_USERNAME=${SMTP_USERNAME}
      - SMTP_PASSWORD=${SMTP_PASSWORD}
      - FROM_EMAIL=${FROM_EMAIL}
      - TO_EMAIL=${TO_EMAIL}
      - HOSTS_URL=${HOSTS_URL}
```
---
## File: monitoring.py
```Python
import csv
import smtplib
import concurrent.futures
import socket
import requests
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

# AWS SMTP configuration
import os

# AWS SMTP configuration
SMTP_HOST = os.environ['SMTP_HOST']
SMTP_PORT = int(os.environ['SMTP_PORT'])
SMTP_USERNAME = os.environ['SMTP_USERNAME']
SMTP_PASSWORD = os.environ['SMTP_PASSWORD']
FROM_EMAIL = os.environ['FROM_EMAIL']
TO_EMAIL = os.environ['TO_EMAIL']
HOSTS_URL = os.environ['HOSTS_URL']


def fetch_hosts_from_url(url):
    response = requests.get(url)
    response.raise_for_status()
    reader = csv.reader(response.text.strip().split('\n'))
    hosts = [(row[0], int(row[1])) for row in reader]
    return hosts

def check_host(host, port, timeout=5):
    try:
        sock = socket.create_connection((host, port), timeout=timeout)
        sock.close()
        return True
    except (socket.timeout, ConnectionRefusedError, OSError):
        return False

def send_email(subject, body):
    msg = MIMEMultipart()
    msg['From'] = FROM_EMAIL
    msg['To'] = TO_EMAIL
    msg['Subject'] = subject
    msg.attach(MIMEText(body, 'plain'))

    with smtplib.SMTP(SMTP_HOST, SMTP_PORT) as server:
        server.starttls()
        server.login(SMTP_USERNAME, SMTP_PASSWORD)
        server.send_message(msg)

def monitor_hosts():
    hosts = fetch_hosts_from_url(HOSTS_URL)
    down_hosts = []

    with concurrent.futures.ThreadPoolExecutor() as executor:
        futures = [executor.submit(check_host, host, port) for host, port in hosts]
        for i, future in enumerate(concurrent.futures.as_completed(futures)):
            host, port = hosts[i]
            if not future.result():
                down_hosts.append((host, port))

    if down_hosts:
        subject = 'Host Down Alert'
        body = 'The following hosts are down:\n\n'
        body += '\n'.join(f'{host}:{port}' for host, port in down_hosts)
        send_email(subject, body)

if __name__ == '__main__':
    monitor_hosts()

```
---
Goal: Given codes and contexts, please create a readme.me for describing what this project will do.
