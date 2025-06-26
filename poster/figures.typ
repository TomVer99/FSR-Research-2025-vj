#import "@preview/cetz:0.3.4": canvas, draw
#import "@preview/cetz-plot:0.1.1": plot
#import "@preview/oxifmt:1.0.0": strfmt
#import "@preview/zap:0.2.0"

#let test_setup_infographic() = {
  figure(
    canvas({
      import draw: *

      set-style(stroke: black + 2pt)

      // scale(1.275)
      scale(0.475)
      let stroke-size = 0.8pt

      // Head
      bezier((3.4, 2.5), (3.6, 3.4), (3.4, 2.8), (3.2, 3), stroke: stroke-size)
      bezier((3.6, 3.4), (3.7, 3.3), (3.7, 3.4), stroke: stroke-size)
      bezier((3.4, 2.5), (3.8, 2), (3.4, 2.1), stroke: stroke-size)
      line((3.8, 2), (4.7, 2), stroke: stroke-size)
      bezier((4.7, 2), (4.9, 2.1), (4.8, 2.1), stroke: stroke-size)
      line((4.9, 2.1), (4.95, 2.2), stroke: stroke-size)
      bezier((5.4, 2.2), (4.35, 2.3), (4.5, 2.2), stroke: stroke-size)
      bezier((3.7, 3.3), (3.6, 2.8), (3.6, 3.3), stroke: stroke-size)
      bezier((3.6, 2.8), (3.85, 2.8), (3.725, 2.6), stroke: stroke-size)
      bezier((3.85, 2.8), (4.1, 2.55), (3.85, 2.55), stroke: stroke-size)
      bezier((4.1, 2.55), (4.4, 2.4), (4, 2.2), (4.2, 2), stroke: stroke-size)
      bezier((3.7, 3.3), (4.1, 3.4), (3.8, 3.4), stroke: stroke-size)
      bezier((4.1, 3.4), (4.4, 3.4), (4.3, 3.5), stroke: stroke-size)
      bezier((4.4, 3.4), (4.6, 3.4), (4.5, 3.5), stroke: stroke-size)
      bezier((4.6, 3.4), (5., 2.8), (5.5, 3.4), stroke: stroke-size)
      line((5.15, 3), (5.35, 2.98), stroke: stroke-size)

      // Thorax fill
      merge-path(fill: orange.transparentize(50%), stroke: none, {
        // bezier((5.6,2), (5.3,2.5), (5.3,2.2))
        // bezier((5.3,2.5), (5.6,3.3), (5.3,3.2))
        bezier((5.6, 3.3), (7.8, 3.5), (6, 3.5), stroke: stroke-size)
        line((7.8, 3.5), (7.8, 2), stroke: stroke-size)
        line((7.8, 2), (5.6, 2), stroke: stroke-size)
      })

      // Body
      bezier((5.6, 2), (5.3, 2.5), (5.3, 2.2), stroke: stroke-size)
      bezier((5.3, 2.5), (5.6, 3.3), (5.3, 3.2), stroke: stroke-size)
      bezier((5.6, 3.3), (7.8, 3.5), (6, 3.5), stroke: stroke-size)
      line((5.6, 2), (18, 2), stroke: stroke-size)
      bezier((6.2, 3), (8, 3.3), (7.4, 2.3), (7.6, 2.3), stroke: stroke-size)
      bezier((7.2, 2.53), (6.8, 2), (6.9, 2.3), stroke: stroke-size)
      bezier((8.2, 2), (8.5, 3.3), (8.5, 2.3), (8.5, 3.2), stroke: stroke-size)
      bezier((8.5, 3.3), (8.8, 3.4), (8.5, 3.4), stroke: stroke-size)
      bezier((8.8, 3.4), (8.5, 3.7), (8.8, 3.6), stroke: stroke-size)
      bezier((8.5, 3.7), (7.8, 3.5), (8.3, 3.8), stroke: stroke-size)
      bezier((7.8, 3.5), (8, 3.3), (8, 3.5), stroke: stroke-size)
      bezier((8.8, 3.4), (10, 3.7), (9.5, 3.4), stroke: stroke-size)
      bezier((10, 3.7), (10, 2), (10.4, 3.5), stroke: stroke-size)

      // Legs
      bezier((10.05, 3.65), (11.75, 5.5), (10.5, 4.5), stroke: stroke-size)
      bezier((11.75, 5.5), (12.5, 5.5), (12.15, 5.8), stroke: stroke-size)
      bezier((12.5, 5.5), (13, 3.25 - 0.1), (13, 5), stroke: stroke-size)
      bezier((11.6, 3.5 - 0.1), (12.2, 4.6), (11.7, 4), stroke: stroke-size)
      bezier((11.9, 4.22), (12, 3.4 - 0.1), (12, 4), stroke: stroke-size)
      bezier((11, 3.65 - 0.1), (12.5, 3.25 - 0.1), (11.5, 3.6 - 0.1), stroke: stroke-size)
      bezier((12.5, 3.25 - 0.1), (14.5, 3 - 0.1), (13.5, 3.25 - 0.1), stroke: stroke-size)
      bezier((14.5, 3 - 0.1), (15.5, 2.7), (14.8, 2.9), stroke: stroke-size)
      bezier((15.5, 2.7), (17, 2.8), (16, 2.7), (16.5, 2.8), stroke: stroke-size)
      line((17, 2.8), (17, 2), stroke: stroke-size)

      // Foot
      bezier((17, 2.7), (18.5, 3.4), (18, 2.9), stroke: stroke-size)
      bezier((18.5, 3.4), (18.5, 3.3), (18.55, 3.4), stroke: stroke-size)
      bezier((18.5, 3.3), (18.3, 2.6), (18.5, 3), stroke: stroke-size)
      bezier((18.3, 2.6), (17.6, 2), (18.1, 2.3), stroke: stroke-size)
      line((17.6, 2), (17.3, 2), stroke: stroke-size)
      line((17, 2.15), (17.3, 2), stroke: stroke-size)


      // Bed
      rect((2, 1), (20, 2), radius: 2pt, stroke: stroke-size)

      // Sensor + box
      rect(
        (6.75, 0.75),
        (7.25, 0.9),
        fill: blue.lighten(20%).transparentize(50%),
        stroke: blue.lighten(20%) + stroke-size,
      )

      // Signal


      translate(y: -6)

      rect(
        (6.75, 2.1),
        (7.25, 3.9),
        fill: blue.lighten(20%).transparentize(50%),
        stroke: blue.lighten(20%) + stroke-size,
      )

      line((5.25, 0), (9.25, 0), stroke: stroke-size)
      line((5.25, 6), (9.25, 6), stroke: stroke-size)

      line((5.25, 0), (4.25, 0), stroke: (dash: "dashed", thickness: 0.8pt))
      line((5.25, 6), (4.25, 6), stroke: (dash: "dashed", thickness: 0.8pt))

      line((10.25, 0), (9.25, 0), stroke: (dash: "dashed", thickness: 0.8pt))
      line((10.25, 6), (9.25, 6), stroke: (dash: "dashed", thickness: 0.8pt))

      line((5.5, 0), (5, 1.5), stroke: (dash: "dashed", thickness: 0.8pt))
      line((5.5, 3), (5, 1.5), stroke: (dash: "dashed", thickness: 0.8pt))
      line((5.5, 3), (5, 4.5), stroke: (dash: "dashed", thickness: 0.8pt))
      line((5.5, 6), (5, 4.5), stroke: (dash: "dashed", thickness: 0.8pt))

      line((3.5 + 5.5, 0), (3.5 + 5, 1.5), stroke: (dash: "dashed", thickness: 0.8pt))
      line((3.5 + 5.5, 3), (3.5 + 5, 1.5), stroke: (dash: "dashed", thickness: 0.8pt))
      line((3.5 + 5.5, 3), (3.5 + 5, 4.5), stroke: (dash: "dashed", thickness: 0.8pt))
      line((3.5 + 5.5, 6), (3.5 + 5, 4.5), stroke: (dash: "dashed", thickness: 0.8pt))


      line((7, 3.9), (7, 6.75), stroke: (dash: "loosely-dashed", thickness: 0.8pt, paint: blue))
      line((7, 4.938), (10.5, 4.938), stroke: (dash: "loosely-dashed", thickness: 0.8pt, paint: blue))
      line((11.6, 4.938), (12.5, 4.938), stroke: (dash: "loosely-dashed", thickness: 0.8pt, paint: blue))
      line((11.6 + 2.4, 4.938), (12.5 + 2.4, 4.938), stroke: (dash: "loosely-dashed", thickness: 0.8pt, paint: blue))
      line((11.6 + 2.4 + 2.9, 4.938), (12.5 + 2.4 + 2.9, 4.938), stroke: (
        dash: "loosely-dashed",
        thickness: 0.8pt,
        paint: blue,
      ))

      rect((12.5, 5.65), (14, 4.15), stroke: stroke-size)

      let delta-y = 0.1
      translate(y: delta-y)
      line((12.75, 5.3), (13.75, 5.3), stroke: stroke-size)
      line((12.75, 5.3), (12.75, 5.1), stroke: stroke-size)
      line((13.75, 5.3), (13.75, 5.1), stroke: stroke-size)
      line((13.15, 4.5), (12.75, 5.1), stroke: stroke-size)
      line((13.15, 4.5), (13.15, 4.3), stroke: stroke-size)
      line((13.35, 4.5), (13.75, 5.1), stroke: stroke-size)
      line((13.35, 4.5), (13.35, 4.3), stroke: stroke-size)
      line((13.15, 4.3), (13.35, 4.3), stroke: stroke-size)
      translate(y: -delta-y)

      set-style(stroke: blue.lighten(20%) + 0.8pt)
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
  )
}

#let elec_diagram() = {
  figure(
    zap.canvas({
      import zap: *

      // FSR
      resistor("r1", (0, 3), (0, 6), variable: true, label: $R_1$)
      // Grounding R2
      resistor("r2", (0, 0), (0, 3), label: $R_2$)
      ground("i1", (0, 0))

      // OpAmp
      opamp("i2", (3, 2.55), variant: "ieee", invert: true, label: $U_1$)

      // Connection Rs to OpAmp
      wire("r1.in", "i2.plus")
      // OpAmp connection to itself and ADC
      wire("i2.out", (4.3, 2.55), (4.3, 1), (1.5, 1), (1.5, 2.1), "i2.minus")
      circle((4.3, 2.55), radius: 0.08, stroke: none, fill: black)
      wire((4.3, 2.55), (5, 2.55))

      // ADC
      rect((5, 2.55 + 0.75), (6.5, 2.55 - 0.75), stroke: 0.8pt)
      content((6.1, 3.75))[$U_2$]
      content((5.4, 2.55))[$"AIN"$]
      wire((5.75, 2.55 - 0.75), (5.75, 0))
      ground("i3", (5.75, 0))
      line((0 + 5.75, 6), (0 + 5.75, 6.35), stroke: 0.8pt)
      line((0 + 5.75, 6.35), (0.2 + 5.75, 6), stroke: 0.8pt)
      line((0 + 5.7555, 6.35), (-0.2 + 5.75, 6), stroke: 0.8pt)
      wire((5.75, 2.55 + 0.75), (5.75, 6))

      // VCC R1
      line((0, 6), (0, 6.35), stroke: 0.8pt)
      line((0, 6.35), (0.2, 6), stroke: 0.8pt)
      line((0, 6.35), (-0.2, 6), stroke: 0.8pt)

      merge-path(fill: white, stroke: none, {
        line((-0.2, 3.35), (0.2, 3.5))
        line((0.2, 3.5 - 0.1), (-0.2, 3.35 - 0.1))
      })
      line((-0.2, 3.35), (0.2, 3.5), stroke: 0.8pt)
      line((-0.2, 3.35 - 0.1), (0.2, 3.5 - 0.1), stroke: 0.8pt)


      // Labels
      // content((0, -1),anchor: "north-west")[
      //   $R_1 = $\
      //   $R_2 = $\
      //   $U_1 = $\
      //   $U_2 = $\
      // ]
    }),
    caption: [Schematic of test device],
  )
}

