FROM alpine:3.23.3
RUN apk update
RUN apk upgrade
RUN apk add nano openssh rsync bash
COPY entrypoint.sh /entrypoint.sh
COPY .bashrc /root/.bashrc
COPY ../deploy-util /root/deploy-util
RUN chmod +x /entrypoint.sh
WORKDIR /var/www/html
RUN mkdir -p /root/.ssh/
RUN touch /root/.ssh/authorized_keys
RUN touch /root/.ssh/config
RUN touch /root/.ssh/known_hosts
RUN mkdir -p /root/.ssh \
    && chown root:root /root/.ssh \
    && chmod 700 /root/.ssh \
    && [ -f /root/.ssh/authorized_keys ] && chmod 600 /root/.ssh/authorized_keys || true \
    && [ -f /root/.ssh/known_hosts ] && chmod 644 /root/.ssh/known_hosts || true
RUN mkdir -p /root/.ssh \
    && chown -R root:root /root/.ssh \
    && chmod 700 /root/.ssh \
    && find /root/.ssh -type f -name "id_*" ! -name "*.pub" -exec chmod 600 {} \; \
    && find /root/.ssh -type f -name "*.pub" -exec chmod 644 {} \; \
    && find /root/.ssh -type f -name "authorized_keys" -exec chmod 600 {} \; \
    && find /root/.ssh -type f -name "known_hosts" -exec chmod 644 {} \;
# ENTRYPOINT ["/entrypoint.sh"]
