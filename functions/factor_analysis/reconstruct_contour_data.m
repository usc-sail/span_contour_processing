% RECONSTRUCT_CONTOUR_DATA - demo script which shows how to reconstruct the
% frames from the factors.
% 
% Tanner Sorensen
% Signal Analysis and Interpretation Laboratory
% Apr. 14, 2017

outPath = '/Users/toutios/OneDrive - University of Southern California/Code/span_contour_processing/mat';
load(fullfile(outPath,'contourdata.mat'))
load(fullfile(outPath,'U_gfa.mat'))

subj = 'ipa_je_2';
frameNo = 123;

% normalize data
xy = [contourdata.(subj).X, contourdata.(subj).Y];
%[xy,meandata,sigma] = zscore(xy);
%mu = repmat(mean(xy),size(contourdata.(subj).X,1),1);
%xy = xy-mu;
%meandata=ones(size(D,1),1)*mean(D);
%Dnorm=D-meandata;

% get weights
w = xy*U_gfa.(subj);

% % approximate data
% xy_hat = w*pinv(U_gfa.(subj));
% xy_hat = xy_hat(frameNo,:).*sigma + meandata;
% 
% % original data
% xy = xy(frameNo,:).*sigma + meandata;
% 
% % plot for a frame number of your choice
% plot_from_xy(xy_hat,contourdata.(subj).SectionsID,'r'); hold on
% plot_from_xy(xy,contourdata.(subj).SectionsID,'k'); hold off
