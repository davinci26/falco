
FROM golang:1.18 AS build

WORKDIR /workspace

COPY go.mod go.sum ./
RUN go mod download

COPY ./ ./

RUN VERSION=$(git rev-parse HEAD) && apt-get update && apt-get -y install libpcre++-dev && go build \
		 -ldflags "-X main.version=$VERSION" \
		 -o /build/falco ./cmd/falco

FROM ubuntu
COPY --from=build /build/falco /
ENTRYPOINT ["/falco"]
