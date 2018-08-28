FROM alpine
MAINTAINER "Vadim Isaev" <vadim.o.isaev@gmail.com>

RUN apk add gettext

VOLUME /src
WORKDIR /src

COPY *.sh /

CMD ["/cmd.sh"]
