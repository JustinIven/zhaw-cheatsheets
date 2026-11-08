#import "@preview/cetz:0.4.2"

#let _lbl(body) = text(6pt, body)
#let _dash = (paint: gray, dash: "dashed", thickness: 0.4pt)
#let _arrow = (end: "stealth", fill: black, scale: 0.4)
#let _graph(f, a, b, tx, ty, n: 40) = {
  import cetz.draw: *
  let pts = range(n + 1).map(i => {
    let x = a + (b - a) * i / n
    (tx(x), ty(f(x)))
  })
  line(..pts, stroke: 0.8pt + blue)
}
#let _fig(caption, body) = stack(spacing: 3pt, body, align(center, _lbl(caption)))

// Cobweb plot of x_(n+1) = F(x_n) in window [lo, hi]; F drawn on [ga, gb]
#let _cobweb(F, lo, hi, ga, gb, x0, steps, xbar, s) = cetz.canvas({
  import cetz.draw: *
  let t(v) = (v - lo) * s
  let w = t(hi)
  line((0, 0), (w + 0.1, 0), mark: _arrow, stroke: 0.5pt)
  line((0, 0), (0, w + 0.1), mark: _arrow, stroke: 0.5pt)
  line((0, 0), (w, w), stroke: 0.5pt + gray)
  content((w, w), _lbl($y = x$), anchor: "north-west", padding: 0.03)
  _graph(F, ga, gb, t, t)
  let x = x0
  let pts = ((t(x), 0),)
  for _ in range(steps) {
    let y = F(x)
    pts.push((t(x), t(y)))
    pts.push((t(y), t(y)))
    x = y
  }
  line(..pts, stroke: 0.6pt + red)
  circle((t(xbar), t(xbar)), radius: 0.04, fill: black, stroke: none)
  line((t(xbar), 0), (t(xbar), t(xbar)), stroke: _dash)
  content((t(xbar), 0), _lbl($overline(x)$), anchor: "north-east", padding: 0.03)
  content((t(x0), 0), _lbl($x_0$), anchor: "north-west", padding: 0.03)
})

// Newton-type methods on f(x) = x^2 - 1
#let _f(x) = x * x - 1
#let _tx(x) = (x - 0.5) * 0.75
#let _ty(y) = y * 0.2
#let _rootfig(draw) = cetz.canvas({
  import cetz.draw: *
  line((0, 0), (_tx(3) + 0.1, 0), mark: _arrow, stroke: 0.5pt)
  _graph(_f, 0.5, 3, _tx, _ty)
  draw
})
#let _xmark(x, i) = {
  import cetz.draw: *
  line((_tx(x), 0), (_tx(x), _ty(_f(x))), stroke: _dash)
  content((_tx(x), 0), _lbl($x_#i$), anchor: "north", padding: 0.05)
}
#let _newton(simplified: false) = _rootfig({
  import cetz.draw: *
  let x = 3
  let s0 = 2 * x
  for i in range(3) {
    let xn = x - _f(x) / (if simplified { s0 } else { 2 * x })
    _xmark(x, i)
    line((_tx(x), _ty(_f(x))), (_tx(xn), 0), stroke: 0.6pt + red)
    x = xn
  }
})
#let _secant = _rootfig({
  import cetz.draw: *
  let xs = (3, 2.2)
  for _ in range(2) {
    let (a, b) = (xs.at(-2), xs.at(-1))
    xs.push(b - (b - a) / (_f(b) - _f(a)) * _f(b))
  }
  for (i, x) in xs.enumerate() { _xmark(x, i) }
  for i in range(2) {
    line((_tx(xs.at(i)), _ty(_f(xs.at(i)))), (_tx(xs.at(i + 2)), 0), stroke: 0.6pt + red)
  }
})

= Nullstellenprobleme
Gesucht: Näherung für Nullstelle $overline(x)$ von stetigem $f: RR -> RR$. $g(x) = h(x) <=> f(x) := g(x) - h(x) = 0$.\
Vorab klären: Existiert eine Nullstelle, wo? Mehrere, welche gesucht?\
Resultate i.~d.~R. als $plus.minus m_1.m_2 m_3 m_4 m_5 dot 10^(plus.minus e)$, $m_1 != 0$.

== Fixpunktiteration
- *Fixpunktgleichung:* $F(x) = x$
- *Fixpunkt:* Lösung $overline(x)$ mit $F(overline(x)) = overline(x)$
- $f(x) = 0$ in Form $F(x) = x$ bringen (viele Möglichkeiten), Lösungsmenge darf sich *nicht* ändern. Z.~B. $x^3 - x + 0.3 = 0$: $F(x) = x^3 + 0.3$ oder $F(x) = root(3, x - 0.3)$
- Graphisch: Schnittpunkte von $y = F(x)$ und $y = x$

*Fixpunktiteration* von $F: [a, b] -> RR$ zum Startwert $x_0 in [a, b]$:
$ x_(n+1) = F(x_n), quad n = 0, 1, 2, ... $
1 Funktionsauswertung pro Schritt. Verschiedene $F$ zum selben Problem können unterschiedlich konvergieren.

=== Anziehend / abstossend
$F$ mit stetigem $F'$, $overline(x) in [a, b]$ Fixpunkt:
- *Anziehender Fixpunkt:* Ist $|F'(overline(x))| < 1$, so konvergiert $x_n -> overline(x)$, falls der Startwert $x_0$ nahe genug bei $overline(x)$ liegt; (je kleiner $|F'(overline(x))|$, desto schneller)
- *Abstossender Fixpunkt:* Ist $|F'(overline(x))| > 1$, so konvergiert $x_n$ für kein $x_0 != overline(x)$.

