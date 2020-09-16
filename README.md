# dynare_aux_tools - Auxiliary tools to supplement my Dynare workflow

Here I am collecting some tools that facilitate my workflow with the DSGE modellinga and estimation software Dynare (https://www.dynare.org/).

dists.jl - Beta and Gamma distribution fitting tool: The functions provided in dists.jl calculate mean and standard deviation of Beta and Gamma distributions with specified parameters, or calculate parameters based on specified mean and standard deviation (method of moments). This is useful for prior specification in Dynare, since one needs to specify distributions based on their family, mean and standard deviation (instead of their parameters). 

DataAc.R - Data acquisiton from Eurostat: This script is a raw model to pull and format data from Eurostat. It is not meant to be used as-is, but rather provides a first step to collect multiple time series to be used in Dynare estimation. 
