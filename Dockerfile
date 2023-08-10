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
ENV APP_HOME /intel

RUN adduser -S -D -H -h /intel intel
USER intel

COPY --from=builder "$APP_HOME"/intel /intel/

COPY templates/ "$APP_HOME"/templates
COPY conf/ "$APP_HOME"/conf
COPY database/ "$APP_HOME"/database
COPY handlers/ "$APP_HOME"/handlers
COPY middleware/ "$APP_HOME"/middleware
COPY structs/ "$APP_HOME"/structs
COPY vendor/ "$APP_HOME"/vendors

WORKDIR "$APP_HOME"

EXPOSE 9193
CMD ["./intel"]