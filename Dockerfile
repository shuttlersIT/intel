FROM golang:1.19.0-alpine AS builder

WORKDIR /intel

ENV GO111MODULE=on
ENV GOFLAGS=-mod=vendor

RUN go get -d -v golang.org/x/net/html

COPY go.mod go.sum ./
RUN go mod download
RUN go mod vendor
RUN go mod verify

COPY . ./
RUN ls -la ./*

# Build
RUN CGO_ENABLED=0 GOOS=linux go build -a -o /intel-app

FROM alpine:latest

ENV GO111MODULE=on
ENV GOFLAGS=-mod=vendor

WORKDIR / 

COPY templates/ templates/
COPY --from=builder /intel-app /intel-app

EXPOSE 9193

USER oluwaseyi_yusuf:oluwaseyi_yusuf

CMD ["./intel-app"]