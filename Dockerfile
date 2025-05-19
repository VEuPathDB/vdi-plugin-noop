FROM amazoncorretto:24-alpine3.21

ENV LANG=en_US.UTF-8 \
  JVM_MEM_ARGS="-Xms4m -Xmx32m" \
  JVM_ARGS="" \
  TZ="America/New_York" \
  PATH=/opt/veupathdb/bin:$PATH

RUN apk add --no-cache wget musl-locales tzdata \
  && cp /usr/share/zoneinfo/America/New_York /etc/localtime \
  && echo ${TZ} > /etc/timezone

COPY bin/ /opt/veupathdb/bin

RUN chmod +x /opt/veupathdb/bin/*

ARG PLUGIN_SERVER_VERSION=v8.2.0-beta.4
RUN wget "https://github.com/VEuPathDB/vdi-plugin-handler-server/releases/download/${PLUGIN_SERVER_VERSION}/service.jar" \
  -O vdi-plugin-noop.jar

CMD java -jar \
  -XX:+CrashOnOutOfMemoryError \
  -XX:+HeapDumpOnOutOfMemoryError \
  $JVM_MEM_ARGS \
  $JVM_ARGS \
  vdi-plugin-noop.jar