#align(center, grid(
  columns: 2,
  gutter: 8pt,
  _fig(
    [anziehend: $F(x) = cos x$],
    _cobweb(calc.cos, 0, 1.1, 0, 1.1, 0.1, 10, 0.7391, 2),
  ),
  _fig(
    [abstossend: $F(x) = x^3 + 0.3$],
    _cobweb(x => x * x * x + 0.3, 0.6, 1, 0.67, 0.888, 0.8, 4, 0.7864, 5.5),
  ),
))

=== Banachscher Fixpunktsatz
Sei $F: [a, b] -> [a, b]$ (bildet $[a, b]$ auf sich ab) und $exists alpha in (0, 1)$ mit
$ |F(x) - F(y)| <= alpha |x - y| quad forall x, y in [a, b] $
(Lipschitz-stetig, kontraktiv; $alpha$ = Lipschitz-Konstante). Dann:
- $F$ hat *genau einen* Fixpunkt $overline(x)$ in $[a, b]$
- $x_(n+1) = F(x_n)$ konvergiert gegen $overline(x)$ für *alle* $x_0 in [a, b]$
- Fehlerabschätzungen:
$
  |x_n - overline(x)| & <= alpha^n / (1 - alpha) |x_1 - x_0|   &     quad "a-priori" \
  |x_n - overline(x)| & <= alpha / (1 - alpha) |x_n - x_(n-1)| & quad "a-posteriori"
$
$alpha$ = grösste Steigung von $F$ auf $[a, b]$: $alpha = max_(x in [a, b]) |F'(x)|$. Intervall eng um $overline(x)$ $=> alpha approx |F'(overline(x))|$.

*Vorgehen:*
+ $F([a, b]) subset.eq [a, b]$ prüfen (bei monotonem $F$: $F(a), F(b) in [a, b]$)
+ $alpha = max_([a, b]) |F'(x)| < 1$ bestimmen
+ Iterationen für Toleranz $"tol"$ (a-priori nach $n$ aufgelöst):
$ n >= ln(("tol" dot (1 - alpha)) / (|x_1 - x_0|)) / ln(alpha) $

== Newton-Verfahren
Nullstelle der Tangente $g(x) = f(x_n) + f'(x_n)(x - x_n)$ in $x_n$ als neue Näherung ($f$ stetig differenzierbar, $f'(x_n) != 0$):
$ x_(n+1) = x_n - f(x_n) / (f'(x_n)) $
- Startwert nahe bei Nullstelle wählen; ungeeignet, wo Tangente fast parallel zur $x$-Achse
- *Hinreichende Konvergenzbedingung* auf $[a, b]$ (enthält alle $x_n$ und $overline(x)$), i.~d.~R. mind. für $x_0$ prüfen:
$ abs((f(x) dot f''(x)) / ([f'(x)]^2)) < 1 $
- $f(x) = x^2 - A$ ergibt Heron-Verfahren: $x_(n+1) = 1/2 (x_n + A / x_n)$

=== Vereinfachtes Newton-Verfahren
Ableitung nur einmal bei $x_0$ berechnen (konvergiert langsamer):
$ x_(n+1) = x_n - f(x_n) / (f'(x_0)) $

=== Sekantenverfahren
Ableitung durch Sekantensteigung ersetzt; 2 Startwerte $x_0, x_1$, keine Ableitung nötig, konvergiert langsamer:
$ x_(n+1) = x_n - (x_n - x_(n-1)) / (f(x_n) - f(x_(n-1))) dot f(x_n), quad n = 1, 2, ... $

#align(center, grid(
  columns: 3,
  gutter: 6pt,
  _fig([Newton (Tangenten)], _newton()),
  _fig([Vereinf. Newton (parallel)], _newton(simplified: true)),
  _fig([Sekanten], _secant),
))

== Konvergenzordnung
Sei $(x_n)$ gegen $overline(x)$ konvergent. Das Verfahren hat *Konvergenzordnung* $q >= 1$, wenn $exists c > 0$ mit
$ |x_(n+1) - overline(x)| <= c dot |x_n - overline(x)|^q quad forall n $
Für $q = 1$ zusätzlich $c < 1$. $q = 1$: *linear*, $q = 2$: *quadratisch* (z.~B. $c = 1$, Fehler $10^(-2) -> 10^(-4) -> 10^(-8)$).
#table(
  columns: 2,
  align: left,
  [Verfahren (einfache Nullstelle)], [$q$],
  [Newton], [$2$],
  [Vereinfachtes Newton], [$1$],
  [Sekantenverfahren], [$(1 + sqrt(5)) / 2 approx 1.618$],
)

== Fehlerabschätzung
*Nullstellensatz von Bolzano:* $f: [a, b] -> RR$ stetig mit $f(a) <= 0 <= f(b)$ oder $f(a) >= 0 >= f(b)$ $=>$ $f$ hat Nullstelle in $[a, b]$. Insb. $f(a) dot f(b) < 0 =>$ mind. eine Nullstelle.

Für Näherung $x_n$ einer Nullstelle $xi$ *ungerader Ordnung* (Schnitt-, kein Berührungspunkt) und Toleranz $epsilon > 0$:
$ f(x_n - epsilon) dot f(x_n + epsilon) < 0 quad => quad |x_n - xi| < epsilon $
Für jedes iterative Verfahren anwendbar.

*Abbruchkriterien* (zusätzlich, z.~B. bei Berührungspunkten / schlechter Kondition):
- Max. Anzahl Iterationen $N_max$
- $|f(x_n)| < epsilon$ oder $|x_(n+1) - x_n| < epsilon$ (nur notwendig, *keine Garantie* für Nähe zur Nullstelle)
