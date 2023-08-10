FROM golang:1.17.0-alpine AS builder

ENV APP_HOME /go/src/intel

WORKDIR "$APP_HOME"
COPY src/ .

RUN go mod download
RUN go mod verify
RUN go build -o intel

FROM alpine

RUN adduser -S -D -H -h "$APP_HOME"/intel intel
USER intel

ENV APP_HOME /go/src/intel

RUN mkdir -p "$APP_HOME"

WORKDIR "$APP_HOME"

COPY src/templates/ templates/
COPY src/conf/ conf/
COPY src/database/ database/
COPY src/handlers/ handlers/
COPY src/middleware/ middleware/
COPY src/structs/ structs/
COPY src/vendor/ vendors/

COPY --from=builder "$APP_HOME"/intel "$APP_HOME"

EXPOSE 9193
CMD ["./intel"]