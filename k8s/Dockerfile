# inspire from https://github.com/uphold/docker-litecoin-core/blob/master/0.18/Dockerfile
FROM bitnami/minideb

LABEL maintainer="Benjamin MIXTE (@bmixte)"

ENV LITECOIN_VERSION="0.21.2.1"
ENV LITECOIN_DATA="/home/litecoin/.litecoin"

# Sample of download link https://download.litecoin.org/litecoin-0.21.2.1/linux/litecoin-0.21.2.1-x86_64-linux-gnu.tar.gz
# Corresponding asc file https://download.litecoin.org/litecoin-0.21.2.1/linux/litecoin-0.21.2.1-x86_64-linux-gnu.tar.gz.asc
# Official documentation for GPG verify https://download.litecoin.org/README-HOWTO-GPG-VERIFY.txt
# Version 0.21.2 have been signed with https://download.litecoin.org/litecoin-0.21.2.1/davidburkett38-key.pgp

RUN set -x && groupadd litecoin \
    && useradd -s /bin/sh -r -m -g litecoin litecoin \
    && apt update -y \
    && apt upgrade -y \
    && apt install -y curl gnupg
WORKDIR /home/litecoin/
RUN curl --output davidburkett38-key.pgp https://download.litecoin.org/litecoin-0.21.2.1/davidburkett38-key.pgp \
    && gpg --import davidburkett38-key.pgp \
    && curl --output litecoin-${LITECOIN_VERSION}-x86_64-linux-gnu.tar.gz https://download.litecoin.org/litecoin-${LITECOIN_VERSION}/linux/litecoin-${LITECOIN_VERSION}-x86_64-linux-gnu.tar.gz \
    && curl --output litecoin-${LITECOIN_VERSION}-x86_64-linux-gnu.tar.gz.asc https://download.litecoin.org/litecoin-${LITECOIN_VERSION}/linux/litecoin-${LITECOIN_VERSION}-x86_64-linux-gnu.tar.gz.asc \
    && gpg --verify litecoin-${LITECOIN_VERSION}-x86_64-linux-gnu.tar.gz.asc \
    && tar -xzf litecoin-${LITECOIN_VERSION}-x86_64-linux-gnu.tar.gz \
    && chown -R litecoin:litecoin /home/litecoin \
    &&  mkdir -p "$LITECOIN_DATA" \
    && chmod 770 "$LITECOIN_DATA" || echo "Could not chmod $LITECOIN_DATA (may not have appropriate permissions)" \
    && chown -R litecoin "$LITECOIN_DATA" || echo "Could not chown $LITECOIN_DATA (may not have appropriate permissions)"
RUN apt purge --autoremove -y --allow-remove-essential curl gnupg libtinfo6 \
# to keep libc-bin libcom-err2 libdb5.3 libgcrypt20 libgnutls30 libpcre2-8-0 libtirpc-common perl-base zlib1g
    && apt -y clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* litecoin-${LITECOIN_VERSION}-x86_64-linux-gnu.tar.gz*

RUN apt list --installed
VOLUME ["/home/litecoin/.litecoin"]

USER litecoin

EXPOSE 9333

ENTRYPOINT ["sh","-c","./litecoin-${LITECOIN_VERSION}/bin/litecoind"]