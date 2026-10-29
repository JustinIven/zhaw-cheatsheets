#import "../erDiagram.typ": *

= Entity-Relationship (ER)
- Chen 1976; Diagrammsprache für Design von Datenstrukturen
- Dialekt der Vorlesung: liefert Relationen in IDNF (Inclusion Dependency NF), vermeidet NULLs, nur Semantik, die das DBMS überwachen kann

== Notation
#table(
  columns: (2.6cm, 1fr),
  stroke: none,
  inset: 3pt,
  align: (center + horizon, left + horizon),
  er({ node(ent(0, 0, "E")) }),
  [*Entitätstyp:* Rechteck, eindeutiger Name. Steht für Menge von Entitäten (≈ Klasse/Objekte) → Relation, Entitäten = Zeilen],

  er({
    let e = ent(0, 0, "E", w: 0.7)
    node(e, attr(e, -1, 0, "K", key: true), attr(e, 1, 0, "A"))
  }),
  [*Attribut:* Oval, Linie zum Typ; nur einfache (atomare) Werte. Unterstrichen = Primärschlüssel],

  er({
    let e = ent(0, 0, "E", w: 0.5)
    let a = attr(e, 1, 0, "A", multi: true)
    node(e, a, attr(a, 0.8, 0.25, "X"), attr(a, 0.8, -0.25, "Y"))
  }),
  [*Mehrwertiges* (gestapelt) / *zusammengesetztes* Attribut (Unterattribute) → in ID-abh. Entitätstyp umwandeln],

  er({
    let e = ent(-1.05, 0, "E", w: 0.4)
    let f = ent(1.05, 0, "F", w: 0.4)
    let r = rel(0, 0, "R", w: 0.7)
    node(e, f, r)
    arr(r, e, label: "1")
    arr(r, f, label: "m")
  }),
  [*Beziehungstyp:* Rhombus, Pfeile zu Entitätstypen mit Kardinalität 1 / m],

  er({
    let f = ent(0, 0.5, "F", w: 0.6)
    let e = ent(0, -0.5, "E", w: 0.6)
    let g = ent(1.2, 0.5, "F", w: 0.6)
    let h = ent(1.2, -0.5, "E", w: 0.6)
    node(e, f, g, h)
    arr(e, f, label: "ISA", side: -1, at: 0.5)
    arr(h, g, label: "ID", side: -1, at: 0.5)
  }),
  [*ISA-/ID-abhängiger Entitätstyp:* Pfeil vom abhängigen zum übergeordneten Typ],

  er({ node(rel(0, 0, "D", composite: true, w: 1.2)) }),
  [*Zusammengesetzter Entitätstyp:* Rhombus mit Rechteck umschlossen (Beziehungstyp, an dem Entitätstypen hängen)],
)
- *Pfeil = existentielle Abhängigkeit*; existentiell *unabhängige* Entitätstypen: keine ausgehenden Pfeile, "leben" für sich
- Primärschlüssel erst wählen, wenn Typ referenziert wird (eingehende Pfeile), sonst nur Schlüssel

== Beziehungstyp
#er({
  let p = ent(-1.8, 0, "Person")
  let f = ent(1.8, 0, "Firma")
  let a = rel(0, -0.9, "Angestellt")
  node(
    p,
    f,
    a,
    attr(p, -0.7, 0.75, "Name", key: true),
    attr(p, 0.6, 0.75, "Vorname", key: true),
    attr(f, 0, 0.75, "Name", key: true),
    attr(a, -1.2, -0.65, "Pname"),
    attr(a, 0, -0.65, "Pvorname"),
    attr(a, 1.2, -0.65, "Fname"),
  )
  arr(a, p, label: "m", side: -1)
  arr(a, f, label: "1")
})
- Erbt PK-Attribute der referenzierten Entitätstypen als *Fremdschlüssel* (gleicher Name, ausser bei Namenskonflikt); eigene Attribute möglich (z.~B. `seit`)
- Existentiell abhängig von referenzierten Entitätstypen
- Hat *Schlüssel*, keinen PK (ausser er wird referenziert)
- Kardinalität am Pfeil zu $E$: *1* = höchstens eine Entität aus $E$ pro Kombination der übrigen; *m* = beliebig viele (auch 0)
- Bsp.: pro Person höchstens 1 Firma; Firma beliebig viele Angestellte → Schlüssel {Pname, Pvorname}
- Verwenden, wenn Beziehung *ohne* existentielle Abhängigkeit zw. den Entitätstypen

=== Schlüssel (binär, $E <-^(L_E) B ->^(L_F) F$)
#table(
  columns: 3,
  stroke: none,
  inset: 3pt,
  align: left,
  [*$L_E$*], [*$L_F$*], [*Schlüssel von $B$*],
  [1], [1], [Schlüssel von $E$ *und* Schlüssel von $F$ (2 Schlüssel)],
  [1], [m], [Schlüssel von $F$],
  [m], [1], [Schlüssel von $E$],
  [m], [m], [Schlüssel von $E$ kombiniert mit $F$],
)

