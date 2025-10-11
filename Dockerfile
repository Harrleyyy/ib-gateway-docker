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

# API Port freigeben
EXPOSE 7497

# IB Gateway starten
CMD ["bin/run.sh", "root/conf.yaml"]
