# ib-gateway-docker

Autonomer Multi-Agenten-Trading-Bot auf einem **IBKR-Paper-Trading-
Account** (Testkonto, kein echtes Geld). Läuft budgetneutral: keine
separate Anthropic-API-Abrechnung, keine bezahlte Hosting-Stufe.

## Architektur in Kürze

- **Gateway** (dieses Repo, Dockerfile): IBKR Client Portal Gateway via
  [IBeam](https://github.com/Voyz/ibeam), auf Render Free Tier deployed,
  per externem Ping-Dienst wach gehalten. Siehe `docs/SETUP.md`.
- **Agenten-Büro** (`.claude/agents/`, `.claude/skills/`): läuft als
  Claude-Code-Routine (nutzt das bestehende Pro/Max-Abo, keine
  Extra-Kosten). Diese Session/Routine ist der **Chef** und delegiert an:
  - `research-analyst` - Recherche pro Ticker (parallelisierbar)
  - `execution-trader` - einziger Zugriff auf `scripts/gateway_client.py`
  - `strategy-reviewer` - periodisches Review, ändert nichts selbst
- **Strategie**: `.claude/skills/aktien-research/SKILL.md` (Davids
  Original-Research-Framework, unverändert übernommen). Der Paper-
  Account wird darin wie **Depot A** behandelt.
- **Ablauf eines Zyklus**: `.claude/skills/trading-cycle/SKILL.md`.

## Wichtige Grundsätze für jede Änderung an diesem Repo

1. **Kein separater Anthropic-API-Key, kein bezahltes Hosting.** Das ist
   eine explizite Nutzervorgabe (Budget 0 €), nicht optional.
2. **Nur der `execution-trader`-Agent spricht mit dem Gateway.** Andere
   Agenten bekommen keinen Bash-Zugriff auf `scripts/gateway_client.py`.
3. **Reale Zugangsdaten nie in Dateien, die committed werden.** Immer
   `.env` (git-ignored) bzw. Render-Dashboard-Env-Vars.
4. **`aktien-research/SKILL.md` nicht eigenmächtig ändern.** Nur der
   Nutzer entscheidet über Strategieänderungen; `strategy-reviewer`
   schreibt Vorschläge nach `reports/`, nicht in die Skill-Datei.
5. Dieses Setup ist für den **Paper-Account** gebaut. Vor jeder
   Erweiterung Richtung echtem Geld: siehe Sicherheitshinweise in
   `docs/SETUP.md` - die IP-Allowlist im Gateway (`conf/conf.yaml`) ist
   bewusst offen (`0.0.0.0/0`), das ist nur für ein Testkonto vertretbar.

## Vor dem ersten Zyklus

`pip install -r scripts/requirements.txt` (nur `requests`) muss in der
Umgebung verfügbar sein, in der `execution-trader` läuft, sonst schlägt
jeder `gateway_client.py`-Aufruf fehl.

## Offene/ungetestete Punkte

Siehe `docs/SETUP.md`, Abschnitt "Bekannte Risiken" - insbesondere
RAM-Limit auf Render Free Tier für den Selenium-Login-Schritt und
`listenSsl: false` hinter Renders TLS-Terminierung. Beides ist begründet
gewählt, aber nicht live verifiziert.
