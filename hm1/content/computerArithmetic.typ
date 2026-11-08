= Rechnerarithmetik

== Maschinenzahlen
Jede $x in RR$ darstellbar als $x = m dot B^e$ mit Basis $B in NN_(>=2)$, Mantisse $m in RR$, Exponent $e in ZZ$.

*Maschinenzahlen / Gleitpunktzahlen:* $n$ Stellen für $m$, $l$ Stellen für $e$, Normalisierung $m_1 != 0$ (falls $x != 0$) $=>$ eindeutige Darstellung:
$ M = {x in RR | x = plus.minus 0.m_1 ... m_n dot B^(e_(l-1) ... e_0 - "bias")} union {0} $
mit $m_i, e_j in {0, ..., B-1}$, $m_1 != 0$. Wert:
$ x = sum_(i=1)^n m_i B^(e-i), quad e = sum_(i=0)^(l-1) e_i B^i - "bias" $

- *bias* $in NN$ fix, so dass Wertebereich von $e$ je zur Hälfte negativ/positiv; $e_min <= e <= e_max$
- *$n$-stellige Gleitpunktzahl zur Basis $B$*; $x in.not M$ wird gerundet
- Punkt um $k$ Stellen nach links $=>$ $e + k$; nach rechts $=>$ $e - k$. Z.~B. $(1011100.111)_2 = (0.1011100111)_2 dot 2^7$
- Ohne Normalisierung: Mantisse/Exponent nicht eindeutig ($0.0111 dot 2^4 = 1.11 dot 2^2 = ...$)
- Bsp.: $0.71537 dot 8^2 = 7 dot 8^1 + 1 dot 8^0 + 5 dot 8^(-1) + 3 dot 8^(-2) + 7 dot 8^(-3)$

=== IEEE-754 ($B = 2$)
#table(
  columns: 6,
  align: center,
  [], [Bits], [$V$], [$E$], [bias], [$M$],
  [single], [32], [1], [8], [127], [23],
  [double], [64], [1], [11], [1023], [52],
)
$ x = (-1)^V dot (underbrace(1, "hidden bit") . underbrace(M M M ... M, "fraction")) dot 2^((E...E) - "bias") $
- Normalisiert: führende Ziffer vor dem Punkt, immer $1$ $=>$ nicht gespeichert (*hidden bit*)
- `0 10000001 101000...` $= +1.101 dot 2^(129-127) = 6.5$
- `0 00000001 000...` $= 2^(-126) = x_min$; subnormal `0 00000000 0...01` $= 2^(-149)$

=== Bereich
Maschinenzahlen *nicht gleichmässig verteilt* (dichter bei $0$).
$
  x_max & = B^(e_max) - B^(e_max - n) = (1 - B^(-n)) B^(e_max) \
  x_min & = B^(e_min - 1) quad "(kleinste pos. normalisierte)"
$
- *Overflow:* $|x| > x_max$ $->$ Abbruch (IEEE: `inf`)
- *Underflow:* $0 < |x| < x_min$ $->$ mit $0$ weiterrechnen
- *Subnormale Zahlen* ($m_1 = 0$ erlaubt): füllen $(0, x_min)$ bis $B^(e_min - n)$
- Vorteil ggü. Ganz-/Festpunktsystem: bei gleichem Speicher viel grösserer Bereich, aber variabler Abstand

== Rundungsfehler und Maschinengenauigkeit
Näherung $tilde(x)$ zu exaktem $x$:
- *Absoluter Fehler:* $|tilde(x) - x|$
- *Relativer Fehler* ($x != 0$): $(|tilde(x) - x|) / (|x|)$

*Runden:* $tilde(x) = "rd"(x)$ = Maschinenzahl mit minimalem $|"rd"(x) - x|$ (besser als Abschneiden). Für $n$-stellige Mantisse, $B$ gerade:
$ |"rd"(x) - x| <= 0.underbrace(0...0, n) B/2 dot B^e = B/2 dot B^(e-n-1) $


*$n$-stellige Gleitpunktarithmetik:* jede Operation ($+, -, dot, \/$) auf $n+1$ Stellen genau, Ergebnis auf $n$ Stellen gerundet. *Jedes Zwischenergebnis* wird gerundet $->$ Fehler pflanzen sich fort, Reihenfolge relevant.\
*Faustregel:* Summanden nach aufsteigenden Beträgen sortiert addieren.

=== Maschinengenauigkeit
$"eps" := B/2 dot B^(-n) = 1/2 dot B^(1-n)$
Entspricht maximalem relativer Rundungsfehler: $(|"rd"(x) - x|) / (|x|) <= "eps"$
- Grösste pos. Maschinenzahl mit $1 + "eps" = 1$ (gerundet)
- *Achtung:* IEEE/Python/Matlab: `eps` = Abstand von $1$ zur nächstgrösseren Maschinenzahl $= 2 dot "eps"_"Def"$
- $"eps" != x_min$ ($x_min$ viel kleiner)
- IEEE double: $n = 53$ (hidden bit) $=> "eps" = 2^(-53)$

== Fehlerfortpflanzung / Kondition
$tilde(x) = x + Delta x$; Taylor um $x$, Terme $(Delta x)^k, k >= 2$ vernachlässigt ($Delta x << 1$):
$ f(tilde(x)) - f(x) approx f'(x) (tilde(x) - x) $
- *Absoluter Fehler:* $ underbrace(|f(tilde(x)) - f(x)|, "abs. Fehler" f(x)) approx |f'(x)| dot underbrace(|tilde(x) - x|, "abs. Fehler" x) $
- *Relativer Fehler:* $ underbrace((|f(tilde(x)) - f(x)|) / (|f(x)|), "rel. Fehler" f(x)) approx underbrace((|f'(x)| dot |x|) / (|f(x)|), K(x)) dot underbrace((|tilde(x) - x|) / (|x|), "rel. Fehler" x) $

*Konditionszahl* von $y = f(x)$ an der Stelle $x$:
$ K(x) := (|f'(x)| dot |x|) / (|f(x)|) $
Faktor, um den sich der rel. Fehler ungefähr vergrössert. Klein $=>$ *gut konditioniert*; gross $=>$ *schlecht konditioniert* (ill posed).
- Abs. Fehler wächst falls $|f'(x)| > 1$, sonst nicht (z.~B. $sin$: $|cos x| <= 1$)
- Fehlerquelle egal (Rundung, Messung, ...)
- $f(x) = x^2$: $K = 2$ (noch gut)
- Bsp. schlecht: Nullstellen des Wilson-Polynoms $product_(k=1)^20 (x-k)$ aus Koeffizienten; Störung $~10^(-7)$ $->$ Nullstellen ändern sich um $~1$ (teils komplex)

=== Auslöschung
Summation $f(x) = x + c$: $f'(x) = 1$,
$ K(x) = (|x|) / (|x + c|) $
- $x, c$ gleiches Vorzeichen: $K <= 1$ (gut)
- Entgegengesetztes Vorzeichen, $|x| approx |c|$: $|x + c|$ klein $=> K$ gross
- *Auslöschung:* Subtraktion ungefähr gleich grosser, fehlerbehafteter Zahlen + anschliessende Normalisierung $->$ grosser rel. Fehler
- Bsp. 5-stellig: $x_1 = 123.454 dot 10^9$, $x_2 = 123.446 dot 10^9$ $->$ $tilde(x)_1 = tilde(x)_2 = 0.12345 dot 10^12$, $tilde(x)_1 - tilde(x)_2 = 0$ statt $8 dot 10^6$
