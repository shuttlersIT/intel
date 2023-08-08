# build stage
FROM golang:latest AS builder
# working directory
WORKDIR /go/src/github.com/shuttlersIT/intel

# Installing dependencies
COPY go.mod go.sum ./
RUN go mod download
RUN go mod vendor
RUN go mod verify
# install html package
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .
# final stage
FROM alpine:latest
# working directory
WORKDIR /go/src/github.com/shuttlersit/intel
RUN mkdir -p templates
# copy the binary file into working directory
COPY --from=builder /go/src/github.com/shuttlersIT/intel/main .
# copy the templates into working directory
COPY --from=builder /go/src/github.com/shuttlersIT/intel /go/src/github.com/shuttlersIT/intel
RUN cd intel/templates && ls -lh
# Run the contact_registry command when the container starts.
CMD ["./main"]
# http server listens on port 8080
EXPOSE 9193