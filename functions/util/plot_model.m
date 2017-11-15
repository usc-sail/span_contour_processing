load mat/contourdata.mat
load mat/U_gfa.mat
addpath functions/util

participant = 'ipa_je';

SectionsID=contourdata.(participant).SectionsID;
D=[contourdata.(participant).X,contourdata.(participant).Y];

meandata=ones(size(D,1),1)*mean(D);
Dnorm=D-meandata;
meandata=mean(D);

figure
U = U_gfa.(participant);

factors = [1 6 7 8 2 3 4 5];
par_label = {'jaw','tongue 1','tongue 2','tongue 3', 'tongue 4', 'lips 1', 'lips 2', 'velum'};

for i=1:8;
    
    subplot(2,4,i);
    
    DD = Dnorm*U(:,factors(i))*pinv(U(:,factors(i)));
    
    
    plot_from_xy(meandata+2*std(DD),SectionsID(1,:),'b'); hold on;
    plot_from_xy(meandata-2*std(DD),SectionsID(1,:),'r'); hold on;
    
    plot_from_xy(meandata,SectionsID(1,:),'k');
    
    title(par_label{factors(i)});
    axis([-40 10 -20 30]); axis off;
    
end;