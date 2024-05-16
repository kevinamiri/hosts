## README.md

# Host Monitoring Service

This project is a simple host monitoring service that periodically checks the availability of specified hosts and sends email alerts when any host is down. The service is built using Python and Docker.

## Features

- Fetches a list of hosts and ports from a specified URL.
- Checks the availability of each host by attempting to create a socket connection.
- Sends an email alert if any host is down.

## Requirements

- Docker
- AWS SMTP configuration for sending email alerts

## Configuration

The service requires the following environment variables to be set:

- `SMTP_HOST`: The SMTP server hostname.
- `SMTP_PORT`: The SMTP server port.
- `SMTP_USERNAME`: The SMTP username for authentication.
- `SMTP_PASSWORD`: The SMTP password for authentication.
- `FROM_EMAIL`: The email address from which alerts will be sent.
- `TO_EMAIL`: The email address to which alerts will be sent.
- `HOSTS_URL`: The URL from which the list of hosts and ports will be fetched.

## Usage

### Step 1: Set Environment Variables

Create a `.env` file in the root directory of the project and populate it with the required environment variables:

```dotenv
SMTP_HOST=smtp.example.com
SMTP_PORT=587
SMTP_USERNAME=your-smtp-username
SMTP_PASSWORD=your-smtp-password
FROM_EMAIL=kevin@example.com
TO_EMAIL=alert-recipient@example.com
HOSTS_URL=https://example.com/hosts.csv
```

### Step 2: Build and Run the Docker Container

Use the provided `docker-compose.yml` file to build and run the Docker container:

```sh
docker-compose up --build
```

This command will build the Docker image and start the monitoring service.

### Step 3: Monitor Hosts

The service will automatically start monitoring the hosts specified in the CSV file at the `HOSTS_URL`. If any host is down, an email alert will be sent to the `TO_EMAIL` address.

## Code Overview

### `docker-compose.yml`

Defines the Docker service for the monitoring application and passes environment variables to the container.

### `monitoring.py`

Contains the main logic for fetching the list of hosts, checking their availability, and sending email alerts if any host is down.

- **`fetch_hosts_from_url(url)`**: Fetches the list of hosts and ports from the specified URL.
- **`check_host(host, port, timeout=5)`**: Checks if a host is available by attempting to create a socket connection.
- **`send_email(subject, body)`**: Sends an email with the specified subject and body.
- **`monitor_hosts()`**: Main function that orchestrates fetching hosts, checking their availability, and sending alerts if necessary.

### Running the Script Manually

To run the monitoring script manually, ensure you have the required environment variables set, then execute the script:

```sh
python monitoring.py
```

## License

This project is licensed under the MIT License.


## Contact

For any inquiries, please contact [kevin@maila.ai](mailto:kevin@maila.ai).

---

This README provides an overview of the project, instructions for setting it up, and details on how to run the service both with Docker and manually.