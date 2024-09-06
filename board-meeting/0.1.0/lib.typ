#import "colors.typ" as colors: *

// This template is mostly adapted from
// - https://github.com/DVDTSB/dvdtyp/
//   Copyright (c) 2024 DVDTSB
// - https://github.com/piepert/grape-suite/blob/main/src/exercise.typ
//   Copyright (c) 2024 Tristan Pieper

#let meeting(
  title: "",
  subtitle: none,

  header: none,
  header-right: none,
  header-middle: none,
  header-left: none,

  footer: none,
  footer-right: none,
  footer-middle: none,
  footer-left: none,

  body,
) = {
  set document(title: title)

  set text(font: "Atkinson Hyperlegible", lang: "fi")

  set page(
    numbering: "1",
    number-align: center,
    header: locate(loc => {
      if loc.page() == 1 {
        return
      }
      grid(columns: (30%, 1fr, 30%),
        [],
        box(stroke: (bottom: 0.7pt), inset: 0.2em)[#title],
        align(right, image("otanix.svg", height: 75%)),
      )
    }),

    footer: if footer != none {footer} else {
      set text(size: 0.75em)
      line(length: 100%, stroke: blue) + v(-0.5em)

      table(columns: (1fr, auto, 1fr),
        align: top,
        stroke: none,
        inset: 0pt,

        if footer-left != none {footer-left},

        align(center, context {
          str(counter(page).display())
          [ \/ ]
          str(counter(page).final().first())
        }),

        if footer-left != none {footer-left}
      )
    },
  )

  set heading(numbering: "1.")

  show link: underline
  show link: set text(fill: blue)

  show heading: it => context {
    let num-style = it.numbering

    if num-style == none {
        return it
    }

    let num = text(weight: "thin", numbering(num-style, ..counter(heading).at(here()))+[ \u{200b}])
    let x-offset = -1 * measure(num).width

    pad(left: x-offset, par(hanging-indent: -1 * x-offset, text(fill: blue.lighten(25%), num) + [] + text(fill: blue, it.body)))
  }

  show math.equation: set text(weight: 400)


  // Title row.
  align(center, {
    image("otanix.svg", height: 6em)

    block(text(weight: 700, 25pt, title))
    v(0.8em, weak: true)
    if subtitle != none [#text(18pt, weight: 500)[#subtitle]] else {v(18pt, weak: true)}
    v(2em)
  })

  // Main body.
  set par(
    justify: true,
    first-line-indent: 1em,
  )

  body
}

#let opening(start-time: [--], attendees: (), body) = {
  [
    = Kokouksen avaus ja läsnäolijat

    Kokous avataan kello #start-time.

    == Läsnäolijat
  ]

  list(..attendees.map(list.item))

  body
}

#let lawfulness(board-members-present: 0, body) = {
  let laillinen = if board-members-present >= 3 [
    Kokous on laillinen ja päätosvaltainen, koska paikalla on $gt.eq 3$ hallituksen jäsentä.
  ] else [
    Kokous *ei ole* laillinen ja päätosvaltainen, koska paikalla on vain $#board-members-present$ hallituksen jäsentä.
  ]
  [
    = Kokouksen laillisuus ja päätösvaltaisuus

    #laillinen
  ]

  body
}

#let agenda(accepted: false, format: true, items) = {
  show enum: content => if format {
    content.children.map(esitys => {
      let (heading, children) = if esitys.body.has("text") {
        (esitys.body.text, none)
      } else {
        (esitys.body.children.at(0), esitys.body.children.slice(1).join())
      }

      [
        == #heading

        #children
      ]
    }).join()
  } else { content }

  [
    = Esityslistan hyväkysminen
  ]

  if accepted [
    Esityslista on hyväksytty.
  ]

  items
}


#let closing(end-time: [--], body) = {
  [
    = Kokouksen päättäminen

    Kokous päätetään kello #end-time.
  ]

  body
}