# Stage 1: Build stage
FROM python:3.9-slim-buster AS build

WORKDIR /app

# Copy only the requirements file first
COPY requirements.txt ./

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Final stage
FROM python:3.9-slim-buster

WORKDIR /app

# Copy installed packages from the build stage
COPY --from=build /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages

# Now copy the rest of the application code
COPY . /app

# Install PostgreSQL client
RUN apt-get update && apt-get install -y postgresql-client && rm -rf /var/lib/apt/lists/*

# Copy wait-for-postgres.sh and make it executable
COPY ./wait-for-postgres.sh /wait-for-postgres.sh
RUN chmod +x /wait-for-postgres.sh

EXPOSE 80

CMD ["/wait-for-postgres.sh", "postgres", "uvicorn", "app:app", "--host", "0.0.0.0", "--port", "80"]
