#import "@preview/unofficial-fontys-paper-template:0.1.0": fontys-paper
#import "@preview/cetz:0.3.4": canvas, draw
#import "@preview/cetz-plot:0.1.1": plot
#import "@preview/algorithmic:1.0.0"
#import "@preview/oxifmt:1.0.0": strfmt
#import algorithmic: algorithm, algorithm-figure
#import "@preview/subpar:0.2.2"
#import "@preview/glossarium:0.5.6": gls, glspl, make-glossary, print-glossary, register-glossary
#show: make-glossary
#import "terms.typ": entry-list
#register-glossary(entry-list)
#import "@preview/cades:0.3.0": qr-code

#import "./figures.typ": (
  bland_altman_data, bland_altman_normal_talking, bland_altman_o_sound, bland_altman_rr, bland_altman_rr_talking,
  bland_altman_whisper_talking, elec_diagram, hr_combined_altman, test_setup_infographic, hr_combined_altman,
)

#let abstract = [
  This study investigates the impact of speech on the accuracy of non-invasive sleep metric measurements using a force-sensitive resistor (FSR) sensor placed under a mattress.
  In this work, a test setup using an FSR Model 408 was developed.
  Two algorithms for estimating heart rate (HR) and respiratory rate (RR) were developed for this.
  Their functionality was verified using a Polar H10 heart rate sensor as a reference.
  Three different speech patterns were chosen: normal talking, whispering, and a sustained "O" sound.
  Results show that speech, particularly low-frequency sounds, can significantly affect estimation accuracy, with the "O" sound causing the most significant deviations.
  The findings highlight the need for further research into mitigating speech-related artefacts in FSR-based sleep monitoring systems.
]

#show: fontys-paper.with(
  title: "Impact of speech on non-invasive sleep metric measurements using an FSR sensor placed under a mattress",
  authors: "Tom Verlinde",
  authors-details: "Fontys University of Applied Sciences, Master Applied IT, vj2025",
  keywords: ("Speech", "FSR", "BCG", "non-invasive", "HR", "RR"),
  abstract: abstract,
  bibliography-file: bibliography("bib.bib"),
)

= Introduction

Collecting reliable sleep metrics requires people to go to specialised places where current standard methods can be used.
This can cause stress due to unfamiliar environments.
It also has a limitation of time; a patient cannot just be monitored for a week or more without a serious reason.

A way around this is to measure these sleep metrics, like @hr and @rr, at home. // Kijk of deze zin mischien beter kan.
Another problem arises here: when measuring sleep metrics, you want the person not to be stressed or behaving differently from normal.
Research has been done into contactless technologies for measuring sleep metrics to get around this somewhat.
At the moment of writing, over 40 different methods have been created to measure sleep metrics contactless @Boiko_Martínez_Madrid_Seepold_2023@So_Jain_Kanayama_2021@Sato_Yamada_Inagaki_2006.

A subset of those methods uses the @bcg signal to place a sensor under the patient or mattress to measure these sleep metrics.
These methods exploit the changes in pressure the body exerts to measure the necessary sleep metrics.
Two prominent sensors in this group are the @fbg and @fsr sensors @Sadek_Biswas_Abdulrazak_2019@Sadek_Seet_Biswas_Abdulrazak_Mokhtari_2018@García-Limón_Flores-Nuñez_Alvarado-Serrano_Casanella_2024@De_Tommasi_Massaroni_Caponero_Carassiti_Schena_Lo_Presti_2023.

With the @fbg sensors costing anywhere from #sym.dollar\70 to #sym.dollar\450 @OpticalFiberBraggGratingsoeMarketcom@Team, and @fsr sensors costing anywhere from #sym.dollar\9.28 to #sym.dollar\24.18 @InterlinkElectronicsFSR408MembraanDruksensor200mmStripSoldeerlipjes@Industries@TangioTPE508B24, a clear case can be made for the use of @fsr sensors.
This is, of course, assuming they are just as accurate.

#colbreak()

At the moment, both methods are still relatively new.
The research done into the @fsr specifically, has been performed with relatively optimal setups.
The most non-optimal test setup for measuring sleep metrics has been having the test subject lie in different positions @Asadov_Ortega_Madrid_Seepold_2023@Haghi_Asadov_Boiko_Ortega_Martínez_Madrid_Seepold_2023.
A singular study has also been done on the impact of sleep apnea; however, it did not quantify the impact of sleep apnea on the accuracy of sleep metric estimation @Haghi_Madrid_Seepold_2024.
Thus, we do not know if the @fsr and @fbg systems are comparable.

