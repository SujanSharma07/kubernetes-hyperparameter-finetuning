# Use a base Python image
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Install the required packages
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the local files to the container
COPY . .

# Command to run the Python script
CMD ["python", "train.py"]
