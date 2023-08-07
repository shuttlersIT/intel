# build stage
FROM golang:latest AS builder
# working directory
WORKDIR /go/src/github.com/shuttlersIT/intel
# install html package
RUN go install -d -v golang.org/x/net/html
COPY main.go    .
RUN mkdir -p templates
# copy the templates into working directory
COPY templates /go/src/github.com/shuttlersIT/intel/templates
# rebuilt built in libraries and disabled cgo
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .
# final stage
FROM alpine:latest
# working directory
WORKDIR /go/src/github.com/shuttlersit/intel
RUN mkdir -p templates
# copy the binary file into working directory
COPY --from=builder /go/src/github.com/shuttlersIT/intel/main .
# copy the templates into working directory
COPY --from=builder /go/src/github.com/shuttlersIT/intel/templates /go/src/github.com/shuttlersIT/intel/templates
RUN cd templates && ls -lh
# Run the contact_registry command when the container starts.
CMD ["./main"]
# http server listens on port 8080
EXPOSE 9193