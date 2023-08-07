# build stage
FROM golang:latest AS builder
# working directory
WORKDIR /go/src/github.com/shuttlersit/intel
# install html package
RUN go get -d -v golang.org/x/net/html
COPY main.go    .
RUN mkdir -p templates
# copy the templates into working directory
COPY views /go/src/github.com/shuttlersit/intel
# rebuilt built in libraries and disabled cgo
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .
# final stage
FROM alpine:latest
# working directory
WORKDIR /go/src/github.com/shuttlersit/intel
RUN mkdir -p views
# copy the binary file into working directory
COPY --from=builder /go/src/github.com/shuttlersit/intel/main .
# copy the templates into working directory
COPY --from=builder /go/src/github.com/shuttlersit/intel/templates /go/src/github.com/shuttlersit/intel/templates
RUN cd templates && ls -lh
# Run the contact_registry command when the container starts.
CMD ["./main"]
# http server listens on port 8080
EXPOSE 9193