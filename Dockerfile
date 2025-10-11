FROM ubuntu:22.04

# IB Gateway installieren
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    openjdk-11-jre \
    && rm -rf /var/lib/apt/lists/*

# IB Gateway herunterladen und entpacken
RUN wget -q https://download2.interactivebrokers.com/portal/clientportal.gw.zip && \
    unzip clientportal.gw.zip -d /ibgateway && \
    rm clientportal.gw.zip

WORKDIR /ibgateway

# API Port freigeben (Render.com benötigt 7497)
EXPOSE 7497

# Health Check für Render.com
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:5000 || exit 1

# IB Gateway starten mit API Port
CMD ["bin/run.sh", "root/conf.yaml", "--port=7497"]
