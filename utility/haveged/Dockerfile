#
# Provide entropy (haveged) to the host machine (when run as privileged)
#
# VERSION               2.0.1
#
FROM alpine:3.8

RUN apk add --no-cache haveged
ENTRYPOINT ["haveged"]
CMD ["-F"]