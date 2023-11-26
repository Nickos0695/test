FROM golang:1.19
# Set destination for COPY
WORKDIR /app
# Download Go modules
COPY . .
RUN go mod download
# Build
RUN CGO_ENABLED=1 GOOS=linux go build -o /backend
# Expose port 5000
EXPOSE 5000
# Run
CMD ["/backend"]