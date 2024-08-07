# Dockerfile
FROM langservice2dependencies:latest

WORKDIR /app

# Copy the rest of the application code
COPY . /app

EXPOSE 80

CMD ["/usr/local/bin/uvicorn", "app:app", "--host", "0.0.0.0", "--port", "80"]
