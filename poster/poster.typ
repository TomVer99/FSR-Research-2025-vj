#import "@preview/cetz:0.3.4": canvas, draw
#import "@preview/cetz-plot:0.1.1": plot
#import "@preview/subpar:0.2.2"
#import "@preview/cades:0.3.0": qr-code

#import "./figures.typ": (
  bland_altman_data, bland_altman_normal_talking, bland_altman_o_sound, bland_altman_rr, bland_altman_rr_talking,
  bland_altman_whisper_talking, elec_diagram, hr_combined_altman, test_setup_infographic,
)

#set text(size: 22pt, font: "Roboto")

#set page("a1", margin: (left: 5cm, top: 1cm, right: 1cm, bottom: 1cm), background: [
  #place(horizon + left, dx: 10pt)[
    #canvas({
      import draw: *

      rotate(90deg)
      scale(x: 1.5, y: 1.6)
      set-style(stroke: blue + 2.5pt)

      let calc-displace(val) = { ((7 - 1.5) * val) }

      for value in range(11) {
        line((1.5 + calc-displace(value), 0), (2 + calc-displace(value), 0))
        bezier(
          (2 + calc-displace(value), 0),
          (3 + calc-displace(value), 0),
          (2.6 + calc-displace(value), .5),
          (2.75 + calc-displace(value), .5),
        )
        line((3 + calc-displace(value), 0), (3.8 + calc-displace(value), 0))
        line((3.8 + calc-displace(value), 0), (4 + calc-displace(value), -.5))
        line((4 + calc-displace(value), -.5), (4.2 + calc-displace(value), 2))
        line((4.2 + calc-displace(value), 2), (4.4 + calc-displace(value), -.7))
        line((4.4 + calc-displace(value), -.7), (4.6 + calc-displace(value), 0))
        line((4.6 + calc-displace(value), 0), (5.3 + calc-displace(value), 0))
        bezier(
          (5.3 + calc-displace(value), 0),
          (6 + calc-displace(value), 0),
          (5.6 + calc-displace(value), .7),
          (5.75 + calc-displace(value), .7),
        )
        line((6 + calc-displace(value), 0), (7 + calc-displace(value), 0))
      }
    })
  ]
  #place(horizon + center, dy: 0pt, dx: 708pt)[
    // #place(horizon + center, dy:0pt, dx:0pt)[
    #canvas({
      import draw: *

      scale(1.4)

      set-style(
        fill: gray.transparentize(90%),
        stroke: none,
      )

      line((0, 12), (0, -50))

      merge-path({
        line((-13, -10), (-15, -10))
        arc((-15, -10), radius: 7.5, start: 90deg, stop: 180deg)
        line((-22.5, -17.5), (-15, -17.5))
        arc((-15, -17.5), radius: 1, start: 180deg, stop: 0deg, fill: none)
      })

      circle((0, 2), radius: 10)
      rect((-13, -50), (13, -10))
      rect((-22.5, -40), (-15, -17.5))
      arc((-15, -40), radius: 3.75, start: 0deg, stop: -180deg)
    })
  ]
])


// #let accent-color = black
#let accent-color = blue.darken(50%)

