function make_contour_data(configStruct)
% MAKE_CONTOUR_DATA - make all the track files in configStruct.pathIn into
% a structured array CONTOURDATA saved to file CONTOURDATA_ORIGINAL.mat in
% configStruct.pathOut. configStruct.pathIn is the parent of the
% directories whose names are in the configStruct.folders cell array.
%
% INPUT:
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
%  - timestamps_file_name: (string) file name with path of
%      timestamps file name
%  - folders: (cell array) string folder names
%  - tasks: (cell array) string identifiers for different tasks
%  - FOV: (double) size of field of view in mm^2
%  - Npix: (double) number of pixels per row/column in the imaging plane
%  - framespersec: (double) frame rate of reconstructed real-time magnetic
%      resonance imaging videos in frames per second
%  - ncl: (double array) entries are (i) the number of constriction
%      locations at the hard and soft palate and (ii) the number of
%      constriction locations at the hypopharynx (not including the
%      nasopharynx).
%  - f: (double) hyperparameter which determines the percent of data used
%      in locally weighted linear regression estimator of the jacobian;
%      multiply f by 100 to obtain the percentage
%  - verbose: controls non-essential graphical and text output
%
% FUNCTION OUTPUT:
%  none
%
% SAVED OUTPUT:
%  Path: configStruct.pathOut
%  File name: contourdata.mat
%  Variable name: contourdata
%  Size: 1x1
%  Class: struct
%  Description: Struct with fields for each subject (field name is subject
%    ID, e.g., 'at1_rep'). The fields are structs with the following
%    fields.
%  Fields:
%  - X: X-coordinates of tissue-air boundaries in columns and time-samples
%      in rows
%  - Y: Y-coordinates of tissue-air boundaries in columns and time-samples
%      in rows
%  - File: file ID for each time-sample, note that this indexes the cell
%      array of string file names in fl
%  - fl: cell array of string file names indexed by the entries of File
%  - SectionsID: array of numeric IDs for X- and Y-coordinates in the
%      columns of the variables in fields X, Y; the correspondences are as
%      follows: 01 Epiglottis; 02 Tongue; 03 Incisor; 04 Lower Lip; 05 Jaw;
%      06 Trachea; 07 Pharynx; 08 Upper Bound; 09 Left Bound; 10 Low Bound;
%      11 Palate; 12 Velum; 13 Nasal Cavity; 14 Nose; 15 Upper Lip
%  - Frames: frame number; 1 is first segmented video frame
%  - VideoFrames: frame number; 1 is first frame of avi video file
%
% Tanner Sorensen
% Signal Analysis and Interpretation Laboratory
% Feb. 14, 2017

pathIn = configStruct.trackPath;
pathOut = configStruct.outPath;

fprintf('Making contourdata\n')
fileFormat = '*.mat';  % file name pattern

fileList = dir(fullfile(pathIn,fileFormat));
fileList = {fileList.name};
nFile = length(fileList);

ell=1;
fprintf('[')
twentieths = round(linspace(1,nFile,20));
for i=1:nFile
    if ismember(i,twentieths)
        fprintf('=')
    end
    
    file = load(fullfile(pathIn,fileList{i}));
    nFrame = length(file.trackdata);
    
    for j=1:nFrame
        
        segment = file.trackdata{j}.contours.segment;
        
        segmentStart = 0;
        sectionsID = [];
        y = [];
        for k=1:(size(segment,2)-1)
            sectionsID   = cat(1,sectionsID,segmentStart+segment{k}.i);
            segmentStart = segmentStart+max(segment{k}.i);
            v            = segment{k}.v;
            y            = cat(1,y,[v(:,1),v(:,2)]);
        end
        
        if i==1 && j==1
            lenInit = 100000;
            frames = zeros(lenInit,1);
            videoFrames = zeros(lenInit,1);
            files = zeros(lenInit,1);
            X=NaN(lenInit,size(y,1));
            Y=NaN(lenInit,size(y,1));
        else
            X(ell,:) = y(:,1)';
            Y(ell,:) = y(:,2)';
            frames(ell) = j;
            videoFrames(ell) = file.trackdata{j}.frameNo;
            files(ell) = i;
        end
        
        ell=ell+1;
    end
end
fprintf(']\n')

ii=isnan(X(:,1));
X(ii,:)=[];
Y(ii,:)=[];
files(ii)=[];
frames(ii)=[];
videoFrames(ii)=[];
X(:,sectionsID==11) = repmat(mean(X(:,sectionsID==11),1),length(files),1);
Y(:,sectionsID==11) = repmat(mean(Y(:,sectionsID==11),1),length(files),1);

contourdata = struct('X',X,'Y',Y,...
    'File',files,'fl',{fileList},'SectionsID',sectionsID','Frames',frames,'VideoFrames',videoFrames);

save(fullfile(pathOut,'contourdata.mat'),'contourdata')

end