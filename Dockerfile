FROM golang:1.19.0-alpine AS builder

ENV APP_HOME /intel

RUN mkdir "$APP_HOME"

# Fetch dependencies.
COPY go.mod .
COPY go.sum .
RUN go mod download
RUN go mod vendor
RUN go mod verify
COPY . "$APP_HOME"/

RUN ls "$APP_HOME"

WORKDIR "$APP_HOME"

RUN go build -o intel

FROM alpine
ENV APP_HOME /intel

RUN adduser -S -D -H -h /intel intel
USER intel

COPY --from=builder "$APP_HOME"/intel /intel/

COPY templates/ /intel/templates
COPY conf/ /intel/conf
COPY database/ /intel/database
COPY handlers/ /intel/handlers
COPY middleware/ /intel/middleware
COPY structs/ /intel/structs
COPY vendor/ /intel/vendors

WORKDIR "$APP_HOME"

EXPOSE 9193
CMD ["./intel"]