# Stage 2: Final stage
FROM langservice3dependencies:latest

WORKDIR /app

# Now copy the rest of the application code
COPY . /app

# Copy wait-for-postgres.sh and make it executable
COPY ./wait-for-postgres.sh /wait-for-postgres.sh
RUN chmod +x /wait-for-postgres.sh

EXPOSE 80

CMD ["/wait-for-postgres.sh", "postgres", "uvicorn", "app:app", "--host", "0.0.0.0", "--port", "80"]
