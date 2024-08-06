# Stage 1: Build stage
FROM python:3.10-slim-buster AS build

WORKDIR /app

# Copy only the requirements file first
COPY requirements.txt ./

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Final stage
FROM python:3.10-slim-buster

WORKDIR /app

# Copy installed packages from the build stage
COPY --from=build /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages

# Now copy the rest of the application code
COPY . /app

EXPOSE 80

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "80"]