#let title-content = [
  #text(size: 44pt)[
    = Impact of speech on non-invasive sleep metric measurements using an FSR sensor placed under a mattress
  ]
]
#let author-content = [
  T.S. Verlinde
  // Tom
]
#let intro-content = [
  = Introduction

  Collecting reliable sleep metrics requires people to go to specialised places where current standard methods can be used.
  This can cause stress due to unfamiliar environments.
  It also has a limitation of time; a patient cannot just be monitored for a week or more without a serious reason.

  Recently, various studies have been performed on measuring heart rate (HR) and respiratory rate (RR) using non-invasive methods.
  A subset of these studies has focused on methods that are low-cost and reliable.

  This subset specifically has taken an interest in FSR sensors.
  FSR sensors (depicted in @infoB) are cheap and have favourable characteristics.

  #grid(
    columns: (1.5fr, 3fr),
    [
      #figure(image("20250411_1803292.jpg", height: 5cm), caption: [Close-up image of an FSR sensor])<infoB>
    ],
    [
      #figure(
        canvas({
          import "./sing_beat_bcg.typ": data as bcg_data
          // import "./sing_beat_ecg.typ": data as ecg_data
          plot.plot(
            size: (12, 6),
            y-label: [Volt (mV)],
            x-label: "Time (s)",
            x-inset: 0.5,
            x-tick-step: 0.33 / 2,
            y-tick-step: 1,
            // y2-tick-step: 0.2,
            y-inset: 0.25,
            // y2-inset: 0.25,
            {
              // plot.add(((0, 0), (1, 1)), axes: ("x", "y"))
              // plot.add(((0, 0), (1, 1)), axes: ("x", "y2"))
              plot.add(bcg_data, axes: ("x", "y"))
              // plot.add(ecg_data, axes: ("x", "y2"))
            },
          )
        }),
        caption: [Raw BCG for a single heartbeat],
      )<single_beat>
    ],
  )

  However, these studies have only been performed in recent years, and because of that, the test environments that have been set up have been rather ideal.

  This study tried to increase the understanding of FSR-based systems by looking into the effects of sleep talking.
  To research the impact of sleep talking, the effect of normal speech has initially been investigated.
  This is to ease the research process and improve the reliability and repeatability of the test setup.
  It aimed to gain insight into the seriousness of the possible impact of sleep talking.
]
#let methodology-content = [
  = Methodology

  For this research, an FSR Model 408 #emph[(blue strip in @infoA)] has been used.
  It was placed under a mattress and positioned so that the thorax #emph[(depicted as orange in @infoA)] was directly above the sensor.

  #figure(
    canvas({
      import draw: *

      set-style(stroke: black + 2pt)

      scale(0.9)

      // Head
      bezier((3.4, 2.5), (3.6, 3.4), (3.4, 2.8), (3.2, 3))
      bezier((3.6, 3.4), (3.7, 3.3), (3.7, 3.4))
      bezier((3.4, 2.5), (3.8, 2), (3.4, 2.1))
      line((3.8, 2), (4.7, 2))
      bezier((4.7, 2), (4.9, 2.1), (4.8, 2.1))
      line((4.9, 2.1), (4.95, 2.2))
      bezier((5.4, 2.2), (4.35, 2.3), (4.5, 2.2))
      bezier((3.7, 3.3), (3.6, 2.8), (3.6, 3.3))
      bezier((3.6, 2.8), (3.85, 2.8), (3.725, 2.6))
      bezier((3.85, 2.8), (4.1, 2.55), (3.85, 2.55))
      bezier((4.1, 2.55), (4.4, 2.4), (4, 2.2), (4.2, 2))
      bezier((3.7, 3.3), (4.1, 3.4), (3.8, 3.4))
      bezier((4.1, 3.4), (4.4, 3.4), (4.3, 3.5))
      bezier((4.4, 3.4), (4.6, 3.4), (4.5, 3.5))
      bezier((4.6, 3.4), (5., 2.8), (5.5, 3.4))
      line((5.15, 3), (5.35, 2.98))

      // Thorax fill
      merge-path(fill: orange.transparentize(50%), stroke: none, {
        // bezier((5.6,2), (5.3,2.5), (5.3,2.2))
        // bezier((5.3,2.5), (5.6,3.3), (5.3,3.2))
        bezier((5.6, 3.3), (7.8, 3.5), (6, 3.5))
        line((7.8, 3.5), (7.8, 2))
        line((7.8, 2), (5.6, 2))
      })

      // Body
      bezier((5.6, 2), (5.3, 2.5), (5.3, 2.2))
      bezier((5.3, 2.5), (5.6, 3.3), (5.3, 3.2))
      bezier((5.6, 3.3), (7.8, 3.5), (6, 3.5))
      line((5.6, 2), (18, 2))
      bezier((6.2, 3), (8, 3.3), (7.4, 2.3), (7.6, 2.3))
      bezier((7.2, 2.53), (6.8, 2), (6.9, 2.3))
      bezier((8.2, 2), (8.5, 3.3), (8.5, 2.3), (8.5, 3.2))
      bezier((8.5, 3.3), (8.8, 3.4), (8.5, 3.4))
      bezier((8.8, 3.4), (8.5, 3.7), (8.8, 3.6))
      bezier((8.5, 3.7), (7.8, 3.5), (8.3, 3.8))
      bezier((7.8, 3.5), (8, 3.3), (8, 3.5))
      bezier((8.8, 3.4), (10, 3.7), (9.5, 3.4))
      bezier((10, 3.7), (10, 2), (10.4, 3.5))

      // Legs
      bezier((10.05, 3.65), (11.75, 5.5), (10.5, 4.5))
      bezier((11.75, 5.5), (12.5, 5.5), (12.15, 5.8))
      bezier((12.5, 5.5), (13, 3.25 - 0.1), (13, 5))
      bezier((11.6, 3.5 - 0.1), (12.2, 4.6), (11.7, 4))
      bezier((11.9, 4.22), (12, 3.4 - 0.1), (12, 4))
      bezier((11, 3.65 - 0.1), (12.5, 3.25 - 0.1), (11.5, 3.6 - 0.1))
      bezier((12.5, 3.25 - 0.1), (14.5, 3 - 0.1), (13.5, 3.25 - 0.1))
      bezier((14.5, 3 - 0.1), (15.5, 2.7), (14.8, 2.9))
      bezier((15.5, 2.7), (17, 2.8), (16, 2.7), (16.5, 2.8))
      line((17, 2.8), (17, 2))

      // Foot
      bezier((17, 2.7), (18.5, 3.4), (18, 2.9))
      bezier((18.5, 3.4), (18.5, 3.3), (18.55, 3.4))
      bezier((18.5, 3.3), (18.3, 2.6), (18.5, 3))
      bezier((18.3, 2.6), (17.6, 2), (18.1, 2.3))
      line((17.6, 2), (17.3, 2))
      line((17, 2.15), (17.3, 2))


      // Bed
      rect((2, 1), (20, 2), radius: 2pt)

      // Sensor + box
      rect((6.75, 0.75), (7.25, 0.9), fill: blue.lighten(20%).transparentize(50%), stroke: blue.lighten(20%))

      // Signal


      translate(y: -6)

      rect((6.75, 2.1), (7.25, 3.9), fill: blue.lighten(20%).transparentize(50%), stroke: blue.lighten(20%))

      line((5.25, 0), (9.25, 0))
      line((5.25, 6), (9.25, 6))

      line((5.25, 0), (4.25, 0), stroke: (dash: "dashed", thickness: 2pt))
      line((5.25, 6), (4.25, 6), stroke: (dash: "dashed", thickness: 2pt))

      line((10.25, 0), (9.25, 0), stroke: (dash: "dashed", thickness: 2pt))
      line((10.25, 6), (9.25, 6), stroke: (dash: "dashed", thickness: 2pt))

      line((5.5, 0), (5, 1.5), stroke: (dash: "dashed", thickness: 2pt))
      line((5.5, 3), (5, 1.5), stroke: (dash: "dashed", thickness: 2pt))
      line((5.5, 3), (5, 4.5), stroke: (dash: "dashed", thickness: 2pt))
      line((5.5, 6), (5, 4.5), stroke: (dash: "dashed", thickness: 2pt))

      line((3.5 + 5.5, 0), (3.5 + 5, 1.5), stroke: (dash: "dashed", thickness: 2pt))
      line((3.5 + 5.5, 3), (3.5 + 5, 1.5), stroke: (dash: "dashed", thickness: 2pt))
      line((3.5 + 5.5, 3), (3.5 + 5, 4.5), stroke: (dash: "dashed", thickness: 2pt))
      line((3.5 + 5.5, 6), (3.5 + 5, 4.5), stroke: (dash: "dashed", thickness: 2pt))


      line((7, 3.9), (7, 6.75), stroke: (dash: "loosely-dashed", thickness: 4pt, paint: blue))
      line((7, 4.938), (10.5, 4.938), stroke: (dash: "loosely-dashed", thickness: 3pt, paint: blue))
      line((11.6, 4.938), (12.5, 4.938), stroke: (dash: "loosely-dashed", thickness: 3pt, paint: blue))
      line((11.6 + 2.4, 4.938), (12.5 + 2.4, 4.938), stroke: (dash: "loosely-dashed", thickness: 3pt, paint: blue))
      line((11.6 + 2.4 + 2.9, 4.938), (12.5 + 2.4 + 2.9, 4.938), stroke: (
        dash: "loosely-dashed",
        thickness: 3pt,
        paint: blue,
      ))

      rect((12.5, 5.65), (14, 4.15))

      let delta-y = 0.1
      translate(y: delta-y)
      line((12.75, 5.3), (13.75, 5.3))
      line((12.75, 5.3), (12.75, 5.1))
      line((13.75, 5.3), (13.75, 5.1))
      line((13.15, 4.5), (12.75, 5.1))
      line((13.15, 4.5), (13.15, 4.3))
      line((13.35, 4.5), (13.75, 5.1))
      line((13.35, 4.5), (13.35, 4.3))
      line((13.15, 4.3), (13.35, 4.3))
      translate(y: -delta-y)

      set-style(stroke: blue.lighten(20%) + 2pt)
      // content((12.5,4.938), anchor: "mid", [#text(size: 20pt)[Signal#linebreak()processing]])

      translate(x: 10.5, y: 4.938)
      scale(0.25)
      scale(x: 4)
      line((0.1, 1.8), (0, 0))
      line((0.1, 1.8), (0.2, -2))
      line((0.3, 0.2), (0.2, -2))
      line((0.3, 0.2), (0.4, -1.4))
      line((0.5, 1.9), (0.4, -1.4))
      line((0.5, 1.9), (0.6, -0.4))
      line((0.7, 1.6), (0.6, -0.4))
      line((0.7, 1.6), (0.8, -1.5))
      line((0.9, 2), (0.8, -1.5))
      line((0.9, 2), (1, 0))
      translate(x: 4.5)
      scale(x: 0.25)
      line((0, 0), (1.5, 0))
      line((1.5, 0), (2, 0))
      bezier((2, 0), (3, 0), (2.6, .5), (2.75, .5))
      line((3, 0), (3.8, 0))
      line((3.8, 0), (4, -.5))
      line((4, -.5), (4.2, 2))
      line((4.2, 2), (4.4, -.7))
      line((4.4, -.7), (4.6, 0))
      line((4.6, 0), (5.3, 0))
      bezier((5.3, 0), (6, 0), (5.6, .7), (5.75, .7))
      line((6, 0), (7, 0))
    }),
    caption: [Test setup info-graphic],
  )<infoA>

  At first, the raw analogue data was processed by a #sym.Delta#sym.Sigma ADC, after which a microcontroller collected the data and sent it to a PC.
  Two different algorithms were executed on the PC (one for HR and one for RR) to estimate the HR and RR.
  This was done afterwards.

  Four different datasets were gathered: a dataset in which no talking was done and the test subject lay in the supine position; a dataset in which a constant "O" sound was made; a dataset in which the "COMMA GETS A CURE" text was read out loud in a normal fashion; and finally, a dataset in which the "COMMA GETS A CURE" text was read in a whispering manner.

  The HR and RR were then estimated for these datasets and compared with a reference signal from a Polar H10 sensor.

]
#let results-content = [
  = Results

  #subpar.grid(
    bland_altman_data(), <bland_altman_data>, hr_combined_altman(),
    <hr_b>, bland_altman_rr_talking(), <hr_c>,
    columns: (1fr, 1fr, 1fr),
    caption: [results plotted against reference values],
    label: <hr_full>,
  )

  The base algorithms for HR and RR both performed quite well, with the HR estimation specifically performing beyond expectations.

  The impact of speech on the estimation was significant.
  In @hr_full, all data sets can be seen.
  All blue-coloured data points represent the base measurement intended to verify the algorithms' accuracy in normal conditions.
  The "O" sound is represented by red, the whispering dataset is represented by orange, and the normal talking is represented by purple.

  Especially the "O" sound had a massive impact on the accuracy of the estimation, with the other datasets showing some decrease in accuracy.

]