=== Allgemein
Sei $R(E_1, L_1, ..., E_n, L_n)$ ein Beziehungstyp mit Entitätstypen $E_1, ..., E_n$, Kardinalitäten $L_1, ..., L_n$ und $R_K$ dessen Schlüsselmenge. $M_j$ sei die Menge der FK-Attribute in $R$ zum PK von $E_j$, wobei $M := M_1 union ... union M_n$.

$R_K = cases(
  delim: "{",
  {M backslash M_j divides L_j = 1} quad & exists j : L_j = 1,
  {M} & forall j : L_j = m
)$

=== Beziehungen mit > 2 Entitätstypen
#er({
  let e = rel(0, 0, "Empfehlung")
  let b = ent(-2.3, -0.7, "Buch")
  let k = ent(2.3, -0.7, "Klasse")
  let l = ent(-0.9, -1.3, "Lehrer")
  let f = ent(0.9, -1.3, "Fach")
  node(e, b, k, l, f)
  arr(e, b, label: "m", side: -1)
  arr(e, k, label: "m")
  arr(e, l, label: "1", side: -1)
  arr(e, f, label: "1")
})
- 1 bei Lehrer: Buch wird einer Klasse in einem Fach von höchstens einem Lehrer empfohlen
- Schlüssel: {B\#, F\#, K\#} und {B\#, L\#, K\#}. *Mehr nicht* herauslesen (z.~B. *nicht* "pro Buch höchstens 1 Fach")
- Semantik knifflig → mehrere binäre Beziehungen erwägen (Semantik dann *nicht* identisch)

=== Rekursiver Beziehungstyp
#er({
  let h = rel(-1.3, 0, "Hierarchie")
  let m = ent(1.4, 0, "Mitarbeitende")
  node(
    h,
    m,
    attr(h, 0, 0.6, "Vorgesetzt#"),
    attr(h, 0, -0.6, "Untergeb#"),
    attr(m, 0, 0.6, "P#", key: true),
  )
  arr(h, m, label: "1", shift: 0.1)
  arr(h, m, label: "m", shift: -0.1, side: -1)
})
- 1 Entitätstyp genügt; beide FK referenzieren denselben PK P\#. Namen so wählen, dass Semantik klar
- Pro Mitarbeitende höchstens 1 Vorgesetzte/r; Vorgesetzte beliebig viele Untergebene

== ISA-abhängiger Entitätstyp
#er({
  let g = ent(0, 0, "Geschäftspartner")
  let k = ent(-1.6, -1.3, "Kunde")
  let l = ent(1.6, -1.3, "Lieferant")
  node(
    g,
    k,
    l,
    attr(g, -1.7, 0, "G#", key: true),
    attr(g, 1.75, 0, "Adresse"),
    attr(k, -0.45, -0.65, "G#"),
    attr(k, 0.55, -0.65, "Bestellt"),
    attr(l, -0.5, -0.65, "G#"),
    attr(l, 0.55, -0.65, "Betrag"),
  )
  arr(k, g, label: "ISA")
  arr(l, g, label: "ISA", side: -1)
})
- "is a": Generalisierung/Spezialisierung; jeder Kunde *ist* Geschäftspartner
- PK von $E$ (Obertyp) ist *Schlüssel* in $F$ (Untertyp): {G\#} in Kunde und Lieferant
- Entität kann mehreren Untertypen angehören (Kunde *und* Lieferant)
- Gemeinsame Attribute nur im Obertyp, Schlüssel werden geerbt
- Sinnvoll, wenn Spezialisierungen sich deutlich unterscheiden (Attribute, Beziehungen) *und* Obertyp gemeinsame Struktur auffängt

== ID-abhängiger Entitätstyp
#er({
  let lb = ent(0, 0, "LogischesBuch")
  let pb = ent(0, -1.2, "PhysischesBuch")
  node(
    lb,
    pb,
    attr(lb, -1.5, 0, "ISBN", key: true),
    attr(lb, 1.5, 0, "Autor"),
    attr(pb, -1.6, 0, "ISBN"),
    attr(pb, -0.6, -0.6, "Ex#"),
    attr(pb, 1.9, 0, "Ausgeliehen"),
  )
  arr(pb, lb, label: "ID")
})
- Hierarchie: nur innerhalb des Obertyps identifizierbar (wie Kind per Vorname in Familie)
- Inerhalb eines ID-abhängigen Entitätstyps braucht es ein weiteres Attribut, das die Entität eindeutig identifiziert. (z.~B. Ex\# für PhysischesBuch)
- *Komplexe Attribute* (mehrwertig/zusammengesetzt) → ID-abh. Entitätstypen:
#er({
  let m = ent(0, 0, "Mitarbeitende")
  let t = ent(-1.4, -1.2, "TelNr")
  let s = ent(1.4, -1.2, "Salär")
  node(
    m,
    t,
    s,
    attr(m, 1.6, 0, "P#", key: true),
    attr(t, -0.85, -0.55, "P#"),
    attr(t, 0, -0.65, "Nr"),
    attr(t, 0.85, -0.55, "Typ"),
    attr(s, -0.9, -0.6, "P#"),
    attr(s, 0.2, -0.7, "GültigDatum"),
    attr(s, 0.9, 0.35, "Betrag"),
  )
  arr(t, m, label: "ID")
  arr(s, m, label: "ID", side: -1)
})
Schlüssel {P\#, Nr} bzw. {P\#, GültigDatum}; Mitarbeitende ohne Telefon möglich, TelNr nicht ohne Mitarbeitende

=== ISA vs. ID
#table(
  columns: (auto, 1fr),
  stroke: none,
  align: left,
  [*ISA*], [Spezialisierung; PK $M$ des Obertyps ist Schlüssel im Untertyp (1:1)],
  [*ID*], [Hierarchie (1:n); $M union N$ Schlüssel, $N$ = mind. 1 differenzierendes Attribut],
)

