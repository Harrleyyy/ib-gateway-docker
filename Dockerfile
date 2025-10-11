FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    openjdk-11-jre \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN wget -q https://download2.interactivebrokers.com/portal/clientportal.gw.zip && \
    unzip clientportal.gw.zip -d /ibgateway && \
    rm clientportal.gw.zip

WORKDIR /ibgateway

EXPOSE 5000 7497

# Health Check für Render.com
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:5000 || exit 1

CMD ["bin/run.sh", "root/conf.yaml", "--port=7497"]
