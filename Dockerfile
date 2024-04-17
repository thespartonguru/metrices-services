# Use the official Go image as a parent image for building
FROM golang:latest AS builder

# Set the working directory inside the container for cpu_usage_tracker
WORKDIR /go/src/app/cpu_usage_tracker

# Copy the local package files to the container's working directory for cpu_usage_tracker
COPY cpu_usage_tracker .

# Build the Go app for cpu_usage_tracker
RUN go build -o cpu_usage_tracker .

# Set the working directory inside the container for db_insight
WORKDIR /go/src/app/db_insight

# Copy the local package files to the container's working directory for db_insight
COPY db_insight .

# Build the Go app for db_insight
RUN go build -o db_insight .

# Final stage: Use a small base image for the executables
FROM alpine:latest

# Set the working directory inside the container
WORKDIR /root

# Copy the pre-built binaries from the previous stage
COPY --from=builder /go/src/app/cpu_usage_tracker/cpu_usage_tracker .
COPY --from=builder /go/src/app/db_insight/db_insight .

# Make the binaries executable
RUN chmod +x cpu_usage_tracker db_insight

# Command to run both services simultaneously
CMD ["./cpu_usage_tracker"]CMD ["./db_insight"]

EXPOSE 8080