#let bland_altman_rr() = {
  figure(
    canvas({
      // import "bland_altman_data_rr.typ": data, data_md, data_sd

      let size_x = 5
      let size_y = 5

      let y_min = 0
      let y_max = 0
      let x_min = 0
      let x_max = 0
      let buffer_y = 1000
      let buffer_x = 500

      // for (key, value) in data {
      //   if key < x_min or x_min == 0 {
      //     x_min = key
      //   } else if key > x_max or x_max == 0 {
      //     x_max = key
      //   }
      //   if value < y_min or y_min == 0 {
      //     y_min = value
      //   } else if value > y_max or y_max == 0 {
      //     y_max = value
      //   }
      // }

      plot.plot(
        size: (size_x, size_y),
        legend: "inner-north",
        y-label: "Difference (ms)",
        x-label: "Mean (ms)",
        x-tick-step: 1000,
        y-max: y_max + buffer_y,
        y-min: y_min - buffer_y,
        x-max: x_max + buffer_x,
        x-min: x_min - buffer_x,
        {
          plot.add(((0, 0), (1, 1)), axes: ("x", "y"))
          // plot.add((data), style: (stroke: none), mark: "o")
          // plot.add-hline(
          //   data_md,
          //   style: (stroke: (paint: black, thickness: 1pt, dash: "solid")),
          // )
          // plot.add-hline(
          //   (data_md + 1.96 * data_sd),
          //   (data_md - 1.96 * data_sd),
          //   style: (stroke: (paint: black, thickness: 1pt, dash: "dotted")),
          // )
        },
      )
      // draw.content(
      //   (size_x + 0.3, 3.0),
      //   anchor: "mid-west",
      //   align(center)[Mean:#linebreak()#strfmt("{0:.2}", data_md)],
      // )
      // draw.content(
      //   (size_x, 4.2),
      //   anchor: "mid-west",
      //   align(center)[$+1.96$SD:#linebreak()#{ strfmt("{0:.2}", data_md + 1.96 * data_sd) }],
      // )
      // draw.content(
      //   (size_x, 1.9),
      //   anchor: "mid-west",
      //   align(center)[$-1.96$SD:#linebreak()#{ strfmt("{0:.2}", data_md - 1.96 * data_sd) }],
      // )
    }),
    caption: [RR estimated BPM plotted against Polar H10 reference BPM],
  )
}