From this, it is clear that there is still much to do to validate the use of @fsr sensors outside of research test setups for collecting sleep metrics such as @hr and @rr.
For example, a large percentage (2.4% to 66%, depending on age and condition) of the population suffers from conditions that impact the way they sleep @AdultssnoringbyagegroupUS2022@Alfonsi_DAtri_Scarpelli_Mangiaruga_De_Gennaro_2019.
A specific condition is sleep talking, of which anywhere from 2.4% to 60.8% suffer from @Alfonsi_DAtri_Scarpelli_Mangiaruga_De_Gennaro_2019.
This impact on @fsr based sleep metric estimation has not yet been quantified in research.

This study will try to increase the understanding of FSR-based systems by looking into the effects of sleep talking.
To research the impact of sleep talking, the effect of normal speech will initially be investigated.
This is to ease the research process and improve the reliability and repeatability of the test setup.
It aims to gain insight into the seriousness of the possible impact of sleep talking.

#colbreak()
= Methods

== Hardware

The hardware that was used in this study consisted of the following:
- A @fsr Model 408 from Interlink Electronics, 100 mm long @InterlinkElectronics.
- A 24-bit, 2-kSPS, ADS1220 #sym.Delta#sym.Sigma @adc from Texas Instruments @ADS1220datasheetproductinformationandsupport.
- An MCP602 operational amplifier @MCP602.
- Polar H10 heart rate sensor.

The @fsr model 408 was chosen due to its availability, cost, specifications and previous use in related research @Asadov_Ortega_Madrid_Seepold_2023@Haghi_Asadov_Boiko_Ortega_Martínez_Madrid_Seepold_2023.
Other @fsr sensors from the same brand and lineup were also used in related research @Asadov_Seepold_Madrid_Ortega@Haghi_Madrid_Seepold_2024.

The ADS1220 #sym.Delta#sym.Sigma @adc was chosen because of its accuracy and availability.
Higher sample rate @adc:pl were considered; however, only signals of a maximum of roughly 10 Hz were expected, and those @adc:pl offered significantly less resolution at an insignificant reduction in cost.

The MCP602 operational amplifier was chosen because of its availability, low noise characteristic and ability to operate at 3.3 V.

The Polar H10 heart rate sensor was chosen as a reference sensor because of its accessibility and documented accuracy @Vermunicht_Makayed_Meysman_Laukens_Knaepen_Vervoort_De_Bliek_Hens_Van_Craenenbroeck_Desteghe_et_al_2023@Schaffarczyk_Rogers_Reer_Gronwald_2022@Rogers_Schaffarczyk_Gronwald_2022@Martinez_Ruiz_2022@Chattopadhyay_Das_2021.

#colbreak()
== Setup

#elec_diagram()<elec_diagram>

From the @fsr, two 22 @awg solid core wires with rudimentary shielding #footnote[Aluminium foil wrapped around the wires, which was soldered to ground via another 22 @awg solid core wire.] were routed to a breadboard over a distance of roughly 60 cm.
On this breadboard, the circuit as shown in @elec_diagram was implemented.
$R_2$ has a value of 10 k#sym.Omega.
This was chosen based on the datasheet of the @fsr model 408.

The tests were all performed on a mattress with a filling of "pure virgin"#footnote[Manufacturer's claims.] wool 500 g/m#super[2].
The covering consisted of 100% cotton.
These specifications are the manufacturer's claims and have not been verified.
The mattress's thickness was measured to be roughly 16 cm at the edges and an unknown amount in the middle, though it was visibly thicker.
It was then placed on a metal bed frame with a woven wire mattress support.

#test_setup_infographic()<test_setup_infographic>

The @fsr sensor was placed in the middle of the mattress at the height of the thorax, as displayed in @test_setup_infographic.
The @fsr was laid upon a roughly 0.5-centimetre-thick rigid plastic board.
The position was determined based on previous research into the best position for an @fsr to measure @hr and @rr @Asadov_Ortega_Madrid_Seepold_2023.

