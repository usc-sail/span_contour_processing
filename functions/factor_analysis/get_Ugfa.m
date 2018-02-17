function get_Ugfa(configStruct,varargin)
% GET_UGFA - extract factors of vocal tract shape the contours in the file
% contour_data.mat
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
%  Path: configStruct.pathOut
%  File name: U_gfa_<dataset>.mat
%  Variable name: U_gfa 
%  Size: 1x1
%  Class: struct
%  Description: Struct with fields for each subject (field name is subject 
%    ID, e.g., 'at1_rep'). The fields are 400x8 matrices of type double.
%    The columns correspond to factors and the rows correspond to 
%    coordinates of the factors on the (X,Y)-plane. 
%    - Column 1 - jaw factor
%    - Columns 2-5 - tongue factors
%    - Column 6-7 - lip factors
%    - Column 8 - velum factor
% 
% Asterios Toutios (based on code by Tanner Sorensen)
% University of Southern California
% Nov 15, 2017

if nargin<2
    variant_switch = 'toutios2015factor';
elseif nargin==2
    variant_switch = varargin{1};
else
    warning(['Function get_Ugfa.m was called with %d input arguments,' ...
        ' but requires 1 (optionally 2)'],nargin)
end

load(fullfile(configStruct.out_path,'contour_data.mat'))

% warning('off','stats:pca:ColRankDefX')
% warning('off','MATLAB:hg:AutoSoftwareOpenGL')

disp('Performing factor analysis.')

d = size(contour_data.X,2);
    
U_gfa=zeros(2*d,10);

U_jaw = get_Ujaw(contour_data,variant_switch);
U_gfa(:,1)=U_jaw(:,1);

U_tng = get_Utng(contour_data,U_jaw(:,1),variant_switch);
U_gfa(:,2:5)=U_tng(:,1:4);

U_lip = get_Ulip(contour_data,U_jaw(:,1),variant_switch);
U_gfa(:,6:7)=U_lip(:,1:2);

U_vel = get_Uvel(contour_data,U_jaw(:,1),variant_switch);
U_gfa(:,8)=U_vel(:,1);

U_lar = get_Ular(contour_data,U_jaw(:,1),variant_switch);
U_gfa(:,9:10)=U_lar(:,1:2);

%U_head = get_Uhead(contour_data);
%U_gfa(:,11:12)=U_head(:,1:2);


% warning('on','stats:pca:ColRankDefX')
% warning('on','MATLAB:hg:AutoSoftwareOpenGL')

D = [contour_data.X,contour_data.Y];
mean_data=ones(size(D,1),1)*mean(D);
Dnorm=D-mean_data;
if strcmp(variant_switch,'toutios2015factor')
    weights = Dnorm*U_gfa;
else
    weights = Dnorm*pinv(U_gfa');
end
mean_vt_shape = mean(D);
contour_data.mean_vt_shape = mean_vt_shape;
contour_data.U_gfa = U_gfa;
contour_data.weights = weights;

figure; plot_components(contour_data, variant_switch);

n = size(weights,1);

xy_data = D;

for i=1:n
    xy_data(i,:) = weights_to_vtshape(weights(i,:), mean_vt_shape,  U_gfa, variant_switch);
end;

Xsim = xy_data(:,1:d);
Ysim = xy_data(:,(d+1):end);

contour_data.Xsim = Xsim;
contour_data.Ysim = Ysim;

save(fullfile(configStruct.out_path,'contour_data.mat'),'contour_data')

end