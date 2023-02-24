# ======= build stage =======
FROM golang:alpine as stage-build

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

# ======= release stage =======
FROM alpine:latest as stage-release

COPY --from=stage-build /app/executable /

ENTRYPOINT ["/executable"]
