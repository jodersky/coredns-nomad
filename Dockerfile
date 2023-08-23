FROM golang:1.21.0
RUN apk update && apt add make
WORKDIR /app

RUN git clone https://github.com/coredns/coredns
RUN echo "nomad:github.com/ituoga/coredns-nomad" >> coredns/plugin.cfg
WORKDIR /app/coredns
RUN go mod download

# RUN CGO_ENABLED=0 go build -o /coredns
RUN make

FROM scratch
WORKDIR /
COPY --from=0 /coredns /

EXPOSE 53

ENTRYPOINT ["/coredns"]