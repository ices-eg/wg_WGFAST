# WGFAST List of [Open-Source Data and Software Efforts](https://htmlpreview.github.io/?https://github.com/ices-eg/wg_WGFAST/blob/master/Open-Source_Efforts/wgfast_efforts.html)


The ICES Working Group on Fisheries Acoustics, Science and Technology (WGFAST) has compiled a list of efforts from those in the fisheries acoustics community who are developing open-source data formats (e.g., netCDF4 and HDF5) and open-source software (e.g., Matlab, Python, Perl, R) for the acquisition, processing, analysis, and visualization of water-column sonar data. This list is intended to be comprehensive, but it relies on the community to populate it with known efforts.


The list, `WGFAST_open-source_efforts.json`, is in JSON format, so anyone can read it and add new projects. 


## How do we add new projects?  
- For experienced GitHub users, you can edit the .json file (see the next bullets) and submit a pull request. The URL and project will be verified and if confirmed, your project will be added to the list!  
- To add your project, copy the .json file to your local computer. The last "project" is a set of empty objects (name/key-value pairs) that should be used as a template. 
- Copy and paste the lines from the '{' just above "title": "", to the corresponding '}', so that the next person has the tempate to use. You will need to add a comma after the '}' that ends your project to avoid an error. 
- Add the respective information for your project to each name/key-value pair. You can use the other projects as examples of the level of detail to give.  
- For those less experienced with GitHub, after you have edited the .json file, e-mail it to the WGFAST chair, `michael.jech@noaa.gov`, who will add your project to the repository. 

### How it works  
The R script `wgfast_efforts.R` uses the markdown file `wgfast_efforts.Rmd` to create an HTML table, `wgfast_efforts.html`, that is useful for reports and documents. You are free to copy these scripts and use them. The HTML file is generated from the .json file and is not meant to be edited.

### View the list of projects   
To view the list of open-source projects in your web browser click [here](https://htmlpreview.github.io/?https://github.com/ices-eg/wg_WGFAST/blob/master/Open-Source_Efforts/wgfast_efforts.html).


