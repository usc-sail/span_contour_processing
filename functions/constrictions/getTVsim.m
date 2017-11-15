function getTVsim(configStruct)
% GETTV - compute task variables from articulator weights
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
%  - timestamps_file_name_<dataset>: (string) file name with path of 
%      timestamps file name for each data-set <dataset> of the analysis
%  - folders_<dataset>: (cell array) string folder names which belong to 
%      each data-set <dataset> of the analysis
%  - tasks: (cell array) string identifiers for different tasks
%  - FOV: (double) size of field of view in mm^2
%  - Npix: (double) number of pixels per row/column in the imaging plane
%  - framespersec_<dataset>: (double) frame rate of reconstructed real-time
%      magnetic resonance imaging videos in frames per second for each 
%      data-set <dataset> of the analysis
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
%  Path: configStruct.outPath
%  File name: tv_<dataset>.mat
%  Variable name: tv
%  Description: Struct with fields for each subject (field name is subject ID, e.g., 'at1_rep'). The fields are structs with one field for task variables (labeled 'tv'). The 'tv' field is a cell array with four entries: 
%  - cl: constriction location as a string: bilabial, alv, pal, softpal, Lphar, Uphar
%  - cd: constriction degree in pixels
%  - in: X,Y-position of the lower lip, tongue, or velum closest to the constriction location
%  - out: X,Y-position of the upper lip, hard palate, or pharynx closest to the associated in point
% 
% Based on the script of Vikram Ramanarayanan (SPAN-USC, 2009).
% 
% Tanner Sorensen
% Signal Analysis and Interpretation Laboratory
% Feb. 14, 2017

outPath = configStruct.outPath;
manualAnnotationsPath = configStruct.manualAnnotationsPath;
folders = configStruct.folders;

% Load data of contours.
load(fullfile(outPath,'contourdata.mat'))
nDir = length(folders);

% Get factors.
load(fullfile(outPath,'U_gfa.mat'))

% Load constriction locations.
load(fullfile(manualAnnotationsPath,'tvlocs.mat'))

for h = 1:nDir
    participant = folders{h};
    fprintf('Measuring task variables for subject %s\n',participant)
    
    % Get weights and reconstruct xy coordinates.
    U = U_gfa.(participant);
    xy = [contourdata.(participant).X, contourdata.(participant).Y];
    w = xy*U;
    xyHat = w*pinv(U) + repmat(mean(xy),size(xy,1),1);
    nPt = size(xyHat,2)/2;
    nSamples = size(xyHat,1);
    contourdata.(participant).X = xyHat(:,1:nPt);
    contourdata.(participant).Y = xyHat(:,nPt+1:end);
    
    SectionsID = contourdata.(participant).SectionsID;
    cl = fields(tvlocs.(participant));
    files = unique(contourdata.(participant).File);
    nFile = length(files);
    
    D = zeros(100000,length(cl)+1); x1 = D; x2 = D; y1 = D; y2 = D;
    
    k=1;
    
    fprintf('[')
    twentieths = round(linspace(1,nFile,20));
    for i=1:nFile
        if ismember(i,twentieths)
            fprintf('=')
        end
        frame_idx = contourdata.(participant).File == files(i);
        nFrames = sum(frame_idx);
        x = contourdata.(participant).X(frame_idx,:);
        y = contourdata.(participant).Y(frame_idx,:);
        for j=1:nFrames
            % (X,Y)-coordinates of midsagittal contours
            %Xtngepi = x(j,SectionsID==1 | SectionsID==2);
            %Ytngepi = y(j,SectionsID==1 | SectionsID==2);
            Xtngepi = x(j,SectionsID==2);
            Ytngepi = y(j,SectionsID==2);
            Xul = x(j,SectionsID==15);
            Yul = y(j,SectionsID==15);
            Xll = x(j,SectionsID==4);
            Yll = y(j,SectionsID==4);
            Xvelum = x(j,SectionsID==12);
            Yvelum = y(j,SectionsID==12);
            
            [D(k,1),x1(k,1),y1(k,1),x2(k,1),y2(k,1)] = getCD(Xul,Yul,Xll,Yll); % lower lip against upper lip
            for ell=1:length(cl)
                if strcmp(cl{ell},'pharU') % velum against nasopharynx (i.e., 'pharU')
                    sections_match = ismember(SectionsID, tvlocs.(participant).(cl{ell}).aux);
                    nodes_match = sort([tvlocs.(participant).(cl{ell}).start,...
                        tvlocs.(participant).(cl{ell}).stop]);
                    nodes_match = nodes_match(1):nodes_match(2);
                    Xcl = contourdata.(participant).X(j,sections_match);
                    Xcl = Xcl(nodes_match);
                    Ycl = contourdata.(participant).Y(j,sections_match);
                    Ycl = Ycl(nodes_match);
                    [D(k,ell+1),x1(k,ell+1),y1(k,ell+1),x2(k,ell+1),y2(k,ell+1)] = getCD(Xcl,Ycl,Xvelum,Yvelum);
                else % tongue against pharynx or palate
                    sections_match = ismember(SectionsID, tvlocs.(participant).(cl{ell}).aux);
                    nodes_match = sort([tvlocs.(participant).(cl{ell}).start,...
                        tvlocs.(participant).(cl{ell}).stop]);
                    nodes_match = nodes_match(1):nodes_match(2);
                    Xcl = contourdata.(participant).X(j,sections_match);
                    Xcl = Xcl(nodes_match);
                    Ycl = contourdata.(participant).Y(j,sections_match);
                    Ycl = Ycl(nodes_match);
                    [D(k,ell+1),x1(k,ell+1),y1(k,ell+1),x2(k,ell+1),y2(k,ell+1)] = getCD(Xcl,Ycl,Xtngepi,Ytngepi);
                end
            end
            
            k=k+1;
        end
    end
    fprintf(']\n')
    
    D(k:end,:)=[]; x1(k:end,:)=[]; y1(k:end,:)=[]; x2(k:end,:)=[]; y2(k:end,:)=[];
    
    cl = [{'bilabial'}, fields(tvlocs.(participant))'];
    for i=1:size(D,2)
        tv.(participant).tv{i}.cl=cl{i};
        tv.(participant).tv{i}.cd=D(:,i);
        tv.(participant).tv{i}.in=[x1(:,i) y1(:,i)]; 
        tv.(participant).tv{i}.out=[x2(:,i) y2(:,i)];
    end
end

save(fullfile(outPath,'tvsim.mat'),'tv')

end