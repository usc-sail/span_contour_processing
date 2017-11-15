function [X,Y,Xul,Yul,Xll,Yll,Xtongue,Ytongue,Xalv,Yalv,Xpal,Ypal,...
    Xvelum,Yvelum,Xvelar,Yvelar,XpharL,YpharL,XpharU,YpharU] ...
    = vtSeg(contourdata,fileNumber,frameNumber,tvlocs)
% VTSEG - break the contours into subparts
% 
% INPUT:
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
%  Variable name: fileNumber 
%  Size: 1x1
%  Class: double
%  Description: number of the file containing the frame whose contour is to
%  be broken down.
% 
%  Variable name: frameNumber 
%  Size: 1x1
%  Class: double
%  Description: number of the frame whose contour is to be broken down.
% 
% 
% 
% FUNCTION OUTPUT: 
%  X, Y - all coordinates in the (X,Y)-plane
%  Xul, Yul - upper lip coordinates
%  Xll, Yll - lower lip coordinates
%  Xtongue, Ytongue - tongue coordinates
%  Xalv, Yalv - alveolar ridge (coronal place) coordinates
%  Xpal, Ypal - hard palate coordinates
%  Xvelum, Yvelum - velum coordinates
%  Xvelar, Yvelar - velar place coordinates
%  XpharL, YpharL - lower (hypo-)pharynx coordinates
%  XpharU, YpharU - upper (naso-)pharynx coordinates
% 
% SAVED OUTPUT:
%  none
% 
% Tanner Sorensen
% Signal Analysis and Interpretation Laboratory
% Apr. 14, 2017
    
    ii = contourdata.File==fileNumber & contourdata.Frames==frameNumber;
    xy_data = [contourdata.X(ii,:),contourdata.Y(ii,:)];
    X = xy_data(1:length(xy_data)/2);
    Y = xy_data(length(xy_data)/2+1:end);
    
    % Lips
    Xul = X(ismember(contourdata.SectionsID,15));
    Yul = Y(ismember(contourdata.SectionsID,15));
    Xll = X(ismember(contourdata.SectionsID,4));
    Yll = Y(ismember(contourdata.SectionsID,4));
    
    % Tongue
    Xtongue = X(ismember(contourdata.SectionsID,2));
    Ytongue = Y(ismember(contourdata.SectionsID,2));
    
    % Palate
    Xalv = X(ismember(contourdata.SectionsID,11));
    Yalv = Y(ismember(contourdata.SectionsID,11));
    Xpal =  X(ismember(contourdata.SectionsID,11));
    Ypal =  Y(ismember(contourdata.SectionsID,11));
    Xvelum = X(ismember(contourdata.SectionsID,12));
    Yvelum = Y(ismember(contourdata.SectionsID,12));
    Xphar = X(ismember(contourdata.SectionsID,7));
    Yphar = Y(ismember(contourdata.SectionsID,7));
    
    % trim...
    ii = sort([tvlocs.alv.start tvlocs.alv.stop]);
    ii = ii(1):ii(2);
    Xalv = Xalv(ii); 
    Yalv = Yalv(ii);
    
    ii = sort([tvlocs.pal.start tvlocs.pal.stop]);
    ii = ii(1):ii(2);
    Xpal = Xpal(ii);
    Ypal = Ypal(ii);
    
    ii = sort([tvlocs.softpal.start tvlocs.softpal.stop]);
    ii = ii(1):ii(2);
    Xvelar = Xvelum(ii);
    Yvelar = Yvelum(ii);
    
    ii = sort([tvlocs.pharL.start tvlocs.pharL.stop]);
    ii = ii(1):ii(2);
    XpharL = Xphar(ii); 
    YpharL = Yphar(ii);
    
    ii = sort([tvlocs.pharU.start tvlocs.pharU.stop]);
    ii = ii(1):ii(2);
    XpharU = Xphar(ii);
    YpharU = Yphar(ii);
end