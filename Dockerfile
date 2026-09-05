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

# Eigene conf.yaml über das von IBeam vorgesehene Inputs-Verzeichnis
# einspeisen (überschreibt die Standard-conf.yaml des Gateways beim Start).
# Siehe conf/conf.yaml für die Begründung der Anpassungen (IP-Allowlist,
# HTTPS mit selbstsigniertem Zertifikat - IBeams eigene Login-Automatisierung
# braucht das intern zwingend, siehe Kommentar dort).
COPY conf/conf.yaml /srv/inputs/conf.yaml

EXPOSE 5000

# /v1/api/tickle antwortet bereits, wenn das Gateway-Prozess läuft
# (unabhängig vom Auth-Status) - reicht als reiner Liveness-Check.
# -k: das Gateway nutzt ein selbstsigniertes Zertifikat (IBKR-Standard).
HEALTHCHECK --interval=30s --timeout=5s --start-period=120s --retries=3 \
  CMD curl -skf https://localhost:5000/v1/api/tickle || exit 1
