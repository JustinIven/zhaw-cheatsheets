#import "../erDiagram.typ": *

= Normalisierung
Ziel: Redundanzen und Anomalien vermeiden, die bei "drauflos" definierten Tabellen entstehen.

== Probleme
Bsp. `Mitarbeiter(Name, `#underline[`M#`]`, GebDat, Abt#, AName, AMgr)`
#table(
  columns: (auto, 1fr),
  stroke: none,
  inset: 3pt,
  align: left,
  [*Redundanz*], [Gleiche Info mehrfach gespeichert (AName, AMgr pro MA) → Speicherverschwendung],
  [*Insert-Anomalie*],
  [Neue Werte müssen konsistent mit bestehenden sein; MA ohne bekannte Abteilung → NULLs; Abteilung ohne MA nicht erfassbar],

  [*Delete-Anomalie*], [Letzten MA einer Abteilung löschen → Abteilungsinfo verloren],
  [*Update-Anomalie*], [Änderung (z.~B. AMgr) muss in allen Kopien erfolgen, sonst inkonsistent],
  [*Join-Anomalie*],
  [Zerlegung über Nicht-Schlüssel (z.~B. `(Filiale, Kredit#, Betrag)` + `(Betrag, Kunde)`) → Join liefert zusätzliche, falsche Tupel: *lossy join*],
)

== Funktionale Abhängigkeit
Sein $U$ eine nicht-leere Menge von Attributen. Eine funktionale Abhängigkeit hat die Form $X -> Y$ mit $X, Y subset.eq U$
- Bsp. `Mitarbeiter(M#, Abt, Div)`: ${"Abt", "Div"} -> {"Abt"}$, ${"M#"} -> {"Abt", "Div"}$, ${"Div"} -> {"Div"}$
- Kurz: $A B -> C$ für ${A, B} -> {C}$

== Normalformen
#table(
  columns: (auto, 1fr),
  stroke: none,
  inset: 3pt,
  align: left,
  [*1NF*],
  [Nur *atomare* Wertebereiche; keine zusammengesetzten/mengenwertigen Attribute → pro Wert eine Zeile (z.~B. ein Hobby pro Zeile). Erleichtert Anfragen],

  [*2NF*],
  [1NF + jedes Nichtschlüsselattribut *voll* funktional abhängig von *jedem* Schlüsselkandidaten (vom ganzen, nicht nur von Teil)],

  [*3NF*], [2NF + keine *transitiven* Abhängigkeiten (Attribut hängt über anderes Nichtschlüsselattribut vom PK ab)],
  [*BCNF*],
  [Alle Attribute hängen von einem Schlüssel, dem ganzen Schlüssel und nichts als dem Schlüssel ab. Verletzt z.~B., wenn Teil eines Schlüssels von anderem Attribut abhängt],
)
- *2NF-Bsp.:* `(Verein, Spieler, Stadt, Salär)`, Schlüssel {Verein, Spieler}, aber Verein → Stadt \
  → `(Verein, Stadt)` + `(Verein, Spieler, Salär)`
- *3NF-Bsp.:* `(Spieler_ID, Spieler, Verein, Gründungsjahr)`, Spieler_ID → Verein → Gründungsjahr \
  → `(Spieler_ID, Spieler, Verein)` + `(Verein, Gründungsjahr)`
- *BCNF-Bsp.:* `(Student, Fach, Dozent)`, Schlüssel {Student, Fach}, Dozent → Fach (Dozent liest nur 1 Fach) → nicht BCNF. Zerlegung `(Student, Dozent)` + `(Dozent, Fach)` zerstört {Student, Fach} → Dozent. Korrekte ER-Lösung: Unabhängiges unabhängig modellieren, 2 Abhängigkeiten → 2 Beziehungen:
#er({
  let d = ent(-1.7, 0, "Dozent")
  let f = ent(1.7, 0, "Fach")
  let s = ent(0, -1.9, "Student")
  let l = rel(0, 0, "liest")
  let b = rel(0, -0.95, "besucht")
  node(d, f, s, l, b)
  arr(l, d, label: "m", side: -1)
  arr(l, f, label: "1")
  arr(b, d, label: "1")
  arr(b, f, label: "1", side: -1)
  arr(b, s, label: "m", side: -1)
})

== Normalisierungstheorie vs. Design
- Zwei Wege: 1. Vermeidung durch Designmethodik, 2. Normalisierungstheorie (Hinweise, wie Tabellen zu zerlegen sind)
- Wünschenswert: *BCNF*
- Korrekte ER-Diagramme vermeiden die Probleme von vornherein; mit den Regeln einfach BCNF erreichbar