#let bland_altman_rr_talking() = {
  figure(
    canvas({
      import "bland_altman_data_rr.typ": data, data_md, data_sd
      import "o_sound_bland_altman_data_rr.typ": data as data_o, data_md as data_md_o, data_sd as data_sd_o
      import "talking_whisper_bland_altman_data_rr.typ": data as data_t, data_md as data_md_t, data_sd as data_sd_t
      import "talking_normal_bland_altman_data_rr.typ": data as data_n, data_md as data_md_n, data_sd as data_sd_n

      let size_x = 12
      let size_y = 8

      let y_min = 0
      let y_max = 0
      let x_min = 0
      let x_max = 0
      let buffer_y = 1000
      let buffer_x = 500

      for (key, value) in data {
        if key < x_min or x_min == 0 {
          x_min = key
        } else if key > x_max or x_max == 0 {
          x_max = key
        }
        if value < y_min or y_min == 0 {
          y_min = value
        } else if value > y_max or y_max == 0 {
          y_max = value
        }
      }

      for (key, value) in data_o {
        if key < x_min or x_min == 0 {
          x_min = key
        } else if key > x_max or x_max == 0 {
          x_max = key
        }
        if value < y_min or y_min == 0 {
          y_min = value
        } else if value > y_max or y_max == 0 {
          y_max = value
        }
      }

      for (key, value) in data_t {
        if key < x_min or x_min == 0 {
          x_min = key
        } else if key > x_max or x_max == 0 {
          x_max = key
        }
        if value < y_min or y_min == 0 {
          y_min = value
        } else if value > y_max or y_max == 0 {
          y_max = value
        }
      }

      for (key, value) in data_n {
        if key < x_min or x_min == 0 {
          x_min = key
        } else if key > x_max or x_max == 0 {
          x_max = key
        }
        if value < y_min or y_min == 0 {
          y_min = value
        } else if value > y_max or y_max == 0 {
          y_max = value
        }
      }

      plot.plot(
        size: (size_x, size_y),
        legend: "inner-north",
        y-label: "Difference (ms)",
        x-label: "Mean (ms)",
        x-tick-step: 2000,
        y-max: y_max + buffer_y,
        y-min: y_min - buffer_y,
        x-max: x_max + buffer_x,
        x-min: x_min - buffer_x,
        {
          plot.add(((0, 0), (1, 1)), axes: ("x", "y"))
          // RR data normal
          plot.add((data), style: (stroke: none), mark: "o")
          plot.add-hline(data_md, style: (stroke: (paint: black, thickness: 1pt, dash: "solid")))
          plot.add-hline((data_md + 1.96 * data_sd), (data_md - 1.96 * data_sd), style: (
            stroke: (paint: black, thickness: 1pt, dash: "dotted"),
          ))
          // RR data O-sound
          plot.add((data_o), style: (stroke: none), mark: "o", mark-style: (stroke: red, fill: red.lighten(65%)))
          plot.add-hline(data_md_o, style: (stroke: (paint: red, thickness: 1pt, dash: "solid")))
          plot.add-hline((data_md_o + 1.96 * data_sd_o), (data_md_o - 1.96 * data_sd_o), style: (
            stroke: (paint: red, thickness: 1pt, dash: "dotted"),
          ))
          // RR data whisper
          plot.add((data_t), style: (stroke: none), mark: "o", mark-style: (stroke: orange, fill: orange.lighten(65%)))
          plot.add-hline(data_md_t, style: (stroke: (paint: orange, thickness: 1pt, dash: "solid")))
          plot.add-hline((data_md_t + 1.96 * data_sd_t), (data_md_t - 1.96 * data_sd_t), style: (
            stroke: (paint: orange, thickness: 1pt, dash: "dotted"),
          ))
          // RR data talking
          plot.add((data_n), style: (stroke: none), mark: "o", mark-style: (stroke: purple, fill: purple.lighten(65%)))
          plot.add-hline(data_md_n, style: (stroke: (paint: purple, thickness: 1pt, dash: "solid")))
          plot.add-hline((data_md_n + 1.96 * data_sd_n), (data_md_n - 1.96 * data_sd_n), style: (
            stroke: (paint: purple, thickness: 1pt, dash: "dotted"),
          ))
        },
      )
    }),
    caption: [RR estimated interval plotted against Polar H10 reference interval for all data sets],
  )
}

