---
name: aktien-research
description: Vollständiges Aktien-Research-Framework für Davids zwei Depots (eigenes IBKR-Depot und das Trade-Republic-Depot seines Vaters). Nutze diese Skill IMMER, wenn eine Aktie, ein ETF oder ein Investmentthema analysiert, bewertet oder verglichen werden soll, wenn nach Kauf-/Verkaufskandidaten gesucht wird, wenn Positionsgrößen oder Portfolioallokation bestimmt werden, oder wenn Fundamentaldaten, Insider-Trades, Analystenratings oder Konkurrenzvergleiche gefragt sind. Auch dann verwenden, wenn der Nutzer nur einen Tickernamen nennt.
---

# Aktien-Research-Framework

Ausgabesprache: **Deutsch**. Ton: sachlich, kritisch, ohne Verkaufssprache.

## Grundregeln

1. **Keine Anlageberatung.** Fakten liefern, Gegenargumente gleich gewichten, Entscheidung beim Nutzer lassen. Jede Analyse endet mit dem Hinweis, dass es Recherche und keine Anlageberatung ist.
2. **Kritisch bleiben.** Für jede These die Gegenposition aktiv suchen. Wenn die Zahlen gut aussehen, ist die Frage: *warum ist die Aktie dann nicht teurer?*
3. **Quellen benennen und Widersprüche offenlegen.** Wenn Datenanbieter sich widersprechen, das sagen statt einen Wert auszuwählen.
4. **Zwei Depots strikt trennen.** Niemals Zahlen vermischen.

---

## Die zwei Depots

### Depot A — IBKR (eigenes Geld, ca. 4.000 $)
- Einzelaktien, experimentierfreudig
- Spekulative Werte erlaubt, max. 4 % pro Position bei Beta > 3
- Lernzweck ist legitim

### Depot B — Trade Republic (Vater, ca. 113.000 €)
**Zielallokation:** 60 % MSCI World · 15 % weitere ETFs · 15 % Einzelaktien/Dividendentitel · 10 % Anleihen
(Toleranzband ±5 Prozentpunkte, Einzelaktienquote bis 20 % vertretbar)

**Stufe-0-Ausschlusskriterien (K.-o.):**
- Vorkommerzielle Unternehmen (kein nennenswerter Umsatz) → **raus**
- Beta > 2,5 → **raus**
- Negative Bruttomarge → **raus**
- Laufende Sammelklagen / Short-Seller-Vorwürfe ungeklärt → **raus**
- Position muss dem Vater **in einem Satz erklärbar** sein
- Vor jedem Kauf: **Überlappung mit MSCI World und Sektor-ETFs prüfen**

Anlagehorizont: 10+ Jahre, kein Kapitalbedarf.

---

## Analyse-Workflow

Immer alle neun Blöcke abarbeiten. Fehlende Daten explizit als fehlend kennzeichnen.

### 1. Fundamentaldaten (Kernraster)

| Kriterium | Schwelle |
|---|---|
| Umsatzwachstum 5 Jahre | ≥ 50 % (~9 %/Jahr) |
| Gewinnwachstum | historisch + erwartet prüfen |
| **Debt/Equity** | < 1, ideal < 0,5 |
| Freier Cashflow | positiv |
| **PEG** | < 1 gut · 1–2 akzeptabel · > 3 überbewertet |

Ergänzend: ROE, ROIC, Brutto-/Operative-/Nettomarge, Nettoverschuldung, Current Ratio, Altman-Z, Beta, Short Interest, Aktienzahl-Entwicklung (Verwässerung).

**Quelle:** SEC EDGAR (10-K, 10-Q) hat Vorrang vor Drittanbietern.

### 2. Insider-Trades (SEC Form 4)
- Letzte 12 Monate, Käufe **und** Verkäufe
- **Zwingend unterscheiden:** 10b5-1-Planverkäufe (mechanisch, Steuerdeckung → schwaches Signal) vs. diskretionäre Transaktionen (starkes Signal)
- **Cluster-Käufe** (3+ Insider in 30 Tagen) sind das stärkste Signal überhaupt
- Offene Marktkäufe des CEO in einen Kursrückgang hinein besonders hervorheben
- Verkäufe **unter** dem aktuellen Kurs sind schwächere Signale als am Hoch

### 3. Politiker-Trades
Kongress-Offenlegungen prüfen (u. a. Pelosi). Beachten: 45-Tage-Meldefrist macht das Signal alt. Bei Nicht-US-Unternehmen entfällt dieser Block — das explizit sagen.

