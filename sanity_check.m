addpath(genpath('functions'))

configStruct=config;

outPath = configStruct.outPath;
load(fullfile(outPath,'contourdata.mat'))


figure;
for i=1000:1200
    
    plot_from_xy([contourdata.X(i,:),contourdata.Y(i,:)],contourdata.SectionsID,'b');
    plot_from_xy([contourdata.Xsim(i,:),contourdata.Ysim(i,:)],contourdata.SectionsID,'r'); 
    axis([-45 45 -45 45]); axis off;

    
    for j=1:6
        
        plot([contourdata.tv{j}.in(i,1) contourdata.tv{j}.out(i,1)], [contourdata.tv{j}.in(i,2) contourdata.tv{j}.out(i,2)],'bo-');
        plot([contourdata.tvsim{j}.in(i,1) contourdata.tvsim{j}.out(i,1)], [contourdata.tvsim{j}.in(i,2) contourdata.tvsim{j}.out(i,2)],'ro-');
        
    end;
    
    pause(0.1); hold off;
    
end;
    