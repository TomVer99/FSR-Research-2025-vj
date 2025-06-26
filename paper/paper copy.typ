#import "@preview/unofficial-fontys-paper-template:0.1.0": fontys-paper
#import "@preview/cetz:0.3.4": canvas, draw
#import "@preview/cetz-plot:0.1.1": plot
#import "@preview/algorithmic:1.0.0"
#import "@preview/oxifmt:1.0.0": strfmt
#import algorithmic: algorithm, algorithm-figure
#import "@preview/subpar:0.2.2"
#import "@preview/glossarium:0.5.6": make-glossary, register-glossary, print-glossary, gls, glspl
#show: make-glossary
#import "terms.typ": entry-list
#register-glossary(entry-list)

#import "./figures.typ": (
  bland_altman_normal_talking,
  bland_altman_whisper_talking,
  bland_altman_o_sound,
  bland_altman_data,
  elec_diagram,
  test_setup_infographic,
  bland_altman_rr,
  bland_altman_rr_talking,
)

#show: fontys-paper.with(
  title: "Impact of speech on non-invasive sleep metric measurements using an FSR sensor placed under a mattress",
  authors: "Tom Verlinde",
  authors-details: "Fontys University of Applied Sciences, Master Applied IT, vj2025",
  keywords: ("FSR", "BCG", "non-invasive", "HR", "RR"),
  abstract: [N/A],
  bibliography-file: bibliography("bib.bib"),
)

= Introduction

Collecting reliable sleep metrics requires people to go to specialised places where current standard methods can be used.

Various studies have recently been performed on measuring heart rate (HR) and respiratory rate (RR) using noninvasive methods.
A subset of these studies has focused on methods that are low-cost and reliable.

This subset specifically has taken an interest in FSR sensors.
FSR sensors are cheap and have favourable characteristics.

However, these studies have only been performed in recent years, and because of that, the test environments that have been set up have been rather ideal.

This study will try to increase the understanding of FSR-based systems by looking into the effects of a common symptom of sleep apnea, snoring.

= Methods

== Hardware

The hardware that was used in this study consisted of the following:
- A @fsr Model 408 from Interlink Electronics, 100mm long @InterlinkElectronics.
- A 24-bit, 2-kSPS, ADS1220 #sym.Delta#sym.Sigma @adc from Texas Instruments @ADS1220datasheetproductinformationandsupport.
- An MCP602 operational amplifier @MCP602.
- Polar H10 heart rate sensor.

The @fsr model 408 was chosen due to its availability, cost, specifications and previous use in related research @Asadov_Ortega_Madrid_Seepold_2023@Haghi_Asadov_Boiko_Ortega_Martínez_Madrid_Seepold_2023.
@fsr sensors from the same brand and lineup were also used in related research @Asadov_Seepold_Madrid_Ortega@Haghi_Madrid_Seepold_2024.

The ADS1220 #sym.Delta#sym.Sigma @adc was chosen because of its accuracy and availability.
Higher rate @adc:pl were considered; however, only signals of maximum roughly 10 Hz were expected, and those @adc:pl offered significantly less resolution at an insignificant reduction in cost.

The MCP602 operational amplifier was chosen because of its availability, low noise characteristic and ability to operate at 3.3 V.

The Polar H10 heart rate sensor was chosen as a reference sensor because of its accessibility and documented accuracy @Vermunicht_Makayed_Meysman_Laukens_Knaepen_Vervoort_De_Bliek_Hens_Van_Craenenbroeck_Desteghe_et_al_2023@Schaffarczyk_Rogers_Reer_Gronwald_2022@Rogers_Schaffarczyk_Gronwald_2022@Martinez_Ruiz_2022@Chattopadhyay_Das_2021.

== Setup

#elec_diagram()<elec_diagram>

From the @fsr, two 22 @awg solid core wires with rudimentary shielding #footnote[Aluminium foil wrapped around the wires, which was soldered to ground via another 22 @awg solid core wire.] were routed to a breadboard over a distance of roughly 60 cm.
On this breadboard, the circuit as shown in @elec_diagram was implemented.
$R_2$ has a value of 10k #sym.Omega.
This was chosen based on the datasheet of the @fsr model 408.

The tests were all performed on a mattress with a filling of "pure virgin"#footnote[Manufacturer's claims.] wool 500 g/m#super[2].
The covering consisted of 100% cotton.
These specifications are the manufacturer's claims and have not been verified.
The mattress's thickness was measured to be roughly 16cm at the edges and an unknown amount in the middle, though it was visibly thicker.
It was then placed on a metal bed frame with a woven wire mattress support.

#test_setup_infographic()<test_setup_infographic>

The @fsr sensor was placed in the middle of the mattress at the height of the thorax, as displayed in @test_setup_infographic.
The @fsr was laid upon a roughly 0.5-centimetre-thick rigid plastic board.
The position was determined based on previous research into the best position for an @fsr to measure @hr and @rr @Asadov_Ortega_Madrid_Seepold_2023.

