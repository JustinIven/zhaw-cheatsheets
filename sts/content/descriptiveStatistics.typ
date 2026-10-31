#import "@preview/cetz:0.4.2"

#let _lbl(body) = text(6pt, body)
#let _dash = (paint: gray, dash: "dashed", thickness: 0.4pt)
#let _axes(w, h, x: $x$, y: none) = {
  import cetz.draw: *
  let m = (end: "stealth", fill: black, scale: 0.4)
  line((0, 0), (w, 0), mark: m, stroke: 0.5pt)
  line((0, 0), (0, h), mark: m, stroke: 0.5pt)
  content((w, 0), _lbl(x), anchor: "north-east", padding: 0.08)
  if y != none { content((0, h), _lbl(y), anchor: "west", padding: 0.08) }
}

= Deskriptive Statistik
- *Deskriptiv:* Beschreibung, Darstellung, Kenngrössen, Datenvalidierung
- *Explorativ:* Suche nach Strukturen/Besonderheiten
- *Induktiv (schliessend):* mit W'keitsrechnung über Daten hinaus schliessen

== Begriffe
#table(
  columns: 2,
  stroke: none,
  align: left,
  [Merkmalsträger], [Statistische Einheit, an der beobachtet wird],
  [Grundgesamtheit], [Alle Einheiten, über die man Aussagen will (endlich/unendlich, real/hypothetisch)],
  [Vollerhebung], [Jede Einheit der Grundgesamtheit wird erfasst],
  [Stichprobe], [Untersuchte Teilmenge, repräsentativ; Zufallsstichprobe: jede Einheit gleiche Chance],
  [Stichprobengrösse $n$], [Anzahl Einheiten in der Stichprobe],
  [Merkmal (Variable)], [Beobachtete Grösse $X: Omega -> RR$, $x_i = X(omega_i)$],
  [Ausprägung], [Möglicher Wert eines Merkmals],
  [Urliste], [Stichprobenwerte $x_1, ..., x_n$ in Erhebungsreihenfolge],
)

== Merkmalstypen (Messniveau)
#table(
  columns: 3,
  align: left,
  [*Kategoriell* (qualitativ)], [Nominal], [Nur Kategorien, keine Ordnung (Partei, Tel.-Nr.)],
  [], [Ordinal], [Ordnung/Rangierung möglich (schlecht/mittel/gut)],
  [*Metrisch* (quantitativ)], [Diskret], [Endlich/abzählbar viele Werte (Würfel)],
  [], [Stetig], [Alle Werte in reellem Intervall (Laufzeit)],
)
Darstellung: kategoriell → Säulen-/Stabdiagramm; metrisch → zusätzlich Histogramm (Klassen).

== Häufigkeiten (univariat)
Stichprobe $x_1, ..., x_n$ mit $m$ verschiedenen Werten $a_1 < ... < a_m$:
- *Absolute Häufigkeit:* $h_i$ = Anzahl $x_j = a_i$, $sum h_i = n$
- *Relative Häufigkeit:* $f_i = h_i / n$, $sum f_i = 1$
- *PMF* (empirische Dichte, diskret): $f: RR -> [0,1]$, $f(x) = 0$ für $x != a_i$
- *Abs. Summenhäufigkeit:* $H(x) = sum_(i: a_i <= x) h_i$ (Anzahl $x_i <= x$)
- *CDF:* $F(x) = H(x)/n = sum_(i: a_i <= x) f_i$

*Eigenschaften CDF:* $0 <= F <= 1$, monoton wachsend, rechtsseitig stetige Treppenfunktion, springt bei $a_i$ um $f_i$. \
Anteil in $a < x_i <= b$: $F(b) - F(a)$; Anteil $> a$: $1 - F(a)$.

