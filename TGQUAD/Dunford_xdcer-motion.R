###########################################################################
# Dunford_xdcer-motion.R
# Calculate effect of transducer motion. This does not go so far as to 
# do the correction (see Dunford_Motion-Correction.R), but this program
# can be used to compare to Stanton's transducer motion 
# (see Stanton_xdcer-motion.R)
# Reference: Dunford, A.J., 2005, Correcting echo-integration data for
#            transducer motion, Journal of the Acoustical Society of
#            America, 118:2121-2123, doi: 10.1121/1.2005927
# 
# Please e-mail me with any questions or corrections, 
# Mike Jech, michael.jech@noaa.gov
#
# jech
# source("Dunford_xdcer-motion.R")

# start with a clean slate
rm(list = ls())

### parameters
# frequency in Hz
f = 38000
# transducer radius in m
#xdcer.d = 0.332     # 7 deg beam
# to get Dunford's chi of 1.616399, the xdcer diameter needs to be 0.3327
#   at a speed of sound (c) of 1500 m/s
xdcer.d = 0.3327     # 7 deg beam
xdcer.a = xdcer.d/2
# BW is the full-width half-power beamwidth (alpha in Dunford)
BW.deg = 7
BW.rad = BW.deg*pi/180

# speed of sound in m/s
c.water = 1500

# wavelength
lambda = c.water/f

# wave number
k = 2*pi/lambda

# X=ka sin(BW/2)=1.616399
# BW = 2*asin(1.616399*lambda/(2pi*a))
# !!NOTE: If c changes, this value will change!!
#X=1.616399
X = k*xdcer.a*sin(BW.rad/2)
BW.Dunford.deg = (2*asin(X*lambda/(2*pi*xdcer.a)))*180/pi

### approximation of beam pattern, psi
# phi is zenith (polar) angle (opposite to Stanton 1982)
#   for now keep Dunford's notation
# min and max angle in degree
phi.deg.min = 0
phi.deg.max = 10
phi.deg.int = 0.1
# phi vector
phi.deg = seq(phi.deg.min, phi.deg.max, by=phi.deg.int)
# a phi of zero will make the sin(phi) in the denominator bomb
if (phi.deg.min == 0) {
    phi.deg[1] = 0.0001
}
phi.rad = phi.deg*pi/180

# B is beam pattern, x is transmit, r is receive
#B.x = (2*besselJ(k*xdcer.a*sin(phi.rad),1)/(k*xdcer.a*sin(phi.rad)))^2
#B.r = (2*besselJ(k*xdcer.a*sin(phi.rad),1)/(k*xdcer.a*sin(phi.rad)))^2
B.x = 2*besselJ(k*xdcer.a*sin(phi.rad),1)/(k*xdcer.a*sin(phi.rad))
B.r = 2*besselJ(k*xdcer.a*sin(phi.rad),1)/(k*xdcer.a*sin(phi.rad))
B.xr = B.x*B.r
plot(phi.deg, B.x, ylim=c(0,1), main='Bx', type='l', lwd=2, xlab=expression(paste(phi, ' (deg)')), 
     ylab='Transmit Beampattern')
abline(h=0.5)
plot(phi.deg, B.r, ylim=c(0,1), main='Br', type='l', lwd=2, xlab=expression(paste(phi, ' (deg)')),
     ylab='Receive Beampattern')
abline(h=0.5)
plot(phi.deg, B.xr, ylim=c(0,1), main='Bxr', type='l', lwd=2, xlab=expression(paste(phi, ' (deg)')),
     ylab='Transmit/Receive Beampattern')
abline(h=0.5)
# half-power point
B.halfpower = phi.deg[which.min(abs(B.xr-0.5))]

# theta is azimuthal angle (opposite to Stanton 1982)
theta.deg = 0
theta.rad = theta.deg*pi/180


# gamma is angle between MRA of xmit and receive beam
gamma.deg.min = 0
gamma.deg.max = BW.deg
gamma.deg.int = 0.1
gamma.deg = seq(gamma.deg.min, gamma.deg.max, by=gamma.deg.int)
gamma.rad = gamma.deg*pi/180
#x = sin(gamma.rad)/sin(BW.rad/2)

K = numeric(length(gamma.deg))
for(i in 1:length(gamma.deg)) {
  # K is motion correction (kappa in Dunford)
  arg = sin(gamma.rad[i])/sin(BW.rad/2)
  K[i] = 0.17083*arg^5 - 0.39660*arg^4 + 0.53851*arg^3 + 0.13764*arg^2 + 
         0.039645*arg + 1
}

# fd is the "functional form" or functional dependence of K
fd=sin(gamma.rad)/sin(BW.rad/2)

# make a data frame
Dunford.df = data.frame(beamsep=gamma.deg, fd=fd, K=K)

plot(gamma.deg, K, type='l', lwd=2, xlab=expression(paste(gamma, ' (deg)')), ylab=expression(kappa))
plot(fd, K, type='l', lwd=2, ylab=expression(kappa), 
     xlab=expression(paste('sin(', gamma ,')/sin(', alpha, '/2)')))

### make a matrix of range vs angle
# maximum range
#range.max = 2000
range.max = 500
range = seq(1, range.max, by=1)

# angle is the motion angle, could be roll or pitch
# this is 1/2 the total angular motion
#motion.deg.max = 15
motion.deg.max = 10

#angle = seq(0, angle.max, by=1)
# period of motion, seconds
# get from FFT or other analysis
#T.sec = 4
T.sec = 5
# the total travel time for the sound to travel to range.max and back
T.samp = 2*range.max/c.water
t.samp = 2*range/c.water

# angular velocity is the 2*(1/2 total angle)/period in degrees
ang.vel = 4*motion.deg.max/T.sec

# vector of angles representing a sinusoidal motion of period T.samp and angular velocity
motion.deg = sin(ang.vel*t.samp)*motion.deg.max

gamma.deg = (ang.vel/c.water)*range
gamma.rad = gamma.deg*pi/180
arg = sin(gamma.rad)/sin(BW.rad/2)
K = 0.17083*arg^5 - 0.39660*arg^4 + 0.53851*arg^3 + 0.13764*arg^2 + 0.039645*arg + 1
plot(arg, K, type='l', lwd=2, ylab=expression(kappa), 
     xlab=expression(paste('sin(', gamma ,')/sin(', alpha, '/2)')))



### end main
