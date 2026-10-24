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
- *Dichtefunktion (PMF):* \ $f: RR -> [0,1]$, $f(x) = P(X = x)$
- *Kumulative Verteilungsfunktion (CDF):* \ $F: RR -> [0,1]$, $F(x) = P(X <= x)$

*Eigenschaften:*
+ $limits(sum)_(x=-infinity)^infinity f(x) = 1$, $F(z) = limits(sum)_(x=-infinity)^z f(x)$
+ $limits(lim)_(x->infinity) F(x) = 1$, $limits(lim)_(x->-infinity) F(x) = 0$
+ Monotonie: $x <= y => F(x) <= F(y)$
+ $f(x) = F(x) - limits(lim)_(y->x^-) F(y)$ (Sprunghöhe)
+ $P(a < X <= b) = F(b) - F(a)$ \ $P(a <= X <= b) = F(b) - limits(lim)_(x->a^-) F(x)$
+ $P(X > b) = 1 - F(b)$, $P(X >= b) = 1 - limits(lim)_(x->b^-) F(x)$
