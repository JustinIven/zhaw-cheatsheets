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
