#let cheatsheet(
  title: str,
  author: "Justin Iven Müller",
  year: datetime.today().year(),
  repoUrl: "https://github.com/JustinIven/zhaw-cheatsheets",
  repoLabel: "github.com/JustinIven/zhaw-cheatsheets",
  body,
) = {
  let myBlue = rgb("#0000FF")

  set document(title: title + "Cheatsheet", author: author)

  set page(
    paper: "a4",
    flipped: true,
    margin: 3mm,
    columns: 4,
  )
  set columns(gutter: 8pt)

  set text(lang: "de", font: "New Computer Modern", size: 8pt)

  show math.equation: set text(font: "New Computer Modern Math")

  set par(justify: false, leading: 0.5em, spacing: 0.65em)

  set heading(numbering: none)

  show link: set text(fill: myBlue)

  // remove list indentation.
  set list(indent: 0pt, body-indent: 0.4em, spacing: 0.6em)
  set enum(indent: 0pt, body-indent: 0.4em, spacing: 0.6em)

  // tight spacing, blue section.
  show heading: it => block(above: 0.8em, below: 0.5em, it)
  show heading.where(level: 1): set text(fill: myBlue, size: 12pt, weight: "bold")
  show heading.where(level: 2): set text(size: 10pt, weight: "bold")
  show heading.where(level: 3): set text(size: 8pt, weight: "bold")

  // Titel
  align(center, text(size: 14.4pt, weight: "bold", title))

  body

  // footer
  place(bottom + left, float: true, clearance: 0pt)[
    #line(length: 30%, stroke: 0.25pt)
    #text(size: 6pt)[
      By #author (#year)\
      #link(repoUrl)[#repoLabel]
    ]
  ]
}
