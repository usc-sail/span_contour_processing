% WRAP_MAKE_CONTOUR_DATA - makes a MAT file containing all segmentation 
% results in configStruct.datPath and saving the MAT file at the location 
% configStruct.outPath.
% 
% Asterios Toutios (base on code by Tanner Sorensen)
% University of Southern California
% Nov 15, 2017

addpath(genpath('functions'))

% configure constant parameters of the analysis
config_struct = config;

% verify that the directory containing segmentation results exists
if ~exist(config_struct.track_path,'dir')
    warning(['The directory containing segmentation results does not exist. ',...
        'Create directory\n  %s\nor change the directory name in the file config.m'],...
        config_struct.trackPath)
end

% make directory for outputs, if the directory does not exist
if ~exist(config_struct.out_path,'dir')
    mkdir(config_struct.out_path)
end

% The call to make_contour_data below generates the file contourdata.mat in
% the directory configuStruct.outpath
make_contour_data(config_struct)

% Perform factor analysis of the contours in the file ./mat/contourdata.mat
variant_switch = 'sorensen2018';
get_Ugfa(config_struct,variant_switch)

% measure task variables
get_tv(config_struct,false)

% measure task variables after recon
get_tv(config_struct,true)

% get locally linear map
get_map(config_struct)