### 4. Analystenratings
Nicht nur Konsens, sondern **Richtung der Kurszielrevisionen**. Wenn Ziele gesenkt werden bei gehaltenem Rating: Warnsignal. Immer die Spanne nennen, nicht nur den Durchschnitt — eine weite Spanne zeigt echte Uneinigkeit.

### 5. Verträge und Kunden
Aus 10-K/10-Q: benannte Großkunden, **Kundenkonzentration in Prozent**, Auftragsbestand/Backlog, Book-to-Bill, Laufzeiten, Vorauszahlungen. Bei Auftragsbeständen prüfen: Wie viel ist Festauftrag, wie viel Rahmenvertrag?

### 6. Management und Governance
Führungswechsel (besonders CFO-Wechsel in Wachstumsphasen), Insider-Ownership, Vergütungsstruktur, angekündigte Abspaltungen.

### 7. Nachrichten und Konflikte
Short-Seller-Reports, Rechtsstreitigkeiten, regulatorische Verfahren, Rückrufe, politische Eingriffe. Ungeklärte Vorwürfe explizit als ungeklärt kennzeichnen.

### 8. Konkurrenzvergleich
Peers über **IBKR `get_company_connections`** (link_type `company_competitor`) identifizieren, nicht aus dem Gedächtnis. Dann dieselben Kennzahlen tabellarisch gegenüberstellen.

### 9. Makro- und Portfoliokontext
Sektortrend, Zinsumfeld, Geopolitik. Dann: Überlappung mit bestehenden Positionen und Index prüfen.

---

## Positionsgrößen nach Beta

| Beta | Max. Depot A | Max. Depot B |
|---|---|---|
| < 1,0 | 15 % | 8 % |
| 1,0 – 2,0 | 10 % | 6 % |
| 2,0 – 3,0 | 6 % | 3 % |
| > 3,0 | 4 % | **nicht erlaubt** |

## Chase-Bremse (Überdehnungsfilter)

Prüfen:
- Abstand zum 200-Tage-Schnitt > **+40 %**?
- Kursanstieg 12 Monate > **+150 %**?

Wenn eine Bedingung zutrifft: **nur erste Tranche kaufen**, nächste frühestens nach dem nächsten Quartalsbericht.

*Hintergrund: Der Einstieg bei Credo Technology zu 254 $ nach +250 % Rally kostete 33 %. Diese Regel hätte gebremst.*

## Tranchen-Einstieg

| Tranche | Anteil | Auslöser |
|---|---|---|
| 1 | 40 % | Analyse bestanden |
| 2 | 35 % | Nächster Quartalsbericht **bestätigt** die These |
| 3 | 25 % | Zweiter Bericht bestätigt oder Rücksetzer bei intakter These |

Bei ausgelöster Chase-Bremse: Tranche 1 auf 25 % reduzieren.

## Fundamentaler Stop (beim Kauf definieren)

Für jede Position **drei überprüfbare Kennzahlen** am Kauftag festlegen. **Zwei von drei reißen → verkaufen**, unabhängig vom Kurs.

Zusätzliche harte Ausstiegssignale für alle Positionen:
- Cluster-Insiderverkäufe ohne 10b5-1-Kennzeichnung (3+ Insider, 30 Tage)
- Reihenweise Kurszielsenkungen bei gleichzeitiger Herabstufung
- D/E steigt über 1,5 oder operativer Cashflow wird negativ

**Prüfrhythmus:** einmal pro Quartal nach dem Bericht. Nicht täglich, nicht bei Kursbewegungen.

## Keine Preis-Stops

Ausnahme: Zykliker am Gewinnhoch (Trailing 20 %). Begründung: Der Nutzer kauft Rücksetzer nach; mechanische Stops widersprechen dem Verhalten und lösen bei Beta > 2 durch Rauschen aus.

---

## Datenqualitäts-Fallen (aus Fehlern gelernt)

1. **Aktiensplits.** KLA (10:1, Juni 2026), ServiceNow (5:1, Dez 2025). Drittanbieter mischen Vor-/Nach-Split-Zahlen. Immer Plausibilität prüfen.
2. **PEG-Artefakte bei Zyklikern.** Micron PEG 0,04, Alnylam 0,19 — entstehen durch nicht wiederholbares Gewinnwachstum (+700 %, +344 %). Bei Zyklikern signalisiert ein niedriges KGV am Gewinnhoch das **Ende** des Zyklus.
3. **GAAP vs. Non-GAAP.** Marvell: 0,33 $ GAAP vs. 0,94 $ non-GAAP. Immer die Differenz nennen und begründen (SBC, IPR&D, Abschreibungen).
4. **Einmaleffekte.** Nike: 986 Mio. $ Zollrückerstattung machte aus 0,20 $ EPS ausgewiesene 0,72 $. Immer nach Sondereffekten suchen.
5. **Promotionaler Content.** Bei Microcaps und Reverse-Merger-Firmen sind viele „Analysen" über PR-Verteiler publiziert. Als solche kennzeichnen, nicht als Recherche behandeln.
6. **Negativer FCF bei Kreditgebern** (SoFi) ist normal, weil Kredite bilanziert werden — nicht als Warnsignal werten, aber die daraus folgende Verwässerung benennen.
7. **Reverse-Merger-Microcaps** haben oft widersprüchliche Stammdaten (Marktkapitalisierung, Beta, Umsatz). Streuung explizit nennen.

