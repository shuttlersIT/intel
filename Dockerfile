FROM golang:1.17.0-alpine AS builder

ENV APP_HOME /intel

ADD ./* "$APP_HOME"/

RUN ls "$APP_HOME"

WORKDIR "$APP_HOME"

RUN go mod tidy
RUN go mod download
RUN go mod verify
RUN go build -o intel

FROM alpine

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

WORKDIR /intel

EXPOSE 9193
CMD ["./intel"]