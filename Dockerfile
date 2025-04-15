# Any base image may be used as long as java21 is installed and the plugin
# server is downloaded into it by runtime.
FROM veupathdb/vdi-plugin-base:8.1.3

COPY bin/ /opt/veupathdb/bin
COPY lib/ /opt/veupathdb/lib

RUN chmod +x /opt/veupathdb/bin/*
