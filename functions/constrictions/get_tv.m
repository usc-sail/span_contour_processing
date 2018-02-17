function get_tv(configStruct,varargin)
% MAIN - compute task variables from articulator weights.
% 
% Based heavily on the script of Vikram Ramanarayanan (SPAN-USC, 2009).
%
% Tanner Sorensen

% Load data of contours, weights, and model.
%load ../contour_data_gfa.mat
%addpath ./util
%contour_data = contour_data_gfa;

if nargin < 2
    sim_switch = false;
elseif nargin == 2
    sim_switch = varargin{1};
else
    sim_switch = false;
    warning(['Function get_tv.m was called with %d input arguments,' ...
        ' but requires 1 (optionally 2)'],nargin)
end

% load articulator contours in the structured array contour_data
load(fullfile(configStruct.out_path,'contour_data.mat'))

% make articulator contours denser by a factor of six
ds = 1/6;

% initialize tv containers
la=zeros(size(contour_data.X,1),1); ulx=la; uly=la; llx=la; lly=la;
vp=la; velumx1=la; velumy1=la; pharynxx1=la; pharynxy1=la;
alv=la; alveolarx=la; alveolary=la; tonguex2=la; tonguey2=la;
pal=la; palatalx=la; palataly=la; tonguex3=la; tonguey3=la;
vel=la; velumx2=la; velumy2=la; tonguex1=la; tonguey1=la;
phar=la; pharynxx2=la; pharynxy2=la; tonguex4=la; tonguey4=la; 

% initialize index for tv containers
k=1;

files = unique(contour_data.files);
nFiles = length(files);

for i=1:nFiles
    % display progress
    if ~sim_switch
        disp(['Getting (original) TVs file ' num2str(i) ' of ' num2str(nFiles)])
    else
        disp(['Getting (simulated) TVs file ' num2str(i) ' of ' num2str(nFiles)])
    end
    
    % obtain frame numbers for the i-th file
    frames=contour_data.frames(contour_data.files==i);
    
    for j=1:length(frames)
        % OPTIONAL: keep hard palate at its mean value by un-commenting
        %   contour_data.weights(contour_data.File == files(i),11:12)=0; 

        % segment the vocal tract into pieces
        [Xul,Yul,Xll,Yll,Xtongue,Ytongue,Xalveolar,...
            Yalveolar,Xpalatal,Ypalatal,Xvelum,Yvelum,...
            Xvelar,Yvelar,Xphar,Yphar] = vtSeg(contour_data,...
            i,frames(j),ds,sim_switch);
        
        % obtain task variables
        %   LA - lip aperture
        %   ALV - alveolar constriction degree
        %   PAL - palatal constriction degree
        %   VEL - velar constriction degree
        %   PHAR - pharyngeal constriction degree
        %   VP - velopharyngeal port
        [la(k),ul_x(k),ul_y(k),ll_x(k),ll_y(k)] = get_la(Xul,Yul,Xll,Yll);
        [alv(k),alv_x(k),alv_y(k),tng1_x(k),tng1_y(k)] = get_alv(Xalveolar,Yalveolar,Xtongue,Ytongue);
        [pal(k),pal_x(k),pal_y(k),tng2_x(k),tng2_y(k)] = get_pal(Xpalatal,Ypalatal,Xtongue,Ytongue);
        [vel(k),vel1_x(k),vel1_y(k),tng3_x(k),tng3_y(k)] = get_vel(Xvelar,Yvelar,Xtongue,Ytongue);
        [phar(k),phar1_x(k),phar1_y(k),tng4_x(k),tng4_y(k)] = get_phar(Xphar,Yphar,Xtongue,Ytongue);
        [vp(k),vel2_x(k),vel2_y(k),phar2_x(k),phar2_y(k)] = get_vp(Xvelum,Yvelum,Xphar,Yphar);
        
        % incrememnt index for tv containers
        k=k+1;
    end
end

% save tv containers to contour_data
if ~sim_switch
    tv_label = 'tv';
else
    tv_label = 'tvsim';
end
contour_data.(tv_label){1}.cd=la; contour_data.tv{1}.in=[llx lly]; contour_data.tv{1}.out=[ulx uly];
contour_data.(tv_label){2}.cd=vp; contour_data.tv{2}.in=[velumx1 velumy1]; contour_data.tv{2}.out=[pharynxx1 pharynxy1];
contour_data.(tv_label){3}.cd=alv; contour_data.tv{3}.in=[tonguex2 tonguey2]; contour_data.tv{3}.out=[alveolarx alveolary];
contour_data.(tv_label){4}.cd=pal; contour_data.tv{4}.in=[tonguex3 tonguey3]; contour_data.tv{4}.out=[palatalx palataly];
contour_data.(tv_label){5}.cd=vel; contour_data.tv{5}.in=[tonguex1 tonguey1]; contour_data.tv{5}.out=[velumx2 velumy2];
contour_data.(tv_label){6}.cd=phar; contour_data.tv{6}.in=[tonguex4 tonguey4]; contour_data.tv{6}.out=[pharynxx2 pharynxy2];

% update contour_data to contain TV
save(fullfile(configStruct.out_path,'contour_data.mat'),'contour_data')