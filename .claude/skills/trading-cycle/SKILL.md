---
name: trading-cycle
description: Der komplette Ablauf eines Bot-Zyklus im Investment-Büro auf dem IBKR-Paper-Trading-Account (Chef koordiniert Research, Entscheidung, Ausführung). Immer verwenden, wenn ein geplanter Trading-Zyklus ausgelöst wird (z.B. durch die tägliche Claude-Code-Routine) oder der Nutzer "führe einen Trading-Zyklus aus" o.ä. sagt.
---

# Trading-Zyklus

Du (diese Session) bist der **Chef**: einzige Instanz mit
Entscheidungsgewalt. Du vergibst Aufträge an Subagenten und triffst die
Kauf-/Verkaufsentscheidung selbst - delegiere sie nicht.

Voraussetzung: `GATEWAY_URL` zeigt auf den deployten Paper-Gateway,
`.env`/Render-Env-Vars sind gesetzt. Falls unklar, zuerst über den
execution-trader-Agenten `status` prüfen.

## Ablauf

1. **Kontostand & Positionen lesen**
   Beauftrage `execution-trader` mit einer reinen Lese-Anfrage
   (Positionen + Kontostand). Kein Trade in diesem Schritt.

2. **Kandidaten sammeln**
   - Alle Ticker aus `watchlist.md`
   - Alle Ticker aus den aktuell offenen Positionen (für den
     Quartals-Stop-Check gemäß Skill `aktien-research`)

3. **Research parallelisieren**
   Für jeden Kandidaten-Ticker EINEN `research-analyst`-Subagenten
   parallel starten (nicht sequenziell - das ist der Punkt, an dem
   Parallelisierung tatsächlich Zeit/Kosten spart). Warte auf alle
   Ergebnisse, bevor du entscheidest.

4. **Entscheiden (deine Aufgabe, nicht delegierbar)**
   Wende auf jedes Research-Ergebnis die Regeln aus
   `aktien-research` an:
   - Offene Position: Zwei von drei Stop-Kriterien gerissen ->
     verkaufen. Chase-Bremse/Tranchen-Regeln bei Nachkäufen beachten.
   - Neuer Kandidat: Kernraster + Beta-Positionsgrößen-Tabelle (Depot A)
     -> erste Tranche (40%, oder 25% falls Chase-Bremse ausgelöst) nur
     wenn die Kriterien überwiegend erfüllt sind.
   - Bei Unsicherheit: nichts tun ist eine gültige Entscheidung. Der
     Bot muss nicht bei jedem Zyklus etwas kaufen.
   Halte deine Begründung kurz schriftlich fest (kommt ins Order-Log
   über den execution-trader).

5. **Ausführen**
   Für jede beschlossene Order: `execution-trader` mit der fertigen,
   konkreten Anweisung beauftragen (Konto, Ticker/conid, Seite, Menge,
   Limit-Preis, **plus die drei Stop-Kriterien, die execution-trader mit
   loggen soll** - der strategy-reviewer braucht sie später).

6. **Kurz zusammenfassen**
   Am Ende eine kompakte Zyklus-Zusammenfassung ausgeben: geprüfte
   Ticker, Entscheidungen, ausgeführte Orders, nichts-getan-Fälle mit
   Grund.

## Nicht Teil dieses Zyklus

- Strategie-Review (siehe Subagent `strategy-reviewer`, läuft auf
  eigenem, selteneren Trigger - nicht bei jedem Zyklus mitlaufen
  lassen).
- Änderungen an `aktien-research`/SKILL.md - das bleibt eine bewusste
  Entscheidung des Nutzers.
