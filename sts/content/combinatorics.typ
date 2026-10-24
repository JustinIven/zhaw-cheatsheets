= Kombinatorik
- *Fakultät:* $0! = 1$, $n! = n dot (n-1)!$
- *Binomialkoeffizient* ($k$ aus $n$, $n$ tief $k$), $0 <= k <= n$:
  $ binom(n, k) = n! / ((n-k)! dot k!) $
  Anzahl Auswahlen von $k$ aus $n$ unterscheidbaren Objekten (ohne Reihenfolge, ohne Wiederholung)

== Vier Grundtypen (Auswahl $k$ aus $n$)
- *Variation:* Reihenfolge spielt eine Rolle
- *Kombination:* Reihenfolge spielt keine Rolle
#table(
  columns: 3,
  align: center,
  [], [*Mit Wiederholung*], [*Ohne Wiederholung*],
  [*Variation*], [$n^k$], [$n! / (n-k)!$],
  [*Kombination*], [$binom(n+k-1, k)$], [$binom(n, k)$],
)

== Typische Techniken
- *Produktregel:* unabhängige Teilauswahlen multiplizieren, z.~B. 6 aus 8 Frauen und 5 aus 12 Männern: $binom(8, 6) binom(12, 5)$
- *Ersatzproblem:* äquivalentes, einfacher abzählbares Problem (Bijektion)
- *Kombination mit Wdh.* (Kreuze/Striche): $k$ Kreuze X + $(n-1)$ Trennstriche I auf $n+k-1$ Stellen verteilen → $binom(n+k-1, k) = binom(n+k-1, n-1)$
- *Mind. 1 pro Empfänger:* $k$ gleiche Objekte auf $n$ Personen, jeder $>= 1$: zuerst je 1 verteilen, Rest $k-n$ mit Wdh. → $binom(k-1, k-n)$
- *Runder Tisch:* Drehung egal → eine Person fixieren, Rest $(n-1)!$ anordnen; zwei Personen nebeneinander: $2 dot (n-2)!$
- *Teilmengen/Gruppen:* Bitmuster (1 = gewählt) → $2^n$ Teilmengen ($|cal(P)(M)| = 2^n$), nicht-leer: $2^n - 1$

== Eigenschaften Binomialkoeffizient
+ *Leere Menge:* $binom(n, 0) = 1$
+ *Symmetrie:* $binom(n, k) = binom(n, n-k)$
+ *Pascal'sches Dreieck:* $binom(n+1, k+1) = binom(n, k) + binom(n, k+1)$
+ *Summe:* $sum_(k=0)^n binom(n, k) = 2^n$
+ *Binomischer Lehrsatz* ($a, b in CC$):
  $ (a+b)^n = sum_(k=0)^n binom(n, k) a^k b^(n-k) $
