# Basiert auf dem offiziellen IBeam-Image (https://github.com/Voyz/ibeam).
# IBeam bündelt den echten IBKR Client Portal Gateway und automatisiert
# zusätzlich den Login (Username/Passwort headless per Selenium, optional
# TOTP-2FA via IBEAM_TWO_FA_HANDLER=PYOTP) sowie den Tickle-Keepalive, der
# die Session am Leben hält. Das ersetzt die vorherige, rein manuelle
# clientportal.gw-Installation, die für einen unbeaufsichtigten Bot nicht
# ausreichte (kein Auto-Login, falscher Port 7497 statt 5000).
#
# WICHTIG: Push-2FA über die IBKR-Mobile-App kann NICHT automatisiert
# werden (IBeam unterstützt das nicht). Für vollautomatischen Login muss
# im IBKR-Konto ein TOTP-fähiger Authenticator als 2FA-Methode aktiv sein.
FROM voyz/ibeam:latest

# Das in voyz/ibeam:latest gebündelte Gateway-JAR ist von April 2023
# (bestätigt durch unsere eigenen Logs: "version: ... Mon, 24 Apr 2023")
# und kann keine funktionierende Verbindung zu IBKRs Backend aufbauen -
# bekanntes, offenes Upstream-Problem (github.com/Voyz/ibeam Issue #279).
# Symptom bei uns: durchgehendes 404 auf /v1/api/iserver/auth/status ab
# dem allerersten Versuch, unabhängig von jeder eigenen Config-Änderung.
# Von dort übernommener, von einem anderen Nutzer bestätigter Workaround:
# aktuelle clientportal.gw direkt von IBKR laden und die veraltete
# dist/-JAR damit überschreiben.
RUN curl -sL https://download2.interactivebrokers.com/portal/clientportal.gw.zip -o /tmp/cpgw.zip \
    && python3 -c "import zipfile; zipfile.ZipFile('/tmp/cpgw.zip').extractall('/tmp/cpgw')" \
    && rm -rf /srv/clientportal.gw/dist \
    && cp -r /tmp/cpgw/dist /srv/clientportal.gw/ \
    && rm -rf /tmp/cpgw.zip /tmp/cpgw

# Eigene conf.yaml über das von IBeam vorgesehene Inputs-Verzeichnis
# einspeisen (überschreibt die Standard-conf.yaml des Gateways beim Start).
# Siehe conf/conf.yaml für die Begründung der Anpassungen (IP-Allowlist,
# HTTPS mit selbstsigniertem Zertifikat - IBeams eigene Login-Automatisierung
# braucht das intern zwingend, siehe Kommentar dort).
COPY conf/conf.yaml /srv/inputs/conf.yaml

EXPOSE 5000

# "/" liefert die Login-Seite selbst aus und antwortet unabhängig vom
# Auth-Status zuverlässig - reicht als reiner Liveness-Check.
# /v1/api/tickle wurde hier bewusst NICHT genommen: es antwortet
# manchmal mit 404, solange IBeam noch mit Login/Status-Checks
# beschäftigt ist, was Render dazu brachte den Service ständig neu zu
# starten statt den Login fertig laufen zu lassen.
# -k: das Gateway nutzt ein selbstsigniertes Zertifikat (IBKR-Standard).
HEALTHCHECK --interval=30s --timeout=5s --start-period=120s --retries=3 \
  CMD curl -skf https://localhost:5000/ || exit 1
