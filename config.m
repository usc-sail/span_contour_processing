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
out_path = '/home/tsorense/spring2018/ars_build_model/mat';
track_path = '/home/tsorense/spring2018/segmentation_results/ac2_var/track_files';

% spatial parameters
fov = 200; % 200 mm^2 field of view 
n_pix = 84; % 68^2 total pixels 
           % in-plane spatial resolution is FOV/Npix

% temporal parameters
tr_per_image = 2;
tr = 0.006004;
frames_per_sec = 1/(tr_per_image*tr);

% % number of constriction locations
% ncl = [3 1];

% control printed output
% verbose = false;

% make the struct object
configStruct = struct('out_path',out_path,...
    'track_path',track_path,...
    'fov',fov,'n_pix',n_pix,...
    'frames_per_sec',frames_per_sec);

end