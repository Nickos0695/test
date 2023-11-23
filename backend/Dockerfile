FROM golang:1.19
# Set destination for COPY
WORKDIR /app
# Download Go modules
COPY . .
RUN go mod download
# Build
RUN CGO_ENABLED=1 GOOS=linux go build -o /backend
# Optional:
# To bind to a TCP port, runtime parameters must be supplied to the docker command.
# But we can document in the Dockerfile what ports
# the application is going to listen on by default.
# https://docs.docker.com/engine/reference/builder/#expose
EXPOSE 5000

# Run
CMD ["/backend"]