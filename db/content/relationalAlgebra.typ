= Relationale Algebra

== Relationales Modell
#table(
  columns: 2,
  stroke: none,
  align: left,
  [Domäne], [Endliche Menge von Werten desselben Typs (≈ Datentyp)],
  [Attribut], [Eigenschaft mit eindeutigem Namen, genau eine Domäne $"dom"(A)$],
  [n-Tupel], [Menge von $n$ zusammengehörigen Attributwerten],
  [Relationsschema], [(Format, Heading, Relationsvariable) Menge von Attributen],
  [Relation], [Schema + Menge von Tupeln dazu (Ausprägung $"ext"(R)$)],
)
- Relation = endliche *Menge*: keine Duplikate, keine Tupel-Reihenfolge; Attributreihenfolge egal
- *Notation:* Schema $R(A_1, A_2, ..., A_n)$; Tupelmenge ${chevron.l a, b, c chevron.r, ...}$ (Format immer angeben)
- *Äquivalenz* $R_1 tilde R_2$: durch Umordnen der Attribute ineinander überführbar (gleiche Domänen/Bedeutung)

=== Schlüssel
- *Schlüssel:* nicht-leere Attributmenge, identifiziert Tupel eindeutig
- *Schlüsselkandidat:* minimale Schlüsselmenge; jede Relation hat mind. einen (Format selbst)
- *Surrogatschlüssel:* künstlicher Schlüssel, wenn nichts passt
- *Primärschlüssel (PK):* gewählter Kandidat, auf den ein Fremdschlüssel zeigt
- *Fremdschlüssel (FK):* Attributkombination, die auf PK einer anderen Relation zeigt; PK-FK explizit definieren (gleicher Name genügt nicht)

== Grundbegriffe
- *RA:* Operatoren + Regeln zum Rechnen mit Relationen; Relationen = Operanden; Ausdrücke = Anfragen (queries)
- *Prädikat:* berechenbarer Ausdruck → wahr/falsch
- *Kriterien Abfragesprache:* Ad-hoc-Formulierung, deklarativ ("was", nicht "wo"), optimierbar (wenige Operatoren, Optimierungsregeln), *abgeschlossen* (Ergebnis wieder Relation → schachtelbar), mengenorientiert (nicht tuple-at-a-time), sicher (keine Endlosschleife/unendliches Ergebnis)

== Selektion $sigma$ (entfernt Tupel)
$R' = sigma_P (R)$, unär
- Prädikat $P$: logischer Ausdruck aus Attributen/Konstanten ($and, or, not, =, <, >=, ...$), für jedes Tupel geprüft
- Ergebnis: *gleiches Schema*, Tupel mit $P$ wahr; kann leer sein (z.~B. $sigma_(1=0)(r)$ → nur Schema, keine Tupel)
- Z.~B. $sigma_("City" = "'Zürich'" and "Discount" >= 0.15)("Customers")$
- Kommutativ: $sigma_(Phi_1)(sigma_(Phi_2)(r)) = sigma_(Phi_2)(sigma_(Phi_1)(r)) = sigma_(Phi_1 and Phi_2)(r)$

== Projektion $pi$ (entfernt Attribute)
$R' = pi_(A_1, ..., A_k)(R)$, unär
- Schema = Attributliste; Projektion auf nicht vorhandene Attribute → *Fehler*
- *Erweitert:* $pi_(E -> x, ...)(R)$, Ausdruck $E$ aus Attributen, Konstanten, arithm./String-Operatoren, Funktionen; Ergebnis heisst $x$. Z.~B. $pi_(3 dot A -> X, B + C -> D, C)(R)$, $pi_("SQR"(A) -> X)(R)$
- Duplikate werden entfernt \
  RDBMS/SQL entfernen Duplikate nicht automatisch
- *Nicht* vertauschbar: $pi_A (pi_B (r)) != pi_B (pi_A (r))$ i.\u{00A0}A.

== Umbenennung $rho$
- Gleiche Attributnamen in versch. Relationen qualifizieren: $R.A$, $S.A$
- $rho_"neu" (R)$ (auch `R AS neu`): Relation umbenennen, z.~B. für Auto-Join
- $rho_(S(D, E))(R(A, B))$: $R.A -> S.D$, $R.B -> S.E$

== Kartesisches Produkt $times$
$R' = R times S$, binär
- Jedes Tupel aus $R$ mit jedem aus $S$ kombiniert → $|R times S| = |R| dot |S|$
- Schema: $R$ konkateniert mit $S$; gleichnamige Attribute bleiben beide → qualifizieren ($R.B$, $S.B$) oder umbenennen
- In SQL nicht kommutativ: $R times S != S times R$ (Schema-Reihenfolge; per $pi$ überführbar)

== Theta-Join $bowtie.big_P$ (allg. Verbund)
$R bowtie.big_P S = sigma_P (R times S)$
- Join-Prädikat $P$ frei: beliebiger log. Ausdruck mit $theta$-Vergleichen, $theta in {=, <, >, <=, >=, !=}$
- Schema wie Kreuzprodukt (alle Attribute, ggf. qualifizieren $R.B$, $S.B$)
- Verallgemeinerung des Natural Join, in Praxis Normalfall