#let bland_altman_data() = {
  figure(
    canvas({
      import "bland_altman_data.typ": data, data_md, data_sd

      let size_x = 12
      let size_y = 8

      let y_min = 0
      let y_max = 0
      let x_min = 0
      let x_max = 0
      let buffer = 2

      for (key, value) in data {
        if key < x_min or x_min == 0 {
          x_min = key
        } else if key > x_max or x_max == 0 {
          x_max = key
        }
        if value < y_min or y_min == 0 {
          y_min = value
        } else if value > y_max or y_max == 0 {
          y_max = value
        }
      }

      plot.plot(
        size: (size_x, size_y),
        legend: "inner-north",
        y-label: "Difference (BPM)",
        x-label: "Mean (BPM)",
        x-tick-step: 5,
        y-max: y_max + buffer,
        y-min: y_min - buffer,
        x-max: x_max + buffer,
        x-min: x_min - buffer,
        {
          plot.add((data), style: (stroke: none), mark: "o")
          plot.add-hline(data_md, style: (stroke: (paint: black, thickness: 1pt, dash: "solid")))
          plot.add-hline((data_md + 1.96 * data_sd), (data_md - 1.96 * data_sd), style: (
            stroke: (paint: black, thickness: 1pt, dash: "dotted"),
          ))
        },
      )
      // draw.content(
      //   (size_x + 0.3, 2.8),
      //   anchor: "mid-west",
      //   align(center)[Mean:#linebreak()#strfmt("{0:.2}", data_md)],
      // )
      // draw.content(
      //   (size_x, 4.2),
      //   anchor: "mid-west",
      //   align(center)[$+1.96$SD:#linebreak()#{ strfmt("{0:.2}", data_md + 1.96 * data_sd) }],
      // )
      // draw.content(
      //   (size_x, 1.4),
      //   anchor: "mid-west",
      //   align(center)[$-1.96$SD:#linebreak()#{ strfmt("{0:.2}", data_md - 1.96 * data_sd) }],
      // )
    }),
    caption: [Estimated HR BPM plotted against reference HR BPM],
  )
}

