// Helpers for drawing ER diagrams (Chen-Notation der Vorlesung) with cetz.
// Shapes are dicts; `node` draws them, `arr` draws labelled arrows between them.
#import "@preview/cetz:0.4.2"

#let _len(label) = label.clusters().len()

// Entitätstyp (Rechteck)
#let ent(x, y, label, w: auto, h: 0.5) = (
  kind: "rect",
  pos: (x, y),
  w: if w == auto { calc.max(0.9, 0.12 * _len(label) + 0.4) } else { w },
  h: h,
  label: label,
)

// Beziehungstyp (Rhombus); composite: true = zusammengesetzter Entitätstyp
#let rel(x, y, label, w: auto, h: 0.6, composite: false) = (
  kind: if composite { "comp" } else { "rel" },
  pos: (x, y),
  w: if w == auto { 0.15 * _len(label) + 0.7 } else { w },
  h: h,
  label: label,
)

// Attribut (Oval), Position relativ zum Besitzer
#let attr(owner, dx, dy, label, key: false, multi: false, w: auto, h: 0.36) = (
  kind: "ell",
  pos: (owner.pos.at(0) + dx, owner.pos.at(1) + dy),
  w: if w == auto { 0.11 * _len(label) + 0.35 } else { w },
  h: h,
  label: label,
  owner: owner,
  key: key,
  multi: multi,
)

// Randpunkt einer Form in Richtung (dx, dy)
#let _border(s, dx, dy) = {
  let (x, y) = s.pos
  let (a, b) = (s.w / 2, s.h / 2)
  let t = if s.kind == "rel" {
    1 / (calc.abs(dx) / a + calc.abs(dy) / b)
  } else if s.kind == "ell" {
    1 / calc.sqrt(calc.pow(dx / a, 2) + calc.pow(dy / b, 2))
  } else {
    calc.min(
      if dx == 0 { 1e9 } else { a / calc.abs(dx) },
      if dy == 0 { 1e9 } else { b / calc.abs(dy) },
    )
  }
  (x + t * dx, y + t * dy)
}

#let _shifted(s, nx, ny, d) = s + (pos: (s.pos.at(0) + nx * d, s.pos.at(1) + ny * d))

#let _ends(s1, s2, shift: 0) = {
  let dx = s2.pos.at(0) - s1.pos.at(0)
  let dy = s2.pos.at(1) - s1.pos.at(1)
  let l = calc.sqrt(dx * dx + dy * dy)
  let (nx, ny) = (-dy / l, dx / l)
  let a = _shifted(s1, nx, ny, shift)
  let b = _shifted(s2, nx, ny, shift)
  (_border(a, dx, dy), _border(b, -dx, -dy), nx, ny)
}

#let node(..shapes) = {
  import cetz.draw: *
  for s in shapes.pos() {
    let (x, y) = s.pos
    let (a, b) = (s.w / 2, s.h / 2)
    if s.kind == "rect" {
      rect((x - a, y - b), (x + a, y + b))
    } else if s.kind == "rel" or s.kind == "comp" {
      if s.kind == "comp" { rect((x - a, y - b), (x + a, y + b)) }
      line((x - a, y), (x, y + b), (x + a, y), (x, y - b), close: true)
    } else {
      let (p, q, ..) = _ends(s, s.owner)
      line(p, q)
      if s.multi {
        for i in (2, 1) { circle((x - 0.07 * i, y), radius: (a, b), fill: white) }
      }
      circle((x, y), radius: (a, b), fill: white)
    }
    content((x, y), if s.at("key", default: false) { underline(s.label) } else { s.label })
  }
}

// Pfeil von `from` nach `to` mit Beschriftung (1, m, ID, ISA)
#let arr(from, to, label: none, side: 1, shift: 0, at: 0.6) = {
  import cetz.draw: *
  let (p, q, nx, ny) = _ends(from, to, shift: shift)
  line(p, q, mark: (end: "stealth", fill: black, scale: 0.5))
  if label != none {
    let m = (p.at(0) + (q.at(0) - p.at(0)) * at, p.at(1) + (q.at(1) - p.at(1)) * at)
    content((m.at(0) + nx * 0.17 * side, m.at(1) + ny * 0.17 * side), label)
  }
}

#let er(body, length: 1cm) = align(center, text(size: 6pt, cetz.canvas(length: length, {
  cetz.draw.set-style(stroke: 0.4pt)
  body
})))
