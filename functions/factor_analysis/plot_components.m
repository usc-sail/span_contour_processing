function plot_components(contourdata)

SectionsID=contourdata.SectionsID;

D=[contourdata.X,contourdata.Y];
U=contourdata.U_gfa;
mean_vtshape=contourdata.mean_vtshape;

meandata=ones(size(D,1),1)*mean(D);
stddata=ones(size(D,1),1)*std(D);

stdweights = std(contourdata.weights);

Dnorm=(D-meandata)./stddata;

components=[1 2:5 6:8 9:10];
names={'jaw','tongue 1' , 'tongue 2', 'tongue 3', 'tongue 4', 'lips 1','lips 2', 'velum',  'larynx 1', 'larynx 2'}; 

close all;

for j=1:10;  % component under examination
    
    parameters=zeros(1,10);
    subplot(2,5,j);
    
    i=components(j);
    
    %DD = Dnorm*U(:,i)*pinv(U(:,i));
    
    parameters(i)=-2*stdweights(i);
    plot_from_xy(weights_to_vtshape(parameters, mean_vtshape,U),SectionsID(1,:),'b'); hold on;
    
    parameters(i)=2*stdweights(i);
    plot_from_xy(weights_to_vtshape(parameters, mean_vtshape,U),SectionsID(1,:),'r'); hold on;
    
    plot_from_xy(mean(D),SectionsID(1,:),'k');
    
    text(-20, -20, names(j));
    
    axis([-40 20 -30 30]); axis off;

    
end