=== Verbundvarianten (-Joins)
#table(
  columns: 2,
  stroke: none,
  align: left,
  [Natural],
  [$R bowtie S$: Gleichheit in allen gemeinsamen Attributen (Name, Domäne, Bedeutung), gemeinsame nur einmal im Schema. Keine gemeinsamen Attribute → Kreuzprodukt.],

  [Equi],
  [$P$ nur Gleichheiten, mit $and$ verknüpft. Natural Join ⊂ Equi-Join (Equi-Join: Attribute dürfen versch. heissen, beide bleiben im Schema)],

  [Auto], [$R_1 bowtie R_1$, braucht Umbenennung $rho$],
  [Cross], [$R_1 times R_2$ (kartesisches Produkt)],
  [Semi], [$pi_(r_1..r_n)(R_1 bowtie R_2)$: Join, projiziert auf Attribute von $R_1$ (oder $R_2$)],
)

== Mengenoperatoren $union$, $inter$, $without$
Binär; $R$, $S$ müssen *gleiches Schema* haben. Ergebnis: gleiches Schema, ohne Duplikate.
#table(
  columns: 3,
  align: left,
  table.header([*Op.*], [*Tupel in*], [*kommutativ*]),
  [$R union S$], [$R$ ODER $S$], [ja],
  [$R inter S$], [$R$ UND $S$], [ja],
  [$R without S$ ($R - S$)], [$R$ ABER NICHT $S$], [nein],
)

== Bag-Algebra (Multimengen)
SQL arbeitet mit *Bags*: identische Tupel nicht unterscheidbar, aber Anzahl Vorkommen = *Multiplizität* $m$.
#table(
  columns: 2,
  align: left,
  [$sigma$, $times$, $bowtie$], [Wie RA, Duplikate wie normale Tupel],
  [$pi$], [Wie RA, Duplikate *nicht* entfernen],
  [$union$ bag union], [$max(m_R, m_S)$],
  [$union.sq$ bag concatenation], [$m_R + m_S$],
  [$inter$], [$min(m_R, m_S)$],
  [$without$], [$max(m_R - m_S, 0)$],
  [$delta$ Duplikatelimination], [Entfernt Duplikate: Bag → Relation],
)

== Outer Joins $bowtie.big.l$, $bowtie.big.r$, $bowtie.big.l.r$
Alle Tupel des linken ($bowtie.big.l$ left), rechten ($bowtie.big.r$ right) bzw. beider ($bowtie.big.l.r$ full) Operanden ins Resultat; ohne Join-Partner → fehlende Werte mit *NULL* auffüllen.
- NULL ist *kein Wert*, sondern Indikator für fehlenden Wert; verursacht Probleme → möglichst vermeiden
#table(
  columns: 3,
  align: center,
  table.header([$L(A, B, C)$], [$R(C, D, E)$], [$L$ ⟗ $R$]),
  [$a_1, b_1, c_1$ \ $a_2, b_2, c_2$],
  [$c_1, d_1, e_1$ \ $c_3, d_2, e_2$],
  [$a_1, b_1, c_1, d_1, e_1$ \ $a_2, b_2, c_2$, NULL, NULL \ NULL, NULL, $c_3, d_2, e_2$],
)
$bowtie.big.l$: nur Zeilen 1–2; $bowtie.big.r$: Zeilen 1 und 3; $bowtie$: nur Zeile 1.

== Aggregation & Gruppierung
- *Aggregatfunktion:* fasst Attributwerte mehrerer Tupel zusammen: Summe, Durchschnitt, Min, Max, Anzahl
- Über alle Tupel oder pro *Gruppe*: Multimenge von Tupeln mit gleichen Werten im Gruppierungskriterium (Attributkombination), `GROUP BY a` → ein Tupel pro Wert von $a$ mit $f(a)$
- Aggregation, Gruppierung, Sortierung: nicht algebraisch

== Äquivalenzen
#table(
  columns: 2,
  align: left,
  [*Kommutativität*],
  [$sigma_Phi (sigma_psi (r)) = sigma_psi (sigma_Phi (r))$ \
    $pi_A (sigma_Phi (r)) = sigma_Phi (pi_A (r))$, falls $Phi$ nur Attr. aus $A$ \
    $r bowtie s = s bowtie r$ (Format verschieden)],

  [*Assoziativität*], [$r bowtie (s bowtie t) = (r bowtie s) bowtie t$],
  [*Idempotenz*],
  [$pi_A (pi_C (r)) = pi_A (r)$, falls $A subset.eq C$ \
    $sigma_Phi (sigma_psi (r)) = sigma_(Phi and psi)(r)$],

  [*Distributivität*],
  [$pi_A (r union s) = pi_A (r) union pi_A (s)$ \
    $sigma_Phi (r union s) = sigma_Phi (r) union sigma_Phi (s)$ \
    $sigma_Phi (r bowtie s) = sigma_Phi (r) bowtie s$, falls $Phi$ nur Attr. von $r$ \
    $pi_(A, B)(r bowtie s) = pi_A (r) bowtie pi_B (s)$, falls Joinattr. $J subset.eq A inter B$ \
    $r bowtie (s union t) = (r bowtie s) union (r bowtie t)$],
)
