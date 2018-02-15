% WRAP_MAKE_CONTOUR_DATA - makes a MAT file containing all segmentation 
% results in configStruct.datPath and saving the MAT file at the location 
% configStruct.outPath.
% 
% Asterios Toutios (base on code by Tanner Sorensen)
% University of Southern California
% Nov 15, 2017

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

% measure task variables
getTV(configStruct)

% measure task variables after recon
getTVsim(configStruct)

% get locally linear map
get_map(configStruct)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
configStruct = config_cg;

% The call to make_contour_data below generates the file 
% ./mat/contourdata.mat
make_contour_data(configStruct)

% Perform factor analysis of the contours in the file ./mat/contourdata.mat
get_Ugfa(configStruct)

% measure task variables
getTV(configStruct)

% measure task variables after recon
getTVsim(configStruct)

% get locally linear map
get_map(configStruct)