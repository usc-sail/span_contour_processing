function plot_components(contourdata, variant_switch)

sections_id=contourdata.sections_id;

D=[contourdata.X,contourdata.Y];
U=contourdata.U_gfa;
mean_vt_shape=contourdata.mean_vt_shape;

mean_data=ones(size(D,1),1)*mean(D);
std_data=ones(size(D,1),1)*std(D);

std_weights = std(contourdata.weights);

if strcmp(variant_switch,'toutios2015factor')
    Dnorm=(D-mean_data)./std_data;
else
    Dnorm=D-mean_data;
end

components=[1 2:5 6:8 9:10];
names={'jaw','tongue 1' , 'tongue 2', 'tongue 3', 'tongue 4', 'lips 1','lips 2', 'velum',  'larynx 1', 'larynx 2'}; 

close all;

for j=1:10;  % component under examination
    
    parameters=zeros(1,10);
    subplot(2,5,j);
    
    i=components(j);
    
    %DD = Dnorm*U(:,i)*pinv(U(:,i));
    
    parameters(i)=-2*std_weights(i);
    plot_from_xy(weights_to_vtshape(parameters, mean_vt_shape, U, variant_switch),sections_id(1,:),'b'); hold on;
    
    parameters(i)=2*std_weights(i);
    plot_from_xy(weights_to_vtshape(parameters, mean_vt_shape, U, variant_switch),sections_id(1,:),'r'); hold on;
    
    plot_from_xy(mean(D),sections_id(1,:),'k');
    
    text(-20, -20, names(j));
    
    axis([-40 20 -30 30]); axis off;

    
end

