% WRAP_MAKE_CONTOUR_DATA - makes a MAT file containing all segmentation 
% results in configStruct.datPath and saving the MAT file at the location 
% configStruct.outPath.
% 
% Tanner Sorensen
% Signal Analysis and Interpretation Laboratory
% Feb. 14, 2017

addpath(genpath('functions'))
% mkdir mat
% mkdir graphics
% mkdir manual_annotations

configStruct = config;

% The call to make_contour_data below generates the file 
% ./mat/contourdata.mat
make_contour_data(configStruct)

% Perform factor analysis of the contours in the file ./mat/contourdata.mat
get_Ugfa(configStruct)

waitfor(tvlocs(configStruct))

% measure task variables
getTV(configStruct)

% plot task variable figure
plotTV(configStruct)

% measure task variables after recon
getTVsim(configStruct)
