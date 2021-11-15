# TGQUAD
Software code written in R (R statistical software language, https://www.r-project.org/about.html) for generating graphs and analyses used in the ICES CRR #NNN, Collecting Quality Echosounder Data in Inclement Weather. These R programs/scripts were used to create the graphs and analyses for diagnosing, estimating, and evaluating effects of transducer motion on fisheries acoustic data, primarily collected during surveys, but can be applied to any data on any platform.

[Stanton_xdcer-motion.R](Stanton_xdcer-motion.R) calculates the effect of transducer motion on echo-integration data based on the paper by T. K. Stanton, (1982) Effects of transducer motion on echo-integration techniques, Journal of the Acoustical Society of America, 72: 947-949, doi: 10.1121/1.388175.

[Dunford_xdcer-motion.R](Dunford_xdcer-motion.R) is based on the paper by A. J. Dunford (2005) Correcting echo-integration daa for transducer motion, Journal of the Acoustical Society of America, 118: 2121-2123 (doi: 10.1121/1.2005927), which derives a correction factor based on Stanton's work (essentially the inverse of Stanton's results), that can be applied to echo-integration (e.g., Sv) data. This correction factor is implemented in some data processing software (e.g., Echoview).

[Dunford_Motion-Correction.R](Dunford_Motion-Correction.R) generates diagnostic graphs that can be used to evaluate the effect of transducer motion on acoustic survey data. These diagnostics can be generated for previously-collected data to determine whether to apply the "Dunford" correction, or generated while at sea during a survey to evaluate the effects of vessel motion on in-situ echosounder data and potentially be used to assist with the decision making process as to whether to continue surveying or modify data collection plans.   

[Pena2021_hist_equ.py](Pena2021_hist_equ.py) provides the code for histogram equalization used in Pena, M. (2021), Full customization of color maps for fisheries acoustics: Visualizing every target. Fisheries Research, 240: 105949.