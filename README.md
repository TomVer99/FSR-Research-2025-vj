# FSR-Research-2025-vj

Shield: [![CC BY 4.0][cc-by-shield]][cc-by]

This work is licensed under a
[Creative Commons Attribution 4.0 International License][cc-by].

[![CC BY 4.0][cc-by-image]][cc-by]

[cc-by]: http://creativecommons.org/licenses/by/4.0/
[cc-by-image]: https://i.creativecommons.org/l/by/4.0/88x31.png
[cc-by-shield]: https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg

## Abstract

This study investigates the impact of speech on the accuracy of non-invasive sleep metric measurements using a force-sensitive resistor (FSR) sensor placed under a mattress.
In this work, a test setup using an FSR Model 408 was developed.
Two algorithms for estimating heart rate (HR) and respiratory rate (RR) were developed for this.
Their functionality was verified using a Polar H10 heart rate sensor as a reference.
Three different speech patterns were chosen: normal talking, whispering, and a sustained "O" sound.
Results show that speech, particularly low-frequency sounds, can significantly affect estimation accuracy, with the "O" sound causing the most significant deviations.
The findings highlight the need for further research into mitigating speech-related artefacts in FSR-based sleep monitoring systems.

## Data information

The data files are not named with the most descriptive names; hence, a table of the dataset and an explanation are given below.
If you would like more details about how the data was gathered, please check the Research Paper.

| Name        | Description                                                                                                                                        |
|-------------|----------------------------------------------------------------------------------------------------------------------------------------------------|
| bed_a       | person lying in bed without sound                                                                                                                  |
| bed_b       | person lying in bed without sound (longer time duration than a)                                                                                    |
| bed_cr_filt | attempt at a CR filter, measurement turned out not useful for this research since the implementation of the CR filter and ADC was done incorrectly |
| bed_normal  | normal speech                                                                                                                                      |
| bed_whisper | whispering speech                                                                                                                                  |
| bed_o_sound | "O" sound                                                                                                                                          |
| sitting_a   | test measurement where the FSR sensor was placed under the leg whilst sitting on a hard surface.                                                   |

For each dataset, a `.txt` and `.csv` file are present.
The `.txt` files are from the custom FSR setup, and the `.csv` files are from the Polar H10.
