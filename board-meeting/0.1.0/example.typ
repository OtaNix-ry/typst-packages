// #import "@preview/grape-suite:1.0.0": exercise
// #import exercise: project, task, subtask

#import "lib.typ": *

#show: meeting.with(
  title: "OtaNix ry hallituksen kokous",
  subtitle: "Mallidokumentti"
)

#opening(
  // start-time: "12.00",
  attendees: ("Etunimi Sukunimi", "Etunimi Sukunimi", lorem(2))
)[]

#lawfulness(
  board-members-present: 3
)[]

#agenda(
  // accepted: true
  // format: false
)[
+ Google workspaces for non-profits haku
  - palvelun käytöstä pitää myös sopia, saako esim. kaikki jäsenet \@otanix.fi spostin?
+ AYY yhdistysrekisteriin haku
+ Järjestettävät tapahtumat
  - Neomutt/email workshop
  - Agenix workshop
  - GPG-agent SSH integraatio YubiKey workshop
  - Ferris-pehmolelu workshop
+ Seuraavat tapaamiset
  - Säännölliset hallituksen kokoukset?
+ Typst template pöytäkirjoille ja muille dokumenteille (w/logo, etc.)
+ #lorem(5)
  #lorem(20)
]

= #lorem(5)

#lorem(100)

#closing(
  // end-time: "12.30",
)[]