#let future-work-content = [
  #grid(
    columns: (82.5%, 2.5%, 15%),
    [
      = Future work

      The results have shown a clear relationship between speech and reduced accuracy.
      Future work with FSR sensors or similar sensors should consider this possible disturbance when developing algorithms or claiming that algorithms are robust.
      Especially since a large portion of society suffers from sleep talking (anywhere from 2.4% to 60.8%).

      There are, however, areas where this research could be improved upon.
      The two most important areas are the test setup and the test subject group.
      The test setup could be improved in hardware by moving away from the breadboard and towards PCBs and enhancing the electronic circuit.
      The second thing to improve is the subject group.
      For this study, only one person was used as a test subject.
      This raises many validity concerns, and future research could significantly improve on this by expanding the test subject group.
    ],
    [],
    [
      = Online repo
      Check out the research paper, code, and data sets online for more details!
      #qr-code("https://github.com/TomVer99/FSR-Research-2025-vj", width: 4cm)
    ],
  )
]


#grid(
  columns: (50%, 50%),
  inset: (top: 20pt, bottom: 10pt, right: 40pt, left: 20pt),
  fill: gray.opacify(-90%),
  gutter: 30pt,
  grid.cell(colspan: 2, stroke: (left: (paint: accent-color, thickness: 5pt)))[#title-content],
  grid.cell(colspan: 2, align: center)[#author-content],
  grid.cell(colspan: 1, stroke: (left: (paint: accent-color, thickness: 5pt)))[#intro-content],
  grid.cell(colspan: 1, stroke: (left: (paint: accent-color, thickness: 5pt)))[#methodology-content],
  grid.cell(colspan: 2, stroke: (left: (paint: accent-color, thickness: 5pt)))[#results-content],
  grid.cell(colspan: 2, stroke: (left: (paint: accent-color, thickness: 5pt)))[#future-work-content],
)
