FROM scratch

COPY ./build/go-serve /go/bin/go-serve

EXPOSE 8085

ENTRYPOINT ["/go/bin/go-serve"]
