function getTVsim(configStruct)

% MAIN - compute task variables from articulator weights.
% 
% Based heavily on the script of Vikram Ramanarayanan (SPAN-USC, 2009).
%
% Tanner Sorensen

% Load data of contours, weights, and model.
%load ../contourdata_gfa.mat
%addpath ./util
%contourdata = contourdata_gfa;

outPath = configStruct.outPath;
load(fullfile(outPath,'contourdata.mat'))

%conversion_factor = 0.0431; %used to be 0.0446
ds = 1/6; % Make tissue-air boundary outlines denser by a factor of six.

n=size(contourdata.X,1);

LA=zeros(n,1); ulx=LA; uly=LA; llx=LA; lly=LA;
VEL=LA; velumx1=LA; velumy1=LA; pharynxx1=LA; pharynxy1=LA;
alveolarCD=LA; alveolarx=LA; alveolary=LA; tonguex2=LA; tonguey2=LA;
palatalCD=LA; palatalx=LA; palataly=LA; tonguex3=LA; tonguey3=LA;
velarCD=LA; velumx2=LA; velumy2=LA; tonguex1=LA; tonguey1=LA;
pharyngealCD=LA; pharynxx2=LA; pharynxy2=LA; tonguex4=LA; tonguey4=LA; 

files = unique(contourdata.File);
nFiles = length(files);
k=1;
for i=1:nFiles
     frames=contourdata.Frames(contourdata.File==i);
         for j=1:length(frames)
%         % OPTIONAL: Keep hard palate at its mean value
%         %contourdata.weights(contourdata.File == files(i),11:12)=0; 

        [X,Y,Xul,Yul,Xll,Yll,Xtongue,Ytongue,Xalveolar,...
            Yalveolar,Xpalatal,Ypalatal,Xvelum,Yvelum,...
            Xvelar,Yvelar,Xphar,Yphar] = vtSegSim(contourdata,...
            i,frames(j),ds);
        
        [LA(k),ulx(k),uly(k),llx(k),lly(k)] = getLA(Xul,Yul,Xll,Yll);
        [VEL(k),velumx1(k),velumy1(k),pharynxx1(k),pharynxy1(k)] = getVEL(Xvelum,Yvelum,Xphar,Yphar);
        [alveolarCD(k),alveolarx(k),alveolary(k),tonguex2(k),tonguey2(k)] = getAlveolarCD(Xalveolar,Yalveolar,Xtongue,Ytongue);
        [palatalCD(k),palatalx(k),palataly(k),tonguex3(k),tonguey3(k)] = getPalatalCD(Xpalatal,Ypalatal,Xtongue,Ytongue);
        [velarCD(k),velumx2(k),velumy2(k),tonguex1(k),tonguey1(k)] = getVelarCD(Xvelar,Yvelar,Xtongue,Ytongue);
        [pharyngealCD(k),pharynxx2(k),pharynxy2(k),tonguex4(k),tonguey4(k)] = getPharyngealCD(Xphar,Yphar,Xtongue,Ytongue);
        
        k=k+1;
%         end;
     end
    disp(['Getting reconstructed TVs file ' num2str(i) ' of ' num2str(nFiles)])
end
%TV = [LA' alveolarCD' palatalCD' velarCD' pharyngealCD' VEL'];
contourdata.tvsim{1}.cd=LA; contourdata.tvsim{1}.in=[llx lly]; contourdata.tvsim{1}.out=[ulx uly];
contourdata.tvsim{2}.cd=VEL; contourdata.tvsim{2}.in=[velumx1 velumy1]; contourdata.tvsim{2}.out=[pharynxx1 pharynxy1];
contourdata.tvsim{3}.cd=alveolarCD; contourdata.tvsim{3}.in=[tonguex2 tonguey2]; contourdata.tvsim{3}.out=[alveolarx alveolary];
contourdata.tvsim{4}.cd=palatalCD; contourdata.tvsim{4}.in=[tonguex3 tonguey3]; contourdata.tvsim{4}.out=[palatalx palataly];
contourdata.tvsim{5}.cd=velarCD; contourdata.tvsim{5}.in=[tonguex1 tonguey1]; contourdata.tvsim{5}.out=[velumx2 velumy2];
contourdata.tvsim{6}.cd=pharyngealCD; contourdata.tvsim{6}.in=[tonguex4 tonguey4]; contourdata.tvsim{6}.out=[pharynxx2 pharynxy2];

save(fullfile(configStruct.outPath,'contourdata.mat'),'contourdata')