The @adc was sampled at 175 Hz without any gain. The data was immediately streamed to a PC, where it was stored in a text file.

For the base algorithm, about 10 minutes of data was gathered.
For subsequent datasets, at least four minutes of data was gathered, or until the text was finished.
The text was not repeated; it was said out loud only once while gathering data.

The test subject was instructed to lie down on the mattress in a supine position.
They were also instructed not to move or change position during data capture.

If the data capture required sound, they were instructed to constantly make only the required noise until the required amount of data was gathered.

They were instructed to lie down without making any noise if no sound was required.
This included asking questions, coughing, or making other sounds.

If any of the specific data capture requirements were not met (e.g., moving or making noise when not instructed), the data capture would be terminated and restarted.
The data capture would not be saved for possible later use.

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

=== @hr estimation <hr_estimation_ch>

The @hr estimation algorithm was based on the same paper as the @rr algorithm was based on @Asadov_Ortega_Madrid_Seepold_2023.

First, a 20-second window of raw @bcg data is taken, then a fifth-order Butterworth bandpass filter configured to [2.5; 6.0] Hz is applied.
Here, the algorithm differs from the reference.

After the bandpass filter, a wavelet decomposition and reconstruction are performed.
This is done using the wavelet biorthogonal 3.9 function with a decomposition level of 4.
This was chosen based on previous work @Asadov_Ortega_Madrid_Seepold_2023.

Finally, peak detection is performed on the 20-second time windows.
The detected peak value is then taken as the @bpm value.
This can be done because it expects to detect three peaks per heartbeat.

== Speech

Based on previous research by I. Arnulf #emph[et al.], three methods were devised to measure the impact of speech on the estimation algorithm @Arnulf_Uguccioni_Gay_Baldayrou_Golmard_Gayraud_Devevey_2017.
The first method will be a constant "O" sound.
This is because a significant portion of the sound generated during sleep talking was a "nonverbal utterance," which was interpreted to be similar to the "O" sound (#emph[um], #emph[hmm], etc.).
In addition, of the understandable words, "no" was the most common, with an occurrence of 21.4% @Arnulf_Uguccioni_Gay_Baldayrou_Golmard_Gayraud_Devevey_2017.

The second and third methods will be reciting "COMMA GETS A CURE".
"COMMA GETS A CURE" is intended to examine someone's English pronunciation.
To do this, the text is intended to touch on various phonetic contexts @CommaGetsACureIDEA_2011.

Firstly, it will be recited whisperingly to mimic mumbles and whispers.
Then, it will be recited in a normal manner, allowing for an analysis of the impact of normal speech.

= Results

== Peaks

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
        // plot.add(((0, 0), (1, 1)), axes: ("x", "y"))
        // plot.add(((0, 0), (1, 1)), axes: ("x", "y2"))
        plot.add(bcg_data, axes: ("x", "y"))
        plot.add(ecg_data, axes: ("x", "y2"))
      },
    )
  }),
  caption: [Raw BCG (blue) and ECG (red) data for a single heartbeat],
)<single_beat>

In @hr_estimation_ch, it is stated that the algorithm differs from the referenced algorithm.
This is because during testing, it was discovered that the test setup was accurate enough to detect a single heartbeat's H, J, and L peaks, as seen in @single_beat.
This phenomenon was seen across all datasets for their entire runtime.

#colbreak()
== Base algorithm

#let height = 1.8

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
          // plot.add(((0, 0), (1, 1)), axes: ("x", "y"))
          plot.add((data))
        },
      )
    }),
    caption: [Raw 20-second window of the BCG data],
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
          // plot.add(((0, 0), (1, 1)), axes: ("x", "y"))
          plot.add((data))
        },
      )
    }),
    caption: [20-second window of the filtered BCG data for heartbeat estimation],
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
          // plot.add(((0, 0), (1, 1)), axes: ("x", "y"))
          plot.add((data))
        },
      )
    }),
    caption: [20-second window of the filtered BCG data for respiratory rate estimation],
  ),
  <bcg_rr_filtered>,
  columns: 1fr,
  caption: [Raw and filtered BCG data for heartbeat and respiratory rate estimation in 20-second windows],
  label: <bcg_full>,
)


An example 20-second window of raw @bcg data can be seen in @bcg_raw.
The data from the @hr and @rr algorithms (pre-peak detection) can be seen in @bcg_hr_filtered and @bcg_rr_filtered, respectively.

