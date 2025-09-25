FROM amazoncorretto:24-alpine3.21

ENV LANG=en_US.UTF-8 \
  JVM_MEM_ARGS="-Xms4m -Xmx32m" \
  JVM_ARGS="" \
  TZ="America/New_York" \
  PATH=/opt/veupathdb/bin:$PATH

RUN apk add --no-cache curl musl-locales tzdata \
  && cp /usr/share/zoneinfo/America/New_York /etc/localtime \
  && echo ${TZ} > /etc/timezone

COPY bin/ /opt/veupathdb/bin

RUN chmod +x /opt/veupathdb/bin/*

# VDI PLUGIN SERVER
ARG PLUGIN_SERVER_VERSION=v1.7.0-a13
RUN curl "https://github.com/VEuPathDB/vdi-service/releases/download/${PLUGIN_SERVER_VERSION}/plugin-server.tar.gz" -Lf --no-progress-meter | tar -xz

CMD PLUGIN_ID=noop ./startup.sh
