FROM golang:1.19.0-alpine AS builder

WORKDIR /intel

ENV GO111MODULE=on
ENV GOFLAGS=-mod=vendor

COPY intel/ /intel/
RUN ls --recursive /intel/

RUN go mod tidy
RUN go mod vendor
RUN go mod verify

RUN go get -d -v golang.org/x/net/html

# Build
RUN CGO_ENABLED=0 GOOS=linux go build -o /intel-app

FROM alpine:latest

ENV GO111MODULE=on
ENV GOFLAGS=-mod=vendor

WORKDIR / 

COPY templates/ templates/
COPY --from=builder /intel-app /intel-app

EXPOSE 9193

USER oluwaseyi_yusuf:oluwaseyi_yusuf

CMD ["./intel-app"]