FROM golang:1.14.9-alpine AS builder
RUN mkdir /intel
COPY . /intel/
RUN ls -la /intel/
RUN cd /intel
RUN go mod download
RUN go mod vendor
RUN go mod verify
WORKDIR /intel
RUN go intel

FROM alpine
RUN adduser -S -D -H -h /intel intel
USER intel
COPY --from=builder /intel/intel /intel/
COPY templates/ /intel/templates
COPY conf/ /intel/conf
COPY database/ /intel/database
COPY handlers/ /intel/handlers
COPY middleware/ /intel/middleware
COPY structs/ /intel/structs
COPY vendor/ /intel/vendors
WORKDIR /intel
CMD ["./main"]