#bland_altman_rr()<bland_altman_rr>

On average, the mean value of the estimation is quite accurate, with a value of 145.36 ms.
However, the estimated values spread seems quite large with a $1.96"SD"$ of roughly #sym.plus.minus\2650 ms, as illustrated in @bland_altman_rr.

#colbreak()

One thing to consider is that the Polar H10's reference signal can be somewhat inaccurate for detecting breaths @Rogers_Schaffarczyk_Gronwald_2022.

// #colbreak()

For the @hr estimation, the story is quite a bit different, as seen in @bland_altman_data.
It performs better compared to the @rr estimation, with a mean value of 0.81 @bpm, a $+1.96"SD"$ of just 7.06 @bpm, and a $-1.96"SD"$ of just -5.44 @bpm.
// It does seem to perform slightly better with higher @bpm.

#colbreak()

== Speech

=== @hr

#subpar.grid(
  placement: top,
  scope: "parent",
  bland_altman_data(), <bland_altman_data>,
  bland_altman_o_sound(), <hr_b>,
  bland_altman_whisper_talking(), <hr_c>,
  bland_altman_normal_talking(), <hr_d>,
  columns: (1fr, 1fr),
  caption: [@hr results plotted against reference values],
  label: <hr_full>,
)

In @hr_full, all three measurements' results are plotted against the base estimated @bpm.

The constant "O" sound, as seen in @hr_b, significantly impacted accuracy.
Here, the mean lies at -13.147 @bpm.
With an $1.96"SD"$ of roughly #sym.plus.minus\8 @bpm, the spread is significantly larger than the estimated @bpm without any noise.

The estimations for normal speaking, whispering and normal talking seem much closer to the result without noise, as pictured in @hr_c and @hr_d, respectively.
They both end up with a mean value of roughly #sym.plus.minus\2.5 @bpm on either side of 0, with the normal talking slightly more away from the 0 point, with a value of 2.8 @bpm instead of the -2.3 @bpm the whispering produces.

One significant difference between the two talking estimations is their spread.
Whispering has a spread of only roughly #sym.plus.minus\5 @bpm, wheras talking normally has a spread of #sym.plus.minus\8 @bpm.

#colbreak()
=== @rr

#bland_altman_rr_talking()<bland_altman_rr_talking>

The impact of speech seemed less on the @rr estimation than the @hr estimation.
Both regular talking tests (whispering and talking normally) seemed to have little impact on the accuracy of the estimated @rr interval, as shown in @bland_altman_rr_talking.

The "O" sound test, on the other hand, significantly affected the accuracy of the estimated @rr interval.
With a mean value of 4152.61 ms, the "O" sound causes a mean value difference of 4007.25 ms.
The spread of the "O" sound test is also quite a bit larger than the other tests, with a $1.96"SD"$ of  roughly #sym.plus.minus\5300 ms instead of  #sym.plus.minus\2650 ms.

= Discussion

== Algorithms & Speech

The algorithm for @rr estimation seemed to fall short of expectations, with a $1.96"SD"$ of roughly #sym.plus.minus\2650 ms.
However, it cannot be ruled out that the reference signal from the Polar H10 was also inaccurate, as this is a weak aspect of the Polar H10 @Rogers_Schaffarczyk_Gronwald_2022.
This is most definitely an aspect that requires further research.

Speech's impact on the @rr estimation was limited, with the only real impact being seen in the "O" sound dataset.
The Polar H10 reference signal also seemed to be impacted during speech; however, the actual impact was not measured or considered during reference calculations.
Assuming the change in accuracy is a valid phenomenon, it is pretty easy to explain, as the "O" sound that was made seemed to contain much lower frequencies than the other two types of sounds.
These frequencies could have encroached on the bandpass filter's range and thus have influenced the estimations.

On the other hand, the algorithm for @hr estimation performed beyond expectations.
This paper drew a lot of inspiration from a paper by A. Asadov #emph[et al.], where their algorithm reached a mean value of $-2.79$ and a $1.96"SD"$ spread of $-19.88$ and $+14.30$ @Asadov_Ortega_Madrid_Seepold_2023.
It was not expected to reach this level of accuracy.
This could mean that the increase in @adc resolution helped gain estimation accuracy or that the algorithm was overturned.
It is not unlikely that the algorithm was overturned, as the subject pool consisted of a single person.

