FROM scratch

COPY ./build/app /go/bin/go-serve

EXPOSE 8085

ENTRYPOINT ["/go/bin/go-serve"]