The @adc was sampled at 175 Hz without any gain. The data was immediately streamed to a PC, where it was stored in a text file.

For all measurements, the subject was instructed to lie still in the supine position on the mattress and to make no uninstructed movements.

== Algorithms

=== Pre-processing

The data was cleaned up and synchronised before any estimation steps were taken for @hr or @rr.
The data cleaning entails culling data points where no person was lying on the bed.
It also meant synchronising the data from the Polar H10 and the recorded @bcg signal in the time domain, and removing any data points that fell out of either data window.

=== @rr estimation

The @rr estimation algorithm is based on an algorithm tested in previous research @Asadov_Ortega_Madrid_Seepold_2023.
It takes a 20-second window for raw @bcg data and filters it using a fifth-order Butterworth bandpass filter configured to [0.1; 0.4] Hz.
Afterwards, it runs a peak detection algorithm and calculates the interval between each peak.
Thus, it calculates the interval between breaths.

=== @hr estimation

The @hr estimation algorithm was based on the same paper as the @rr algorithm was based on @Asadov_Ortega_Madrid_Seepold_2023.

#figure(
  canvas({
    import "./sing_beat_bcg.typ": data as bcg_data
    import "./sing_beat_ecg.typ": data as ecg_data
    plot.plot(
      size: (6, 6),
      y-label: [#text(fill: blue)[Volt (mV)]],
      y2-label: [#text(fill: red)[Volt (#sym.mu\V)]],
      x-label: "Time (s)",
      x-inset: 0.5,
      x-tick-step: 0.33 / 2,
      y-tick-step: 0.5,
      y2-tick-step: 0.2,
      y-inset: 0.25,
      y2-inset: 0.25,
      {
        plot.add(bcg_data, axes: ("x", "y"))
        plot.add(ecg_data, axes: ("x", "y2"))
      },
    )
  }),
  caption: [Raw BCG (blue) and ECG (red) data for a single heartbeat],
)<single_beat>

First, a 20-second window of raw @bcg data is taken, then a fifth-order Butterworth bandpass filter configured to [2.5; 6.0] Hz is applied.
Here, the algorithm differs from the reference.
It was discovered during testing that the test setup was accurate enough to detect a single heartbeat's H, J and L peaks, as seen in @single_beat.

After the bandpass filter, a wavelet decomposition and reconstruction are performed.
This is done using the wavelet biorthogonal 3.9 function with a decomposition level 4.
This was chosen based on previous work @Asadov_Ortega_Madrid_Seepold_2023.

Finally, peak detection is performed on the 20-second time windows.
The detected peak value is then taken as the @bpm value.
This can be done because it expects to detect three peaks per heartbeat.

== Sleep talking

Based on previous research by I. Arnulf #emph[et al.], three methods were devised to measure the impact of sleep talking on the estimation algorithm @Arnulf_Uguccioni_Gay_Baldayrou_Golmard_Gayraud_Devevey_2017.
The first method will be a constant "O" sound.
This is because a significant portion of the generated sound was a "nonverbal utterance", which I interpret to be similar to the "O" sound (#emph[um], #emph[hmm], etc.).
In addition, of the understandable words, "no" was the most common, with an occurrence of 21.4% @Arnulf_Uguccioni_Gay_Baldayrou_Golmard_Gayraud_Devevey_2017.

The second and third methods will be reciting "COMMA GETS A CURE".
"COMMA GETS A CURE" is intended to examine someone's English pronunciation.
To do this, the text is intended to touch on various phonetic contexts @CommaGetsACureIDEA_2011.

Firstly, it will be recited whisperingly to mimic mumbles and whispers.
Then, it will be recited in a normal manner, allowing for an analysis of the impact of normal speech.

// #colbreak()
// #colbreak()

= Results

#let height = 2.0

#subpar.grid(
  placement: top,
  scope: "parent",
  figure(
    placement: top,
    scope: "parent",
    canvas({
      import "20_sec_bcg.typ": data
      plot.plot(
        size: (16, height),
        y-label: "Volt (mV)",
        x-label: "Time (s)",
        y-grid: true,
        y-tick-step: 10,
        x-grid: true,
        x-min: -0.5,
        x-max: 20.5,
        y-min: 2765,
        y-max: 2790,
        {
          plot.add((data))
        },
      )
    }),
    caption: [Raw 20 second window of the BCG data],
  ),
  <bcg_raw>,
  figure(
    placement: top,
    scope: "parent",
    canvas({
      import "20_sec_bcg_hr.typ": data
      plot.plot(
        size: (16, height),
        y-label: "Amplitude",
        x-label: "Time (s)",
        y-grid: true,
        y-tick-step: 1,
        x-grid: true,
        x-min: -0.5,
        x-max: 20.5,
        y-min: 1.5,
        y-max: -1.5,
        {
          plot.add((data))
        },
      )
    }),
    caption: [Raw 20 second window of the filtered BCG data for heartbeat estimation],
  ),
  <bcg_hr_filtered>,
  figure(
    placement: top,
    scope: "parent",
    canvas({
      import "20_sec_bcg_rr.typ": data
      plot.plot(
        size: (16, height),
        y-label: "Amplitude",
        x-label: "Time (s)",
        y-grid: true,
        y-tick-step: 1,
        x-grid: true,
        x-min: -0.5,
        x-max: 20.5,
        y-min: -2.5,
        y-max: 2.5,
        {
          plot.add((data))
        },
      )
    }),
    caption: [Raw 20 second window of the filtered BCG data for respiratory rate estimation],
  ),
  <bcg_rr_filtered>,
  columns: 1fr,
  caption: [Raw BCG data and filtered BCG data for heartbeat and respiratory rate estimation in 20 second windows],
  label: <bcg_full>,
)

An example 20-second window of raw @bcg data can be seen in @bcg_raw.
The data from the @hr and @rr algorithms (pre-peak detection) can be seen in @bcg_hr_filtered and @bcg_rr_filtered, respectively.

#bland_altman_rr()<bland_altman_rr>

On average, the final estimation of the @rr is quite accurate with a mean value of -145.36 ms.
However, the estimated values spread seems quite large with a $1.96"SD"$ of roughly #sym.plus.minus\2650 ms, as illustrated in @bland_altman_rr.

One thing to consider is that the Polar H10's reference signal can be somewhat inaccurate for detecting breaths @Rogers_Schaffarczyk_Gronwald_2022.

For the @hr estimation, the story is quite a bit different, as seen in @bland_altman_data.
It performs pretty well, with a mean value of 0.81 @bpm, a $+1.96"SD"$ of just 7.06 @bpm, and a $-1.96"SD"$ of just -5.44 @bpm.
It does seem to perform slightly better with higher @bpm.

#bland_altman_rr_talking()

#colbreak()
== Sleep Talking

#subpar.grid(
  placement: top,
  scope: "parent",
  bland_altman_data(),
  <bland_altman_data>,
  bland_altman_o_sound(),
  <hr_b>,
  bland_altman_whisper_talking(),
  <hr_c>,
  bland_altman_normal_talking(),
  <hr_d>,
  columns: (1fr, 1fr),
  caption: [A figure composed of two sub figures.],
  label: <hr_full>,
)

