function configStruct = config
% CONFIG - set constants and parameters of the analysis
% 
% INPUT
%  none
% 
% FUNCTION OUTPUT:
%  Variable name: configStruct
%  Size: 1x1
%  Class: struct
%  Description: Fields correspond to constants and hyperparameters. 
%  Fields: 
%  - outPath: (string) path for saving MATLAB output
%  - aviPath: (string) path to the AVI files
%  - graphicsPath: (string) path to MATALB graphical output
%  - trackPath: (string) path to segmentation results
%  - manualAnnotationsPath: (string) path to manual annotations
%  - timestamps_file_name: (string) file name with path of timestamps file 
%      name
%  - folders: (cell array) string folder names
%  - tasks: (cell array) string identifiers for different tasks
%  - FOV: (double) size of field of view in mm^2
%  - Npix: (double) number of pixels per row/column in the imaging plane
%  - framespersec: (double) frame rate of reconstructed real-time
%      magnetic resonance imaging videos in frames per second
%  - ncl: (double array) entries are (i) the number of constriction 
%      locations at the hard and soft palate and (ii) the number of 
%      constriction locations at the hypopharynx (not including the 
%      nasopharynx).
%  - verbose: controls non-essential graphical and text output
% 
% SAVED OUTPUT: 
%  none
% 
% EXAMPLE USAGE: 
%  >> configStruct = config;
% 
% Asterios Toutios (based on code by Tanner Sorensen)
% University of Southern California
% Nov 15, 2017

% paths
outPath = '/Users/toutios/OneDrive - University of Southern California/Experiments/2017_JE_Forward_Map/je/';
graphicsPath = outPath;
manualAnnotationsPath = outPath;
timestamps_file_name =[outPath,'timestamps_rep1.xlsx'];
aviPath = '/Users/toutios/OneDrive - University of Southern California/Experiments/2017_JE_Forward_Map/je/avi/';
trackPath = '/Users/toutios/OneDrive - University of Southern California/Experiments/2017_JE_Forward_Map/je/track/';

%manualAnnotationsPath = '/Users/toutios/OneDrive - University of Southern California/Code/span_contour_processing/manual_annotations';

% timestamps file name
%timestamps_file_name = '/Users/toutios/OneDrive - University of Southern California/Code/span_contour_processing/manual_annotations/timestamps_rep1.xlsx';

% array constants
%folders = {'je'};

% fixed parameters
FOV = 200; % 200 mm^2 field of view 
Npix = 84; % 68^2 total pixels
%spatRes = FOV/Npix; % spatial resolution
framespersec = 1/(2*0.006004);
ncl = [3 1];

% control printed output
verbose = false;

% make the struct object
configStruct = struct('outPath',outPath,'aviPath',aviPath,...
    'graphicsPath',graphicsPath,'trackPath',trackPath,...
    'timestamps_file_name',timestamps_file_name,...
    'manualAnnotationsPath',manualAnnotationsPath,...
    'FOV',FOV,'Npix',Npix,...%'spatRes',spatRes,...
    'framespersec',framespersec,...
    'ncl',ncl,'verbose',verbose);

end