== Zusammengesetzter Entitätstyp
#er({
  let m = ent(-1.9, 0, "Mitarbeiter")
  let p = ent(1.9, 0, "Projekt")
  let v = rel(0, -0.8, "Vereinbarung", composite: true)
  let d = ent(0, -1.9, "Details")
  node(m, p, v, d, attr(m, 0, 0.6, "M#", key: true), attr(p, 0, 0.6, "P#", key: true))
  arr(v, m, label: "m", side: -1, at: 0.35)
  arr(v, p, label: "m", at: 0.35)
  arr(d, v, label: "ID", side: -1)
})
- Wenn an Beziehungstyp Entitätstyp(en) hängen sollen (z.~B. beliebig viele Details pro Vereinbarung)
- Beziehungstyp wird umgewandelt (Rechteck darum), erhält PK {M\#, P\#}
- Details ID-abhängig (mehrere pro Vereinbarung) → Schlüssel z.~B. {M\#, P\#, D\#}

== Design-Hinweise
- Gleiche Information an *einem* Ort (Beziehungstyp statt mehrwertigem Attribut auf beiden Seiten → sonst Konsistenz nicht gesichert)
- Keine veränderlichen/abgeleiteten Werte speichern: GebDatum statt Alter
- Systemgrenzen ziehen: nur benötigte Daten modellieren
- Produkt ≠ Exemplar unterscheiden
- Versch. Aussagen → versch. Beziehungstypen (z.~B. "hat im Sortiment" vs. "hat geliefert"), Attribute wie Preis ggf. in beiden (Lieferpreis ≠ Katalogpreis)
- Teilmengen (z.~B. Teillieferungen): Kardinalität auf m ändern + Attribut (Menge) in Beziehungstyp

== Korrektes ER-Diagramm
Aus leerem Diagramm durch Folge folgender Regeln erzeugbar.
#table(
  columns: (auto, 1fr),
  stroke: none,
  inset: 3pt,
  align: left,
  [*Regel*], [*Voraussetzung* ⇒ *Ergebnis*],
  [1 Unabh. ET], [keine ⇒ neues Rechteck (eindeutiger Name)],
  [2 Beziehungstyp],
  [$E_1, ..., E_n$ ($n >= 1$) Rechtecke oder umschl. Rhomben ⇒ neuer Rhombus mit 1/m-Pfeilen zu den $E_j$],

  [3 Attribut], [$F$ Rechteck, Rhombus oder umschl. Rhombus ⇒ Oval mit Strich zu $F$, Name eindeutig in $F$],
  [4 Zusammenges. ET], [$D$ Rhombus ⇒ Rechteck um $D$],
  [5/6 ID-/ISA-abh. ET], [$F$ Rechteck oder umschl. Rhombus ⇒ neues Rechteck mit ID/ISA-Pfeil zu $F$],
)

=== Schlüssel
- Unabhängiger ET: $>= 1$ Schlüssel; hat er eingehende Pfeile → PK wählen
- Beziehungstyp: FK und Schlüssel gemäss Kardinalitäten
- Zusammengesetzter ET: PK wählen
- $E$ ID-/ISA-abhängig von $F$: PK in $F$, FK und Schlüssel in $E$

=== Umwandlung in Relationen (kanonische Abbildung)
- Rekursiv dem Aufbau des Diagramms entlang
- Jedes Kästchen (Rechteck, Rhombus) → Relation mit seinen Attributen (Domänen wählen)
- Schlüssel, FK, PK werden übernommen
