# IB Gateway Docker – Paper-Trading-Bot

Ein "Büro" aus Claude-Agenten, das auf einem **IBKR-Paper-Trading-Account**
(Testkonto, kein echtes Geld) recherchiert, entscheidet und Orders
ausführt - budgetneutral: kein separater Anthropic-API-Key, kein
bezahltes Hosting, nur das bestehende Claude-Abo und Render Free Tier.

## Rollen im Büro

| Rolle | Wo | Aufgabe |
|---|---|---|
| Chef | Claude-Code-Routine (Hauptsession) | trifft die Kauf-/Verkaufsentscheidung, delegiert |
| Research-Analyst | Subagent, parallel pro Ticker | Analyse nach `aktien-research`-Skill |
| Execution-Trader | Subagent | einziger Zugriff auf das Gateway, führt Orders aus |
| Strategy-Reviewer | Subagent, periodisch | prüft Entscheidungen im Nachhinein, schreibt Reports |

Details zum Ablauf: `.claude/skills/trading-cycle/SKILL.md`.
Die Strategie selbst: `.claude/skills/aktien-research/SKILL.md`.

## Setup

Schritt-für-Schritt-Anleitung (Render-Deploy, Paper-Zugangsdaten,
Keepalive-Ping, Claude-Code-Routine einrichten) in
[`docs/SETUP.md`](docs/SETUP.md) - inklusive der Punkte, die noch nicht
live getestet sind.

## Repo-Struktur

```
Dockerfile           IBeam-basiertes Gateway-Image
conf/conf.yaml        Gateway-Konfiguration (IP-Allowlist, HTTP statt HTTPS für Render)
docker-compose.yml    Lokales Testen vor dem Render-Deploy
render.yaml           Render-Blueprint (Free Tier)
scripts/gateway_client.py   CLI gegen die IBKR-REST-API (nur execution-trader nutzt das)
.claude/agents/       Subagenten-Definitionen
.claude/skills/       aktien-research (Strategie) + trading-cycle (Ablauf)
watchlist.md          Manuell gepflegte Kandidatenliste für den Research-Schritt
logs/, reports/       Entstehen zur Laufzeit (Order-Log, Review-Reports)
```
