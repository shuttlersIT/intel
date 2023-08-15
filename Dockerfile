FROM golang:1.19.0-alpine AS builder

# Support CGO and SSL
RUN apk --no-cache add gcc g++ make
RUN apk add git

WORKDIR /intel

ENV GO111MODULE=on
ENV GOFLAGS=-mod=vendor

#RUN go get -d -v golang.org/x/net/html

COPY go.mod go.sum ./
RUN go mod download
RUN go mod vendor
RUN go mod verify

COPY . ./
RUN ls -la ./*

# Build
RUN CGO_ENABLED=0 GOOS=linux go build -a -o /intel

FROM alpine:latest

# Must have packages
RUN apt-get update && apt-get install -y vim nano zsh curl git sudo

RUN apk --no-cache add ca-certificates

ENV GO111MODULE=on
ENV GOFLAGS=-mod=vendor

WORKDIR / 

COPY templates/ templates/
COPY --from=builder /intel /intel

# Add none root user
RUN  useradd admin && echo "admin:admin" | chpasswd && adduser admin sudo
USER admin

EXPOSE 9193

ENTRYPOINT [ "./intel" ]