#let bland_altman_o_sound() = {
  figure(
    canvas({
      import "bland_altman_data.typ": data, data_md, data_sd
      import "o_sound_bland_altman_data.typ": data as data_o, data_md as data_md_o, data_sd as data_sd_o

      let size_x = 7
      let size_y = 5

      let y_min = 0
      let y_max = 0
      let x_min = 0
      let x_max = 0
      let buffer = 2

      for (key, value) in data {
        if key < x_min or x_min == 0 {
          x_min = key
        } else if key > x_max or x_max == 0 {
          x_max = key
        }
        if value < y_min or y_min == 0 {
          y_min = value
        } else if value > y_max or y_max == 0 {
          y_max = value
        }
      }

      for (key, value) in data_o {
        if key < x_min or x_min == 0 {
          x_min = key
        } else if key > x_max or x_max == 0 {
          x_max = key
        }
        if value < y_min or y_min == 0 {
          y_min = value
        } else if value > y_max or y_max == 0 {
          y_max = value
        }
      }

      plot.plot(
        size: (size_x, size_y),
        legend: "inner-north",
        y-label: "Difference (BPM)",
        x-label: "Mean (BPM)",
        x-tick-step: 5,
        y-max: y_max + buffer,
        y-min: y_min - buffer,
        x-max: x_max + buffer,
        x-min: x_min - buffer,
        {
          plot.add((data), style: (stroke: none), mark: "o")
          plot.add-hline(data_md, style: (stroke: (paint: blue, thickness: 1pt, dash: "solid")))
          plot.add-hline((data_md + 1.96 * data_sd), (data_md - 1.96 * data_sd), style: (
            stroke: (paint: blue, thickness: 1pt, dash: "dotted"),
          ))

          plot.add((data_o), style: (stroke: none), mark: "o", mark-style: (stroke: red, fill: red.lighten(65%)))
          plot.add-hline(data_md_o, style: (stroke: (paint: red, thickness: 1pt, dash: "solid")))
          plot.add-hline((data_md_o + 1.96 * data_sd_o), (data_md_o - 1.96 * data_sd_o), style: (
            stroke: (paint: red, thickness: 1pt, dash: "dotted"),
          ))
        },
      )
    }),
    caption: [Estimated HR BPM from non-talking (blue) and O-sound data (red)],
  )
}