The impact of the speech on the @hr estimation was, as expected, quite significant.
The @hr estimation's accuracy suffered from speech, with the accuracy especially decreasing with low tones ("O" sound dataset).
Both normal speech and whispering also affected the result, but it was less than the "O" sound.
This is most likely similar to why the @rr estimation was more affected by the "O" sound; normal talking (whispering and normal-level talking) probably does not generate enough low frequencies to impact the estimation too much.

One thing to note is that the @db of the speech was not measured during any of the data captures.
A constant volume was attempted, but no measuring device was present to guide the actual volume of speech.
This could very well affect the impact on the accuracy of @rr and/or @hr estimation.

Another thing that was probably not investigated as much as it should have been is the validity of measuring the three peaks per heartbeat.
There seemed to be a correlation in the limited data collected.
The algorithm seemed to gain accuracy when it was assumed that there were three peaks per heartbeat.
However, this algorithm was not tested on a large dataset and was not appropriately compared to previous algorithms.
Further investigation of this detection method is probably a good idea.

In @hr_full, @bland_altman_rr and @bland_altman_rr_talking a weird phenomenon can be spotted.
There seems to some sort of resolution in the data.
Unfortunately there was little time to investigate this phenomenon.
However, the current thesis is that this phenomenon occurs due to the 20-second windows being samples in one second intervals.
If this interval would be changed, this phenomenon should also change in behauviour if this thesis is correct.
Whatever the case is, it should most definatelly be investated further if the algorithm implemented in this paper were to be reused.

== Test setup

The test setup for this paper was not optimal.
It was made on a breadboard with limited knowledge of electrical engineering.
Noise seemed quite prevalent, though mainly at the 50 Hz point.

A couple of potential improvements were identified.
The first is to pass the signal through a CR high-pass filter and then amplify the signal.
The ADS1220 #sym.Delta#sym.Sigma @adc does have a built-in amplifier, so it should not significantly increase part count and circuit complexity.
This would require a symmetrical power supply.

The second improvement could be to switch to a @pcb with @smt components.
This could decrease the distance the analogue signal travels between components, reducing the potential for @emi pickup.
Right now, the test setup's hardware is quite tall and would disrupt the person lying on the bed if placed near the @fsr sensor.
This is because it is currently implemented on a breadboard with @tht components.
If the setup were made into a @pcb, whilst also moving away from @tht and towards @smt, it could address the third improvement identified.

The third improvement would be to place the hardware (board with @adc and operational amplifier) closer to the @fsr sensor.
As described earlier, the @fsr sensor's signal must first travel through 60 cm of 22 @awg wire.
This wire is not shielded by default, and probably negatively impacts the quality of the received signal.
If the circuit were on a @pcb, the distance could be shortened drastically, possibly resulting in better signal quality.

#colbreak()
= Conclusion

Firstly, a base algorithm for estimating @hr and @rr was implemented.
This algorithm performed beyond expectations for detecting the @hr, with the @rr estimation falling short but still usable.

To estimate the impact of sleep talking, three different types of normal speech were chosen to come close to the frequently observed sleep talking types.

As expected, speech negatively impacted the accuracy of the limited dataset collected for this paper, with mostly the "O" sound negatively impacting the estimation of both @hr and @rr.

The test setup functioned well enough for this paper, but further improvements are needed for future research.

Finally, the difference in low-frequency speech was significant and is a reason for further investigation.
This is especially true considering that snoring contains quite a lot of low-frequency energy (which is observed to impact estimation quality the most), and about 24% to 40% of the population snores @Lee_Lee_Wang_Chen_Fang_Huang_Cheng_Li_2016@Communication_2017.

The source code and data sets can be found at the following reference: @Verlinde_Impact_of_speech_2025.

// #grid(
//     columns: (1fr, 1fr),
//     [#qr-code("https://www.youtube.com/watch?v=dQw4w9WgXcQ", width: 2.5cm)],
//     [#text(fill: blue)[#underline[#link("https://www.youtube.com/watch?v=dQw4w9WgXcQ")[Clickable link]]]],
// )

#print-glossary(entry-list, user-print-gloss: (..args) => [])

#hr_combined_altman()
