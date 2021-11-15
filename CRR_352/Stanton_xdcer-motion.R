###########################################################################
# Stanton_xdcer-motion.R
# calculate effect of transducer motion
# Reference: Stanton, T.K., 1982, Effects of transducer motion on
#            echo-integration techniques, Journal of the Acoustical Society 
#            of America, 72:947-949, doi: 10.1121/1.388175
# 
# Please e-mail me with any questions or corrections, 
# Mike Jech, michael.jech@noaa.gov
#
# jech
# source("Stanton_xdcer-motion.R")

# start with a clean slate
rm(list = ls())

###
# various parameters not used in this program
#SIE = (1/6)*A0*(10^(TS/10))*tau*ndens*(r2^3-r1^3)*psi
# system gains
#A0 = 1
# pulse duration in ms
#tau = 1.024
# conver to sec
#tau = tau/1000
# number density of targets
#ndens = 1
# range bounds
#r1 = 99
#r2 = 100

### parameters used in this program
# frequency in Hz
f = 38000
# transducer diameter in m
# this should be the Simrad ES38B
xdcer.d = 0.332      # 7 deg beam
#xdcer.d = 0.2324    # 10 deg beam
#xdcer.d = 0.1162    # 20 deg beam
# transducer radius in m
xdcer.a = xdcer.d/2
# full angular beam width in degrees
BW.deg = 7
# speed of sound in m/s
c = 1460
# wavelength
lambda = c/f
# wave number
k = 2*pi/lambda

### approxmation of beam pattern, B
# min and max angle in degree
# theta is polar angle
theta.deg.min = 0
theta.deg.max = 90
theta.deg.int = 0.1
# theta vector
# degrees
theta.deg = seq(theta.deg.min, theta.deg.max, by=theta.deg.int)
theta.deg[which(theta.deg == 0)] = 0.0001
# radians
theta.rad = theta.deg*pi/180
# x is transmit
B.x = ((2*besselJ(k*xdcer.a*sin(theta.rad),1))/(k*xdcer.a*sin(theta.rad)))^2
# r is receive
B.r = ((2*besselJ(k*xdcer.a*sin(theta.rad),1))/(k*xdcer.a*sin(theta.rad)))^2
plot(theta.deg, B.x, ylim=c(0,1), type='l', lwd=2)
abline(h=0.5)
plot(theta.deg, 10*log10(B.x), type='l', lwd=2)
abline(h=-3)
# half-power point
B.halfpower = theta.deg[which.min(abs(B.x-0.5))]

# theta0 is the angle of the transducer in degrees
#theta0 = 4
theta0.deg.min = 0
theta0.deg.max = BW.deg
theta0.deg.int = 0.1
theta0.deg = seq(theta0.deg.min, theta0.deg.max, by=theta0.deg.int)
theta0.deg[which(theta0.deg == 0)] = 0.0001
theta0.rad = theta0.deg*pi/180
# phi is azimuthal angle in degrees
phi.deg = 0
phi.rad = phi.deg*pi/180

psiD = numeric(length(theta0.deg))
for(i in 1:length(theta0.deg)) {
  arg = sin(theta0.rad[i])*sin(theta.rad)*cos(phi.rad)+
        cos(theta0.rad[i])*cos(theta.rad)
  arg[which(arg >= 1)] = 0.999999999
  gamma.t = acos(arg)
  arg = -1*sin(theta0.rad[i])*sin(theta.rad)*cos(phi.rad)+
        cos(theta0.rad[i])*cos(theta.rad)
  arg[which(arg >= 1)] = 0.999999999
  gamma.r = acos(arg)
  #cat("i: ", i, gamma.t, gamma.r, '\n')
  gamma.t[which(gamma.t == 0)] = 0.0001
  gamma.r[which(gamma.r == 0)] = 0.0001
  B.x = ((2*besselJ(k*xdcer.a*sin(gamma.t),1))/(k*xdcer.a*sin(gamma.t)))^2
  B.r = ((2*besselJ(k*xdcer.a*sin(gamma.r),1))/(k*xdcer.a*sin(gamma.r)))^2
  psiD[i] = sum(B.x*B.r, na.rm=TRUE)*theta.deg.int
}
plot(2*theta0.deg, psiD/max(psiD), ylim=c(0,1), ylab='Normalized Directivity Integral',
     xlim=c(0,BW.deg), xlab='Beam Separation (deg)', type='l', lwd=2)
plot(2*theta0.deg, max(psiD)/psiD, ylim=c(0,6), ylab='Dunford Correction',
     xlim=c(0,BW.deg), xlab='Beam Separation (deg)', type='l', lwd=2)


# make a data frame
xdcermotion.df = data.frame(beamsep=2*theta0.deg, psiD.norm=psiD/max(psiD), Dunford.K=max(psiD)/psiD)


### end main