#let bland_altman_whisper_talking() = {
  figure(
    canvas({
      import "bland_altman_data.typ": data, data_md, data_sd
      import "talking_whisper_bland_altman_data.typ": data as data_o, data_md as data_md_o, data_sd as data_sd_o

      let size_x = 7
      let size_y = 5

      let y_min = 0
      let y_max = 0
      let x_min = 0
      let x_max = 0
      let buffer = 2

      for (key, value) in data {
        if key < x_min or x_min == 0 {
          x_min = key
        } else if key > x_max or x_max == 0 {
          x_max = key
        }
        if value < y_min or y_min == 0 {
          y_min = value
        } else if value > y_max or y_max == 0 {
          y_max = value
        }
      }

      for (key, value) in data_o {
        if key < x_min or x_min == 0 {
          x_min = key
        } else if key > x_max or x_max == 0 {
          x_max = key
        }
        if value < y_min or y_min == 0 {
          y_min = value
        } else if value > y_max or y_max == 0 {
          y_max = value
        }
      }

      plot.plot(
        size: (size_x, size_y),
        legend: "inner-north",
        y-label: "Difference (BPM)",
        x-label: "Mean (BPM)",
        x-tick-step: 5,
        y-max: y_max + buffer,
        y-min: y_min - buffer,
        x-max: x_max + buffer,
        x-min: x_min - buffer,
        {
          plot.add((data), style: (stroke: none), mark: "o")
          plot.add-hline(data_md, style: (stroke: (paint: blue, thickness: 1pt, dash: "solid")))
          plot.add-hline((data_md + 1.96 * data_sd), (data_md - 1.96 * data_sd), style: (
            stroke: (paint: blue, thickness: 1pt, dash: "dotted"),
          ))

          plot.add((data_o), style: (stroke: none), mark: "o", mark-style: (stroke: orange, fill: orange.lighten(65%)))
          plot.add-hline(data_md_o, style: (stroke: (paint: orange, thickness: 1pt, dash: "solid")))
          plot.add-hline((data_md_o + 1.96 * data_sd_o), (data_md_o - 1.96 * data_sd_o), style: (
            stroke: (paint: orange, thickness: 1pt, dash: "dotted"),
          ))
        },
      )
    }),
    caption: [Estimated HR BPM from non-talking (blue) and whisper data (orange)],
  )
}

