###########################################################################
# Generate graphics of the Dunford correction
# Input transducer beam width, maximum sampling range, and angular motion 
# of the vessel. Create a 2-dimensional array of correction as a function 
# of range and motion. Plot as a contoured graph
#
# Reference: Dunford, A.J., 2005, Correcting echo-integration data for
#            transducer motion, Journal of the Acoustical Society of
#            America, 118:2121-2123, doi: 10.1121/1.2005927
#
# Please e-mail me with any questions or corrections, 
# Mike Jech, michael.jech@noaa.gov
#
# jech
# source("Dunford_Motion-Correction.R")

# start with a clean slate
rm(list = ls())

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# parameters to modify
### environmental variables
# speed of sound in water (m sec^-1)
c.water = 1500

### transducer variables
# BW is the full-width half-power beamwidth (alpha in Dunford)
BW.deg = 11
BW.rad = BW.deg*pi/180

### create a matrix of range vs angle
# maximum range
range.max = 1500
#range.max = 50
range = seq(1, range.max, by=1)

### angular motion of the vessel
# angle is the angle of motion; could be roll or pitch or combination of both
# this is the maximum angular deviation recorded by the motion sensor, i.e., 1/2 the total angular width of the motion
# or 1/4 the total angular motion in one period T.sec 
motion.deg.max = 5

# period of motion, seconds
# get from FFT or other analysis
T.sec = 2
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# angular velocity is the 4*(1/2 max angle)/T.sec (deg sec^-1)
ang.vel = 4*motion.deg.max/T.sec

# the total travel time in seconds for the sound to travel to range.max and back
T.samp = 2*range.max/c.water
t.samp = 2*range/c.water       # a vector

# vector of angles representing a sinusoidal motion of period T.samp and angular velocity
gamma.deg = sin(ang.vel*t.samp*2*pi/(4*motion.deg.max))*motion.deg.max
gamma.rad = abs(gamma.deg)*pi/180
plot(t.samp, gamma.deg, type='l', ylab='Motion (deg)', xlab='time (sec)')
plot(range, gamma.deg, type='l', ylab='Motion (deg)', xlab='range (m)')

### Dunford correction
arg = sin(gamma.rad)/sin(BW.rad/2)
K = 0.17083*arg^5 - 0.39660*arg^4 + 0.53851*arg^3 + 0.13764*arg^2 + 0.039645*arg + 1
plot(K, range, ylim=c(range.max, 0), xlab='Dunford correction', ylab='range (m)', type='l')
plot(10*log10(K), range, ylim=c(range.max, 0), xlab='10*log10(Dunford correction)', ylab='range (m)', type='l')

# sequence through the anglular motion for the plot
motion.vect = seq(1, motion.deg.max, by=0.5)

# make a matrix with row = range and col = anglular motion
K.mat = matrix(0, nrow=length(motion.vect), ncol=length(range))

i = 1
for (motion.deg.max in motion.vect) {
  ang.vel = 4*motion.deg.max/T.sec
  gamma.deg = sin(ang.vel*t.samp*2*pi/(4*motion.deg.max))*motion.deg.max
  gamma.rad = abs(gamma.deg)*pi/180
  arg = sin(gamma.rad)/sin(BW.rad/2)
  K.mat[i,] = 0.17083*arg^5 - 0.39660*arg^4 + 0.53851*arg^3 + 0.13764*arg^2 + 0.039645*arg + 1
  i = i+1
}

opar = par()
par(mar = c(5.1,5.0,4.1,0.5))

plotdB = 'y'
if (plotdB == 'n') {
  # set contour levels using maximum of K.mat
  K.max = ceiling(max(K.mat))
  #K.max = max(K.mat)
  # 10 intervals
  #Klevels = seq(0, K.max, by=K.max/10)
  Klevels = seq(1, 1.4, by=1/20)
  lab.vect = as.character(round(Klevels,2))
  # plot the 2D array
  filled.contour(x=motion.vect, y=range, z=K.mat, ylim=c(range.max, 0), ylab='range (m)', 
                 xlab='Max. motion angle (deg)', col=cm.colors(length(Klevels)),
                 main=paste('Motion Period=', T.sec, 'sec:', 'dB'), levels=Klevels)
  # plot the contours
  contour(x=motion.vect, y=range, z=K.mat, ylim=c(range.max,0), lwd=2, labcex=1, method='edge')
  # plot 2D array with contours overlay
  filled.contour(x=motion.vect, y=range, z=K.mat, ylim=c(range.max, 0), ylab='range (m)', 
                 xlab='Max. motion angle (deg)', cex.lab=1.5, col=cm.colors(length(Klevels)),
                 main=paste('Motion Period=', T.sec, 'sec:', 'linear'), levels=Klevels,
                 plot.axes = {
                   axis(1, cex.axis=1.25)
                   axis(2, cex.axis=1.25) 
                   contour(x=motion.vect, y=range, z=K.mat, ylim=c(range.max,0), lwd=2, labcex=1.5, add=TRUE,
                           levels=Klevels, method='edge', labels=lab.vect)
                 })
}

if (plotdB == 'y') {
  # convert correction to dB
  K.mat.dB = 10*log10(K.mat)
  K.max.dB = ceiling(max(K.mat.dB))
  #+++++++++++++++++++++++++++++++++++++++++++++
  # these lines need to be modified depending on scale
  Klevels = seq(0, K.max.dB, by=K.max.dB/10)
  lab.vect = as.character(round(Klevels,2))
  #Klevels = seq(0, 0.02, by=0.002)
  #lab.vect = as.character(round(Klevels,3))
  #+++++++++++++++++++++++++++++++++++++++++++++
  filled.contour(x=motion.vect, y=range, z=K.mat.dB, ylim=c(range.max, 0), ylab='range (m)', 
                 xlab='Max. motion angle (deg)', cex.lab=1.5, col=cm.colors(length(Klevels)),
                 main=paste('Motion Period=', T.sec, 'sec:', 'dB'), levels=Klevels,
                 plot.axes = {
                   axis(1, cex.axis=1.25)
                   axis(2, cex.axis=1.25) 
                   contour(x=motion.vect, y=range, z=K.mat.dB, ylim=c(range.max,0), lwd=2, labcex=1.5, add=TRUE,
                           levels=Klevels, method='edge', labels=lab.vect)
                 })
}


### end main