#align(center, grid(
  columns: 2,
  gutter: 6pt,
  cetz.canvas({
    import cetz.draw: *
    _axes(3, 1.5, y: $f(x)$)
    for (i, f) in (0.1, 0.3, 0.25, 0.2, 0.15).enumerate() {
      let x = (i + 1) * 0.5
      line((x, 0), (x, f * 4), stroke: 1pt + blue)
      circle((x, f * 4), radius: 0.05, fill: blue, stroke: none)
      content((x, 0), _lbl($a_#(i + 1)$), anchor: "north", padding: 0.05)
    }
    content((1, 1.2), _lbl($f_2$), anchor: "east", padding: 0.08)
  }),
  cetz.canvas({
    import cetz.draw: *
    _axes(3, 1.5, y: $F(x)$)
    let c = (0.1, 0.4, 0.65, 0.85, 1.0)
    line((0, 1.2), (2.9, 1.2), stroke: _dash)
    content((0, 1.2), _lbl[1], anchor: "east", padding: 0.05)
    for i in range(5) {
      let x = (i + 1) * 0.5
      let prev = if i == 0 { 0 } else { c.at(i - 1) }
      let x2 = if i == 4 { 2.9 } else { x + 0.5 }
      line((x, c.at(i) * 1.2), (x2, c.at(i) * 1.2), stroke: 1pt + blue)
      circle((x, prev * 1.2), radius: 0.04, fill: white, stroke: 0.5pt + blue)
      circle((x, c.at(i) * 1.2), radius: 0.04, fill: blue, stroke: none)
      content((x, 0), _lbl($a_#(i + 1)$), anchor: "north", padding: 0.05)
    }
  }),
))

== Klassierte Daten
Bei grossen Stichproben stetiger Merkmale: Bereich in angrenzende Klassen $c_i = [a, b[$ mit Breite $d_i = b - a$ einteilen; obere Grenze gehört zur nächsten Klasse. $h_i$, $f_i$: abs./rel. Häufigkeit der Klasse $c_i$.
- *Histogramm:* Häufigkeit = *Fläche* des Rechtecks (nicht Höhe!)
- Abs. Dichte (Höhe): $h_i / d_i$, rel. Dichte *PDF*: $f_i / d_i$
- *CDF:* $F(x) = integral_(-infinity)^x f(t) dif t$ → stetiger Polygonzug; an rechter Klassengrenze = kumulierte $f_i$
- *Faustregeln:* gleich breite Klassen; 5–20 Klassen, nicht wesentlich mehr als $sqrt(n)$
- Säulenhöhe schwankt um ca. $"Wert" plus.minus 2 sqrt("Wert")$ → Gipfel nur echt, wenn sich diese Intervalle nicht überschneiden

#align(center, grid(
  columns: 2,
  gutter: 6pt,
  cetz.canvas({
    import cetz.draw: *
    _axes(3.3, 1.5, y: $f_i \/ d_i$)
    let b = (0, 2, 4, 6, 10)
    let f = (0.2, 0.4, 0.25, 0.15)
    for i in range(4) {
      let d = b.at(i + 1) - b.at(i)
      rect(
        (b.at(i) * 0.3, 0),
        (b.at(i + 1) * 0.3, f.at(i) / d * 6),
        fill: blue.lighten(80%),
        stroke: 0.5pt + blue,
      )
    }
    for x in b { content((x * 0.3, 0), _lbl[#x], anchor: "north", padding: 0.05) }
    content((0.9, 0.6), _lbl[Fläche $= f_2$])
  }),
  cetz.canvas({
    import cetz.draw: *
    _axes(3.3, 1.5, y: $F(x)$)
    let pts = ((0, 0), (2, 0.2), (4, 0.6), (6, 0.85), (10, 1)).map(((x, y)) => (x * 0.3, y * 1.2))
    line((0, 1.2), (3.1, 1.2), stroke: _dash)
    content((0, 1.2), _lbl[1], anchor: "east", padding: 0.05)
    line(..pts, stroke: 1pt + blue)
    for p in pts { circle(p, radius: 0.035, fill: blue, stroke: none) }
    line((0, 0.6), (1.05, 0.6), (1.05, 0), stroke: _dash)
    content((0, 0.6), _lbl($q$), anchor: "east", padding: 0.05)
    content((1.05, 0.3), _lbl($R_q$), anchor: "west", padding: 0.05)
    content((0.6, 0), _lbl($a$), anchor: "north", padding: 0.05)
    content((1.2, 0), _lbl($b$), anchor: "north", padding: 0.05)
  }),
))

== Quantile
Geordnet: $x_([1]) <= ... <= x_([n])$ (Position = Rang). $q in (0, 1)$: Anteil. \
*Def.:* $R_q$ ist $q$-Quantil, falls Anteil $x_i <= R_q$ mindestens $q$ und Anteil $x_i >= R_q$ mindestens $1-q$. \
$0.25, 0.5, 0.75$-Quantil = 1., 2., 3. *Quartil* ($Q_1, Q_2, Q_3$); $q dot 100$-tes *Perzentil*.

*Berechnung (nicht klassiert):*
- $n q$ ganzzahlig: $R_q = 1/2 (x_([n q]) + x_([n q + 1]))$
- $n q$ nicht ganzzahlig: $R_q = x_([ceil(n q)])$ ($ceil(dot)$: aufrunden)

Aus CDF: $q$ trifft Plateau ($F(a) = q$) → $R_q = 1/2(a+b)$, $b$ nächster Wert; $q$ trifft Sprung → $R_q = a$.

*Median:* $x_"med" = cases(x_([(n+1)/2]) & n "ungerade", 1/2 (x_([n/2]) + x_([n/2 + 1])) & n "gerade")$

*Interquartilsabstand:* $"IQR" = Q_3 - Q_1$ (Streumass zum Median, enthält mittlere 50%)

*Klassiert:* $R_q = F^(-1)(q)$ (lineare Interpolation, siehe Grafik oben). Klasse $[a, b[$ mit $F(a) <= q <= F(b)$:
$ R_q = a + ((b-a)(q - F(a)))/(F(b) - F(a)) $

numpy `quantile` kann abweichen (bei grossem $n$ unerheblich).

== Boxplot
- *Box:* von $Q_1$ bis $Q_3$, Strich bei Median
- *Untere Antenne:* kleinster Wert mit Abstand $<= 1.5 dot "IQR"$ von $Q_1$
- *Obere Antenne:* grösster Wert mit Abstand $<= 1.5 dot "IQR"$ von $Q_3$
- *Ausreisser:* alle Werte ausserhalb Box + Antennen (einzeln eingezeichnet)

#align(center, cetz.canvas({
  import cetz.draw: *
  let (lo, q1, md, q3, hi, fence, out) = (0.6, 2, 2.8, 3.6, 5.2, 6, 6.4).map(v => v * 0.9)
  let st = 0.6pt + blue
  rect((q1, 0), (q3, 0.5), fill: blue.lighten(80%), stroke: st)
  line((md, 0), (md, 0.5), stroke: 1.2pt + blue)
  line((lo, 0.25), (q1, 0.25), stroke: st)
  line((q3, 0.25), (hi, 0.25), stroke: st)
  line((lo, 0.1), (lo, 0.4), stroke: st)
  line((hi, 0.1), (hi, 0.4), stroke: st)
  circle((out, 0.25), radius: 0.05, stroke: st)
  line((fence, -0.05), (fence, 0.75), stroke: _dash)
  let m = (start: "|", end: "|", scale: 0.5)
  line((q1, 0.7), (q3, 0.7), mark: m, stroke: 0.4pt)
  content(((q1 + q3) / 2, 0.7), _lbl[IQR], anchor: "south", padding: 0.05)
  line((q3, 0.7), (fence, 0.7), mark: m, stroke: 0.4pt)
  content(((q3 + fence) / 2, 0.7), _lbl[$1.5 dot$ IQR], anchor: "south", padding: 0.05)
  for (x, l) in ((q1, $Q_1$), (md, $x_"med"$), (q3, $Q_3$), ((q3 + hi) / 2, [Antenne]), (out, [Ausreisser])) {
    content((x, 0), _lbl(l), anchor: "north", padding: 0.05)
  }
}))

== Lagemasse
- *Modus* $x_"mod"$: häufigster Wert (nicht eindeutig); klassiert: Mitte der Klasse mit grösstem $f_i$
- *Arithm. Mittel:* $overline(x) = 1/n sum_(i=1)^n x_i = 1/n sum_(i=1)^m a_i h_i = sum_(i=1)^m a_i f_i$
- *Median* $x_"med"$: teilt Stichprobe in zwei gleich grosse Hälften

== Streuungsmasse
*Empirische Varianz:*
$
  tilde(s)^2 = 1/n sum_(i=1)^n (x_i - overline(x))^2 = 1/n sum_(i=1)^m h_i (a_i - overline(x))^2 = (sum_(i=1)^m a_i^2 f_i) - overline(x)^2
$
*Standardabweichung:* $tilde(s) = sqrt(tilde(s)^2)$ (gleiche Einheit wie Daten)

*Korrigiert* (Schätztheorie, Faktor $n-1$):
$ s^2 = 1/(n-1) sum_(i=1)^n (x_i - overline(x))^2 = n/(n-1) tilde(s)^2, quad s = sqrt(s^2) $

*Klassiert:* Mittel und Varianz mit Klassenmitten als $a_i$ berechnen.

- *Tschebyscheff:* mind. 75% der Werte in $overline(x) plus.minus 2s$
- *Annähernd normalverteilt:* ca. 68% in $overline(x) plus.minus s$, ca. 95% in $overline(x) plus.minus 2s$

Python: `np.var(x)` = $tilde(s)^2$, `np.var(x, ddof=1)` = $s^2$ (analog `np.std`)

== Form der Verteilung
#table(
  columns: 2,
  align: left,
  [Rechtsschief (linkssteil)], [$x_"mod" < x_"med" < overline(x)$],
  [Symmetrisch], [$x_"mod" = x_"med" = overline(x)$],
  [Linksschief (rechtssteil)], [$x_"mod" > x_"med" > overline(x)$],
)
Ein Maximum: *unimodal*; zwei/mehrere: *bimodal* bzw. *multimodal*.

#align(center, cetz.canvas({
  import cetz.draw: *
  _axes(4.3, 1.4, y: [rechtsschief])
  line(..range(0, 46).map(i => (i / 10 * 0.9, i / 10 * calc.exp(-i / 10) * 3)), stroke: 1pt + blue)
  for (x, l, a) in ((1, $x_"mod"$, "north-east"), (1.678, $x_"med"$, "north"), (2, $overline(x)$, "north-west")) {
    line((x * 0.9, 0), (x * 0.9, x * calc.exp(-x) * 3), stroke: _dash)
    content((x * 0.9, 0), _lbl(l), anchor: a, padding: 0.05)
  }
}))
