# Use the official Python base image
FROM python:3.9

# Set the working directory
WORKDIR /app

# Copy the requirements file
COPY requirements.txt .

# Install the dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Install FastAPI and Uvicorn
RUN pip install fastapi uvicorn

# Copy the application code
COPY . .

# Expose the port on which the API will run
EXPOSE 8611

# Run the application
CMD ["python", "monitoring.py"]