The impact of speech turned out to be significant.
In @hr_full, all three measurements' results are plotted against the base estimated @bpm.

The constant "O" sound, as seen in @hr_b, significantly impacted accuracy.
Here, the mean lies at -13.147 @bpm.
With an $1.96"SD"$ of roughly #sym.plus.minus\8 @bpm, the spread is significantly larger than the estimated @bpm without any noise.

The estimations for normal speaking, whispering and normal talking seem much closer to the result without noise, as pictured in @hr_c and @hr_d, respectively.
They both end up with a mean value of roughly #sym.plus.minus\2.5 @bpm on either side of 0, with the normal talking slightly more away from the 0 point, with a value of 2.8 @bpm instead of the -2.3 @bpm the whispering produces.

One significant difference between the two talking estimations is their spread.
Whispering has a spread of only roughly #sym.plus.minus\5 @bpm, wheras talking normally has a spread of #sym.plus.minus\8 @bpm.


= Discussion

The algorithm for @rr estimation seemed to fall short of expectations, with a $1.96"SD"$ of roughly #sym.plus.minus\2650 ms.
However, it cannot be ruled out that the reference signal from the Polar H10 was also inaccurate, as this is a weak aspect of the Polar H10 @Rogers_Schaffarczyk_Gronwald_2022.
This is most definitely an aspect that requires further research.

On the other hand, the algorithm for @hr estimation performed beyond expectations.
This paper drew a lot of inspiration from a paper by A. Asadov #emph[et al.], where their algorithm reached a mean value of $-2.79$ and a $1.96"SD"$ spread of $-19.88$ and $+14.30$ @Asadov_Ortega_Madrid_Seepold_2023.
This could mean that the increase in @adc resolution helped in gaining estimation accuracy, or it could mean that the algorithm was overturned.
It is not unlikely that the algorithm was overturned, as the subject pool consisted of a single person.

The impact of the speech was, as expected, quite significant.
The @hr estimation's accuracy suffered from speech, with the accuracy especially decreasing with low tones ("O" sound dataset).
This does seem to hint at a possible issue for @hr estimation for people who make noise during their sleep.
It could even suggest that people who snore could experience a similar impact on accuracy.

= Conclusion

A possible trend can be seen where the heartbeat estimation gets more accurate with higher heartbeats.
An explanation could be that as the heartbeat rises, the heart needs to work harder, exerting more pressure on the mattress, resulting in clearer peaks.

- Potential timing discrepancy: The POC's device's internal clock may not align with the epoch time step measured on the reference device.

#print-glossary(
  entry-list,
  user-print-gloss: (..args) => [],
)
