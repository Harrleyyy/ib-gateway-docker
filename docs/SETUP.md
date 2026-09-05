# Setup

Reihenfolge einhalten - jeder Schritt baut auf dem vorherigen auf.

## 1. Paper-Trading-Zugangsdaten holen (sobald IBKR freigeschaltet hat)

In der IBKR Account Management unter **Settings → Paper Trading
Account**: eigener Username + eigenes Passwort, getrennt von deinem
Live-Konto. Diese Zugangsdaten kommen NIRGENDS ins Repo, nur in `.env`
(lokal) bzw. die Render-Env-Vars (Deploy).

**2FA prüfen:** Unter Security-Einstellungen nachsehen, welche
Zwei-Faktor-Methode für den Paper-Account aktiv ist:
- **Authenticator-App/TOTP verfügbar** → das nutzen, dann kann der Login
  vollautomatisch laufen (Schritt 3).
- **Nur IBKR-Mobile-Push** → kann nicht automatisiert werden. Der Bot
  läuft dann fast autonom, aber die Gateway-Session braucht alle ~24h
  einmal deine manuelle Bestätigung am Handy.

## 2. Lokal testen

```bash
cp .env.example .env
# .env ausfüllen: IBEAM_ACCOUNT, IBEAM_PASSWORD, ggf. IBEAM_TWO_FA_HANDLER=PYOTP + IBEAM_PYOTP_SECRET
docker compose up --build
```

Nach dem Start (kann beim ersten Mal 1-2 Minuten dauern, Chromium-Login
im Hintergrund):

```bash
curl -sk https://localhost:5000/v1/api/iserver/auth/status
```

(`-k`, weil das Gateway ein selbstsigniertes Zertifikat nutzt - siehe
`conf/conf.yaml`.)

`"authenticated": true` → Login funktioniert. Erst wenn das lokal steht,
weiter zu Render.

## 3. Deploy auf Render (Free Tier)

1. render.com → New → Blueprint → dieses Repo auswählen (nutzt
   `render.yaml`).
2. Im Render-Dashboard die Env-Vars nachtragen, die als `sync: false`
   markiert sind: `IBEAM_ACCOUNT`, `IBEAM_PASSWORD`, ggf.
   `IBEAM_PYOTP_SECRET`.
3. Nach dem Deploy die Render-URL notieren (`https://ib-gateway-paper-XXXX.onrender.com`).
4. Prüfen: `curl -s https://<deine-render-url>/v1/api/iserver/auth/status`

## 4. Keepalive-Ping einrichten (verhindert das Einschlafen)

Kostenloser Ping-Dienst, z. B. [UptimeRobot](https://uptimerobot.com)
oder [cron-job.org](https://cron-job.org):

- Monitor-Typ: HTTP(S)
- URL: `https://<deine-render-url>/v1/api/tickle`
- Intervall: 5 Minuten (jedenfalls deutlich unter Renders
  Inaktivitäts-Timeout)

## 5. Claude-Code-Routine einrichten

Sobald 1-4 funktionieren: `GATEWAY_URL=https://<deine-render-url>` als
Umgebungsvariable in dieser Claude-Code-Remote-Umgebung hinterlegen
(Environment-Einstellungen), damit `scripts/gateway_client.py` die
richtige Adresse findet.

Danach eine Routine erstellen, die z. B. täglich nach US-Marktöffnung
den Trading-Zyklus auslöst (Prompt: etwas wie *"Führe die Skill
trading-cycle aus"*). Das übernehme ich, sobald der Gateway erreichbar
ist und `GATEWAY_URL` gesetzt ist - vorher würde die Routine nur gegen
ein nicht existierendes Gateway laufen.

## Bekannte Risiken (bewusst nicht vorab wegdiskutiert)

1. **RAM auf Render Free Tier.** IBeams eigene Empfehlung für den
   Selenium-Login-Schritt liegt bei 2 GB RAM; Render Free liegt
   typischerweise bei 512 MB. Ob der Login zuverlässig durchläuft, ist
   ungetestet. Falls der Container beim Login abstürzt/neustartet:
   entweder eine knapp bezahlte Render-Stufe für den Login-Moment in
   Kauf nehmen, oder in `docs/` nach einer Chromium-Flag-Optimierung
   suchen (`--single-process`, `--no-zygote` etc.), bevor man das
   Budget-Ziel aufgibt.
2. **HTTPS intern zwingend erforderlich** (`conf/conf.yaml`,
   `listenSsl: true`). Ursprünglich hatten wir das auf `false` gestellt
   in der Annahme, Render leitet intern per HTTP weiter - per
   Render-Deploy-Log widerlegt: IBeams eigene Login-Automatisierung
   lädt intern fest `https://localhost:5000/...` und bricht sonst mit
   SSL-Fehlern ab. Jetzt korrigiert. **Noch offen:** ob Renders externe
   HTTPS-Terminierung (`healthCheckPath` in `render.yaml`, UptimeRobot,
   `gateway_client.py`) sauber zu einem intern per HTTPS laufenden
   Container durchreicht, oder ob dort ein neuer Fehler auftaucht -
   das zeigt erst der nächste Deploy.
3. **`ips.allow: 0.0.0.0/0`** öffnet die Gateway-API für jeden, der die
   Render-URL kennt. Nur vertretbar, weil ausschließlich der Paper-
   Account dahinterhängt - niemals unverändert für ein Live-Konto
   übernehmen.
4. **2FA-Push nicht automatisierbar** (siehe Schritt 1) - falls dein
   Paper-Account keine TOTP-Option anbietet, ist "vollautomatisch" mit
   einer Einschränkung: gelegentliche manuelle Bestätigung nötig.
5. **Render erkennt Ports automatisch zur Laufzeit.** Der Gateway öffnet
   neben 5000 (API) noch einen zweiten, von IBeam nicht dokumentierten
   Port 5001. Ohne festen `PORT`-Wert schaltet Render darauf um und
   startet mitten im Login neu ("New primary port detected"). Per
   `PORT=5000` in `render.yaml` fest gepinnt - falls trotzdem noch
   Port-Wechsel in den Logs auftauchen, das als erstes prüfen.
