#import "@preview/cetz:0.4.2"

= Elementare Wahrscheinlichkeitsrechnung

== Diskrete Wahrscheinlichkeitsräume
*Zufallsexperiment:* beliebig oft unter gleichen Bedingungen wiederholbar; mehrere sich gegenseitig ausschliessende, vorab bekannte Ergebnisse; Ergebnis zufallsbedingt.
#table(
  columns: 2,
  stroke: none,
  align: left,
  [Ergebnisraum $Omega$],
  [Menge aller möglichen, sich gegenseitig ausschliessenden Ergebnisse; *diskret*: endlich oder abzählbar unendlich],

  [Zähldichte $rho$], [$rho: Omega -> [0,1]$ mit $limits(sum)_(omega in Omega) rho(omega) = 1$],
  [Ereignis $A$],
  [Teilmenge $A subset.eq Omega$; tritt ein, wenn Ergebnis $in A$. ${}$ = unmögliches, $Omega$ = sicheres Ereignis],

  [Ereignisraum $2^Omega$], [Potenzmenge von $Omega$ (alle Ereignisse), $|2^Omega| = 2^(|Omega|)$],
  [W'keitsmass $P$], [$P: 2^Omega -> [0,1]$,\ $P(M) = limits(sum)_(omega in M) rho(omega)$],
  [Diskreter W'raum], [$(Omega, P)$ mit diskretem $Omega$],
  [Laplace-Raum], [$rho$ konstant (Gleichverteilung): $P(M) = (|M|)/(|Omega|)$],
)

*Eigenschaften:*
+ $P({}) = 0$
+ $P(Omega) = 1$
+ $P(Omega without A) = 1 - P(A)$
+ $P(A union B) = P(A) + P(B) - P(A inter B)$
+ $sigma$-Additivität: $P(A_1 union A_2 union ...) = P(A_1) + P(A_2) + ...$ für paarweise disjunkte $A_i$

== Zufallsvariablen
- *Zufallsvariable:* Funktion $X: Omega -> RR$; $X = x$ steht für Ereignis ${omega in Omega | X(omega) = x}$
- *Dichtefunktion (PMF):*  $ f: RR -> [0,1], quad f(x) = P(X = x) $
- *Kumulative Verteilungsfunktion (CDF):* $ F: RR -> [0,1], quad F(x) = P(X <= x) $

*Eigenschaften:*
+ $ sum_(x=-infinity)^infinity f(x) = 1, quad F(z) = sum_(x=-infinity)^z f(x) $
+ $ lim_(x->infinity) F(x) = 1, quad lim_(x->-infinity) F(x) = 0 $
+ Monotonie: $ x <= y => F(x) <= F(y) $
+ Sprunghöhe: $ f(x) = F(x) - lim_(y->x^-) F(y) $
+ $
    & P(a < X <= b) = F(b) - F(a) \
    & P(a <= X <= b) = F(b) - lim_(x->a^-) F(x)
  $
+ $ P(X > b) = 1 - F(b), quad P(X >= b) = 1 - lim_(x->b^-) F(x) $

== Kenngrössen
*Lagemass:* Zentrum; *Streumass:* Abweichung vom Zentrum. Existieren nicht für jede Verteilung.
- *Erwartungswert:* $mu = E(X) = limits(sum)_(x in RR) P(X = x) dot x$
- *Varianz:* $sigma^2 = V(X) = limits(sum)_(x in RR) P(X = x) dot (x - E(X))^2$ (Einheit²)
- *Standardabweichung:* $sigma = S(X) = sqrt(V(X))$ (Einheit wie $X$)

*Rechenregeln* ($alpha, beta in RR$):
+ Linearität: $ E(X + Y) = E(X) + E(Y), quad E(alpha X) = alpha E(X) $
+ Verschiebungssatz: $ V(X) = E(X^2) - E(X)^2 = (limits(sum)_(x in RR) P(X = x) dot x^2) - E(X)^2 $
+ $ V(alpha X + beta) = alpha^2 dot V(X) $

*Tschebyscheff* (gilt für *jede* Verteilung): W'keit, um mind. $k > 0$ von $E(X)$ abzuweichen, ist höchstens $S(X)^2 / k^2$.
$
  P(|X - E(X)| >= k) & <= S(X)^2 / k^2 \
   P(|X - E(X)| < k) & >= 1 - S(X)^2 / k^2
$
Mit $k = c dot S(X)$: mind. $1 - 1/c^2$ der Werte liegen in $E(X) plus.minus c dot S(X)$.
#block(breakable: false, table(
  columns: 4,
  align: center,
  [Anteil in $E(X) plus.minus c S(X)$], [$c = 1$], [$c = sqrt(2)$], [$c = 2$],
  [Tschebyscheff], [–], [$>= 50%$], [$>= 75%$],
  [Normalverteilt], [$approx 68%$], [], [$approx 95%$],
))

== Bedingte Wahrscheinlichkeiten
*Bedingte W'keit* von $B$ unter Bedingung $A$ ($P(A) != 0$):
$ P(B|A) = P(A inter B) / P(A) $

