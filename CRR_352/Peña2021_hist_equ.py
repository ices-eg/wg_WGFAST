#Python code included in 
#Peña, M. 2021. Full customization of colour maps for 
#fisheries acoustics: visualizing every target. Fisheries 
#research, 240,105949.



#A.2 Function for histogram equalization
import numpy as np
import matplotlib.pyplot as plt
def histeq(im,n):
# im: 2D dataset
# n: number of colors
#calculate the histogram and cumulative distribution function
    imhist,bins = np.histogram(im.flatten(),n,density=True)
    cdf = imhist.cumsum()
#—-get back to the data range
    cdf = (im.max()-im.min()) * cdf / cdf[-1] +im.min()
#—-find the new values with linear interpolation of the cdf
    im2 = np.interp(im.flatten(),bins[:-1],cdf)
    return np.reshape(im2,im.shape)

#A.3 Using the new function and plotting the new image

im=histeq(I,n)
plt.figure()
plt.imshow(im)