#let bland_altman_normal_talking() = {
  figure(
    canvas({
      import "bland_altman_data.typ": data, data_md, data_sd
      import "talking_normal_bland_altman_data.typ": data as data_o, data_md as data_md_o, data_sd as data_sd_o

      let size_x = 7
      let size_y = 5

      let y_min = 0
      let y_max = 0
      let x_min = 0
      let x_max = 0
      let buffer = 2

      // for (key, value) in data {
      //   if key < x_min or x_min == 0 {
      //     x_min = key
      //   } else if key > x_max or x_max == 0 {
      //     x_max = key
      //   }
      //   if value < y_min or y_min == 0 {
      //     y_min = value
      //   } else if value > y_max or y_max == 0 {
      //     y_max = value
      //   }
      // }

      // for (key, value) in data_o {
      //   if key < x_min or x_min == 0 {
      //     x_min = key
      //   } else if key > x_max or x_max == 0 {
      //     x_max = key
      //   }
      //   if value < y_min or y_min == 0 {
      //     y_min = value
      //   } else if value > y_max or y_max == 0 {
      //     y_max = value
      //   }
      // }

      plot.plot(
        size: (size_x, size_y),
        legend: "inner-north",
        y-label: "Difference (BPM)",
        x-label: "Mean (BPM)",
        x-tick-step: 5,
        y-max: y_max + buffer,
        y-min: y_min - buffer,
        x-max: x_max + buffer,
        x-min: x_min - buffer,
        {
          plot.add(((0, 0), (1, 1)), axes: ("x", "y"))
          // plot.add((data), style: (stroke: none), mark: "o")
          // plot.add-hline(
          //   data_md,
          //   style: (stroke: (paint: blue, thickness: 1pt, dash: "solid")),
          // )
          // plot.add-hline(
          //   (data_md + 1.96 * data_sd),
          //   (data_md - 1.96 * data_sd),
          //   style: (stroke: (paint: blue, thickness: 1pt, dash: "dotted")),
          // )

          // plot.add((data_o), style: (stroke: none), mark: "o", mark-style: (stroke: purple, fill: purple.lighten(65%)))
          // plot.add-hline(
          //   data_md_o,
          //   style: (stroke: (paint: purple, thickness: 1pt, dash: "solid")),
          // )
          // plot.add-hline(
          //   (data_md_o + 1.96 * data_sd_o),
          //   (data_md_o - 1.96 * data_sd_o),
          //   style: (stroke: (paint: purple, thickness: 1pt, dash: "dotted")),
          // )
        },
      )
    }),
    caption: [Estimated HR BPM from non-talking (blue) and talking data (purple)],
  )
}

// #figure(
//   placement: top,
//   scope: "parent",
//   canvas({
//     import "20_sec_ecg_hr.typ": data
//     plot.plot(
//       size: (16, 3),
//       y-label: [Volt (uV)], // TODO: incorrect unit
//       x-label: "Time (s)",
//       y-grid: true,
//       y-tick-step: 0.5,
//       x-grid: true,
//       x-min: -0.5,
//       x-max: 20.5,
//       y-min: -0.75,
//       y-max: 1.5,
//       {
//         plot.add((data))
//       },
//     )
//   }),
//   caption: [Raw 20 second window of the ECG data],
// )

// #figure(
//   placement: top,
//   scope: "parent",
//   canvas({
//     import "20_sec_ecg_rr.typ": data
//     plot.plot(
//       size: (16, 3),
//       y-label: "Volt (uV)",
//       x-label: "Time (s)",
//       y-grid: true,
//       // y-tick-step: 0.5,
//       x-grid: true,
//       x-min: -0.5,
//       x-max: 20.5,
//       // y-min: -0.75,
//       // y-max: 1.5,
//       {
//         plot.add((data))
//       },
//     )
//   }),
//   caption: [Raw 20 second window of the ECG data],
// )

