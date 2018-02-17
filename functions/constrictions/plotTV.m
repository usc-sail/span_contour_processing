function plotTV(configStruct)
% PLOTTV - plot figure illustrating the task variable measurements
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
%  Variable name: dataset
%  Size: arbitrary
%  Class: char
%  Description: determines which data-set to analyze; picks out the
%  appropriate constants from configStruct.
% 
% FUNCTION OUTPUT: 
%  none
% 
% SAVED OUTPUT: 
%  path: GRAPHICSPATH
%  file name: <subject ID>_tv.png
%  description: an illustration of constriction locations on an example
%  vocal tract contour
% 
% Tanner Sorensen
% Signal Analysis and Interpretation Laboratory
% Feb. 14, 2017

outPath = configStruct.outPath;
manualAnnotationsPath = configStruct.manualAnnotationsPath;
graphicsPath = configStruct.graphicsPath;

% Load contours, weights, and model.
load(fullfile(outPath,'contourdata.mat'))
load(fullfile(outPath,'tv.mat'))
load(fullfile(manualAnnotationsPath,'tvlocs.mat'))
load(fullfile(outPath,'U_gfa.mat'))

% list of subjects
folders = configStruct.folders;
nDir = length(folders);

for h=1:nDir
    participant = folders{h};
    fileNumber = 1;
    frames = unique(contourdata.(participant).Frames(contourdata.(participant).File==fileNumber));
    frameNumber = randi(length(frames),1);
    
    % Get weights and reconstruct xy coordinates.
    U = U_gfa.(participant);
    xy = [contourdata.(participant).X, contourdata.(participant).Y];
    [xy, mu_xy, sigma_xy] = zscore(xy);
    w = xy*U;
    xyHat = w*pinv(U);
    nPt = size(xyHat,2)/2;
    nSamples = size(xyHat,1);
    contourdata.(participant).X = xyHat(:,1:nPt).*(ones(nSamples,1)*sigma_xy(1:nPt)) + ones(nSamples,1)*mu_xy(1:nPt);
    contourdata.(participant).Y = xyHat(:,nPt+1:end).*(ones(nSamples,1)*sigma_xy(nPt+1:end)) + ones(nSamples,1)*mu_xy(nPt+1:end);
    
    X = contourdata.(participant).X(frameNumber,:);
    Y = contourdata.(participant).Y(frameNumber,:);
     
    figID = figure('Color','w');

    % whole vocal tract shape
    plot_from_xy([X, Y],contourdata.(participant).SectionsID,[0.6 0.6 0.6])
    axis tight, hold on

    % constriction location points
    cl = fields(tvlocs.(participant));
    SectionsID = contourdata.(participant).SectionsID;
    for ell=1:length(fields(tvlocs.(participant)))
        
        % plot constriction locations (but not the lips or velopharyngeal
        % port)
        sections_match = ismember(SectionsID, tvlocs.(participant).(cl{ell}).aux);
        nodes_match = sort([tvlocs.(participant).(cl{ell}).start,...
            tvlocs.(participant).(cl{ell}).stop]);
        nodes_match = nodes_match(1):nodes_match(2);
        Xcl = contourdata.(participant).X(frameNumber,sections_match);
        Xcl = Xcl(nodes_match);
        Ycl = contourdata.(participant).Y(frameNumber,sections_match);
        Ycl = Ycl(nodes_match);
        plot(Xcl,Ycl,'-k','LineWidth',2)
        
        % plot the constriction degrees
        Xcl = [tv.(participant).tv{ell+1}.in(frameNumber,1), ...
            tv.(participant).tv{ell+1}.out(frameNumber,1)];
        Ycl = [tv.(participant).tv{ell+1}.in(frameNumber,2), ...
            tv.(participant).tv{ell+1}.out(frameNumber,2)];
        scatter(Xcl,Ycl,50,'k','filled')
        plot(Xcl,Ycl,'-k','LineWidth',2)
        text(Xcl(1)+1,Ycl(1)+1,num2str(ell+1))
    end
    
        %lips
        sections_match = ismember(SectionsID, 4);
        Xll = contourdata.(participant).X(frameNumber,sections_match);
        Yll = contourdata.(participant).Y(frameNumber,sections_match);
        sections_match = ismember(SectionsID, 15);
        Xul = contourdata.(participant).X(frameNumber,sections_match);
        Yul = contourdata.(participant).Y(frameNumber,sections_match);
        plot(Xll,Yll,'-k','LineWidth',2)
        plot(Xul,Yul,'-k','LineWidth',2)
        
        ell=0;
                Xcl = [tv.(participant).tv{ell+1}.in(frameNumber,1), ...
            tv.(participant).tv{ell+1}.out(frameNumber,1)];
        Ycl = [tv.(participant).tv{ell+1}.in(frameNumber,2), ...
            tv.(participant).tv{ell+1}.out(frameNumber,2)];
        scatter(Xcl,Ycl,50,'k','filled')
        plot(Xcl,Ycl,'-k','LineWidth',2)
        text(Xcl(1)+1,Ycl(1)+1,num2str(ell+1))
    
    hold off, axis off
    
    fnam = [participant, '_tv.png'];
    print(fullfile(graphicsPath, fnam),'-dpng')
    close(figID)
end
    
end
