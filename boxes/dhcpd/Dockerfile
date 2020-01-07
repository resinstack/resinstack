FROM alpine:3.10
RUN apk --no-cache add dnsmasq
EXPOSE 53 53/udp
EXPOSE 67/udp

ENTRYPOINT ["dnsmasq", "-k"]

COPY dnsmasq.conf /etc/dnsmasq.conf