#let hr_combined_altman() = {
  figure(
    canvas({
      import "bland_altman_data.typ": data, data_md, data_sd
      import "o_sound_bland_altman_data.typ": data as data_o, data_md as data_md_o, data_sd as data_sd_o
      import "talking_whisper_bland_altman_data.typ": data as data_t, data_md as data_md_t, data_sd as data_sd_t
      import "talking_normal_bland_altman_data.typ": data as data_n, data_md as data_md_n, data_sd as data_sd_n

      let size_x = 14
      let size_y = 8

      let y_min = 0
      let y_max = 0
      let x_min = 0
      let x_max = 0
      let buffer_y = 2
      let buffer_x = 2

      for (key, value) in data {
        if key < x_min or x_min == 0 {
          x_min = key
        } else if key > x_max or x_max == 0 {
          x_max = key
        }
        if value < y_min or y_min == 0 {
          y_min = value
        } else if value > y_max or y_max == 0 {
          y_max = value
        }
      }

      for (key, value) in data_o {
        if key < x_min or x_min == 0 {
          x_min = key
        } else if key > x_max or x_max == 0 {
          x_max = key
        }
        if value < y_min or y_min == 0 {
          y_min = value
        } else if value > y_max or y_max == 0 {
          y_max = value
        }
      }

      for (key, value) in data_t {
        if key < x_min or x_min == 0 {
          x_min = key
        } else if key > x_max or x_max == 0 {
          x_max = key
        }
        if value < y_min or y_min == 0 {
          y_min = value
        } else if value > y_max or y_max == 0 {
          y_max = value
        }
      }

      for (key, value) in data_n {
        if key < x_min or x_min == 0 {
          x_min = key
        } else if key > x_max or x_max == 0 {
          x_max = key
        }
        if value < y_min or y_min == 0 {
          y_min = value
        } else if value > y_max or y_max == 0 {
          y_max = value
        }
      }

      plot.plot(
        size: (size_x, size_y),
        legend: "inner-north",
        y-label: "Difference (BPM)",
        x-label: "Mean (BPM)",
        x-tick-step: 5,
        y-max: y_max + buffer_y,
        y-min: y_min - buffer_y,
        x-max: x_max + buffer_x,
        x-min: x_min - buffer_x,
        {
          // RR data normal
          plot.add((data), style: (stroke: none), mark: "o")
          plot.add-hline(data_md, style: (stroke: (paint: black, thickness: 1pt, dash: "solid")))
          plot.add-hline((data_md + 1.96 * data_sd), (data_md - 1.96 * data_sd), style: (
            stroke: (paint: black, thickness: 1pt, dash: "dotted"),
          ))
          // RR data O-sound
          plot.add((data_o), style: (stroke: none), mark: "o", mark-style: (stroke: red, fill: red.lighten(65%)))
          plot.add-hline(data_md_o, style: (stroke: (paint: red, thickness: 1pt, dash: "solid")))
          plot.add-hline((data_md_o + 1.96 * data_sd_o), (data_md_o - 1.96 * data_sd_o), style: (
            stroke: (paint: red, thickness: 1pt, dash: "dotted"),
          ))
          // RR data whisper
          plot.add((data_t), style: (stroke: none), mark: "o", mark-style: (stroke: orange, fill: orange.lighten(65%)))
          plot.add-hline(data_md_t, style: (stroke: (paint: orange, thickness: 1pt, dash: "solid")))
          plot.add-hline((data_md_t + 1.96 * data_sd_t), (data_md_t - 1.96 * data_sd_t), style: (
            stroke: (paint: orange, thickness: 1pt, dash: "dotted"),
          ))
          // RR data talking
          plot.add((data_n), style: (stroke: none), mark: "o", mark-style: (stroke: purple, fill: purple.lighten(65%)))
          plot.add-hline(data_md_n, style: (stroke: (paint: purple, thickness: 1pt, dash: "solid")))
          plot.add-hline((data_md_n + 1.96 * data_sd_n), (data_md_n - 1.96 * data_sd_n), style: (
            stroke: (paint: purple, thickness: 1pt, dash: "dotted"),
          ))
        },
      )
    }),
    caption: [HR estimated BPM plotted against Polar H10 reference BPM for all data sets],
  )
}

