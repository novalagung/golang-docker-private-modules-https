FROM golang:alpine

RUN apk update && apk add --no-cache git

ARG GITHUB_TOKEN

RUN git config --global --add url."https://${GITHUB_TOKEN}:@github.com/novalagung".insteadOf "https://github.com/novalagung"

ENV GOPRIVATE=github.com/novalagung

# optional env vars depending on the go version & network access
ENV GO111MODULE=on
ENV GOPROXY=direct

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go build -o executable

ENTRYPOINT ["./executable"]