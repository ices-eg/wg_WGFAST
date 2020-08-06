# WGFAST List of Open-Source Data and Software Efforts

The ICES Working Group on Fisheries Acoustics, Science and Technology (WGFAST) has compiled a list of efforts from those in the fisheries acoustics community to develop open-source data formats (e.g., netCDF4 and HDF5) and open-source software (e.g., Matlab, Python, Perl, R) for the acquisition, processing, analysis, and visualization of water-column sonar data. This list is intended to be exhaustive, but relies on the community to populate it with known efforts.

The list, WGFAST_open-source_efforts.json, is in JSON format, so that anyone can read it and add new projects. 

***HOW DO WE HAVE NEW PROJECTS ADDED? This is one process, but probably there are better ways. We need to maintain quality control*** To add your project, copy the .json file to your local computer. The last "project" is a set of empty objects (name/key-value pair) that should be used as a template. Copy and paste the lines from the '{' just above "title": "", to the corresponding '}', so that the next user can add their project. You will need to add a comma to your end '}' to avoid an error. Fill out each name/key and value for your project. You can use the other projects as examples of the level of detail. Once complete e-mail the .json file to the WGFAST chair, michael.jech@noaa.gov, who will have it updated. ***this is not an efficient way, but we need to retain quality control and have someone check the validity of the project, URL, etc...*** 

The R script "wgfast_efforts.R" uses the markdown file "wgfast_efforts.Rmd" to create an HTML table (wgfast_efforts.html) that is useful for reports and documents. You are free to copy these scripts and use them.