=== Vierfeldertafel
Innenfelder = Schnitte, Ränder = Summen (Randw'keiten), Total $1$. Bedingt: Nenner = Rand der Bedingung, nicht Total.
#align(center, table(
  columns: 4,
  align: center + horizon,
  stroke: 0.4pt,
  inset: 3pt,
  table.header([], [$B$], [$overline(B)$], [$Sigma$]),
  [$A$], [$P(A inter B)$], [$P(A inter overline(B))$], [$P(A)$],
  [$overline(A)$], [$P(overline(A) inter B)$], [$P(overline(A) inter overline(B))$], [$P(overline(A))$],
  [$Sigma$], [$P(B)$], [$P(overline(B))$], [$1$],
))

#block(breakable: false)[
  === Ereignisbaum
  #align(center, cetz.canvas({
    import cetz.draw: *
    set-style(stroke: 0.4pt)
    let root = (0, 0)
    let l1 = ((1.5, 0.9), (1.5, -0.9))
    let l2 = ((3.2, 1.35), (3.2, 0.45), (3.2, -0.45), (3.2, -1.35))
    let n1 = ($A$, $overline(A)$)
    let n2 = ($B$, $overline(B)$, $B$, $overline(B)$)
    let e1 = ($P(A)$, $P(overline(A))$)
    let e2 = ($P(B|A)$, $P(overline(B)|A)$, $P(B|overline(A))$, $P(overline(B)|overline(A))$)
    let res = (
      $P(A inter B)$,
      $P(A inter overline(B))$,
      $P(overline(A) inter B)$,
      $P(overline(A) inter overline(B))$,
    )
    let lbl(a, b, body) = content(
      (a, 50%, b),
      text(6pt, body),
      frame: "rect",
      fill: white,
      stroke: none,
      padding: 0.03,
    )
    let node(p, body) = content(p, text(6pt, body), frame: "circle", fill: white, padding: 0.04)
    for i in range(2) {
      line(root, l1.at(i))
      for j in range(2) { line(l1.at(i), l2.at(2 * i + j)) }
    }
    for i in range(2) {
      lbl(root, l1.at(i), e1.at(i))
      for j in range(2) { lbl(l1.at(i), l2.at(2 * i + j), e2.at(2 * i + j)) }
    }
    circle(root, radius: 0.06, fill: black)
    for i in range(2) { node(l1.at(i), n1.at(i)) }
    for k in range(4) {
      node(l2.at(k), n2.at(k))
      content((l2.at(k).at(0) + 0.2, l2.at(k).at(1)), text(6pt, $= #res.at(k)$), anchor: "west")
    }
  }))
]
- Von einem Verzweigungspunkt ausgehende Ereignisse paarweise disjunkt
- Summe der Übergangsw'keiten pro Verzweigung $= 1$

*Sätze:*
+ *Multiplikationssatz (Pfadw'keit):* W'keiten entlang eines Pfades multiplizieren
  $ P(A inter B) = P(A) dot P(B|A) = P(B) dot P(A|B) $
+ *Totale W'keit:* Pfadw'keiten aller Pfade zum selben Endergebnis addieren
  $ P(B) = P(A) dot P(B|A) + P(overline(A)) dot P(B|overline(A)) $
+ *Bayes:*
  $ P(A|B) = (P(A) dot P(B|A)) / P(B) $

== Stochastische Unabhängigkeit
Zwei Ereignisse heissen _stochastisch unabhängig_, falls gilt:
$ P(A inter B) = P(A) dot P(B) $
Dann folgt:
$ P(B) != 0 arrow.double.long P(A|B) = P(A) $
$ P(A) != 0 arrow.double.long P(B|A) = P(B) $

=== Sätze
Für einen diskreten Wahrscheinlichkeitsraum $(Omega, P)$ und zwei Ereignisse $A, B in Omega$ sind folgende Aussagen äquivalent:
- $A$ und $B$ stochastisch unabhängig sind.
- $A$ und $B\\ Omega$ stochastisch unabhängig sind.
- $A\\Omega$ und $B\\Omega$ stochastisch unabhängig sind.

=== Vollständige Unabhängigkeit von $n$ Ereignissen
Die Ereignisse $A_1, ..., A_n$ heissen _vollständig unabhängig_, wenn für jede Teilmenge $I subset.eq {1, ..., n}$ mit $|I| >= 2$ gilt:
$ P(inter.big_(i in I) A_i) = product_(i in I) P(A_i) $
Dies entspricht $2^n - n - 1$ Gleichungen.

=== Zufallsvariablen
Für einen diskreten Wahrscheinlichkeitsraum $(Omega, P)$ und zwei stochastisch unabhängige Zufallsvariablen $X,Y : Omega arrow R$ gelten folgende Eigenschaften:

+ *Multiplikativität des Erwartungswertes:* Sofern $E(X)$ und $E(Y)$ existieren, gilt:
$ E(X dot Y) = E(X) dot E(Y) $

+ *Additivität der Varianz:* Sofern die Varianzen $V(X)$ und $V(Y)$ existieren, gilt:
$ V(X + Y) = V(X) + V(Y) $