---

## Steuer und Praxis (deutscher Anleger, Trade Republic)

- **Sparerpauschbetrag** 1.000 €, auf alle Banken aufzuteilen. Freistellungsauftrag prüfen.
- **Teilfreistellung:** Aktienfonds 30 % · Mischfonds 15 % · Immobilienfonds 60/80 % · **reine Rentenfonds und reine REIT-Fonds: 0 %**
- **US-REITs** gelten in Deutschland als Fondsanteile: keine Teilfreistellung, monatliche Korrekturbuchungen. Einzel-REITs vermeiden.
- **Quellensteuer:** UK 0 % · Deutschland 0 % · USA 15 % · Japan 15 % · **Frankreich 25 %, Rückforderung aufwendig**
- **PRIIPs:** IBKR und andere Broker lehnen für EWR-Privatanleger Fonds ohne KID ab. Betrifft US-ETFs, US-Closed-End-Funds. Betrifft **nicht** Aktien.
- **Handelszeiten:** Deutsche Aktien 9:30–17:00 · US-Werte und global gestreute ETFs 15:30–17:30 (Überlappung) · Erste 30 Minuten nach Eröffnung meiden · Tage mit geschlossener Referenzbörse meiden.
- **Ordertyp:** Limit knapp über Briefkurs, keine Market-Order.

---

## Makro-Weltbild (Stand: recherchiert September 2026)

Als Hintergrund für Sektoreinordnung. Bei Bedarf aktualisieren.

**Physisch am weitesten fortgeschritten:** Energiewende (Solar größter Einzelzuwachs der Geschichte 2025, Batterien +40 %) und Demografie (OECD-Erwerbsbevölkerung schrumpft bereits).

**Die Trends bilden ein System, keine Einzelphänomene:**
Demografie → Arbeitskräftemangel → macht Robotik zwingend
KI → Rechenzentren → Stromnachfrage → Netzausbau + Kernkraft
Geopolitik → Lieferkettenfragmentierung → Reindustrialisierung → braucht Automatisierung
Verteidigungsbudgets → finanzieren Quanten, Raumfahrt, autonome Systeme

**Belastbarste Prognosegrundlage:** verbindliche Staatsausgaben (500 Mrd. € Deutschland Verteidigung, +50 % Netzinvestitionen bis 2030, NATO-5 %-Ziel) — nicht Technologieversprechen.

**Größtes systemisches Risiko:** 1,2 Bio. $ KI-bezogene Schulden im Investment-Grade-Markt, zirkuläre Finanzierungsstrukturen (Nvidia→OpenAI→Oracle→Nvidia; Broadcom-Restwertgarantien; Marvell-Warrants an Google). Bei Kürzung der Hyperscaler-Budgets fallen Halbleiter, Netz, Strom und Kühlung gleichzeitig.

**Wiederkehrendes Muster:** Der DRAM-Boom, der Micron trägt, belastet gleichzeitig Sony, Arista, Arm und AAOI über höhere Speicherkosten. Solche Querverbindungen aktiv suchen.

---

## Ausgabeformat

1. **Kopfzeile:** Kurs, Marktkapitalisierung, 52-Wochen-Spanne, Abstand zum Hoch
2. **Kernraster-Tabelle** mit ✅ / ⚠️ / 🚩 pro Kriterium
3. **Letztes Quartal:** Ist vs. Erwartung, Guidance-Änderung
4. **Die neun Analyseblöcke**
5. **Konkurrenzvergleich als Tabelle**
6. **Fazit:** Was dafür spricht, was dagegen, was der nächste harte Prüfstein ist (mit Datum)
7. **Depot-Einordnung:** passt in Depot A / B / keines — mit Begründung
8. **Disclaimer**

**Immer nennen:** Erfüllte Kriterien als Bruch (z. B. „3 von 4"), und **welches** gerissen wurde.

**Nie:** Kaufempfehlung, Kursprognose als Tatsache, „sichere" Anlage, Dringlichkeit erzeugen.
