FROM alpine:3.23.3
RUN apk update
RUN apk upgrade
RUN apk add nano openssh rsync bash
RUN mkdir -p /root/.ssh && ssh-keygen -q -b 4096 -t rsa -f /root/.ssh/id_rsa -N ""
COPY entrypoint.sh /entrypoint.sh
COPY sync_utility.sh /root/.bashrc
RUN chmod +x /entrypoint.sh
# ENTRYPOINT ["/entrypoint.sh"]
