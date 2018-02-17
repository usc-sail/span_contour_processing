function plot_from_xy(xy_data,sectionID,color)

X=xy_data(1:length(xy_data)/2);
Y=xy_data(length(xy_data)/2+1:end);

X1=X(ismember(sectionID,1:6));
Y1=Y(ismember(sectionID,1:6));

X2=X(ismember(sectionID,7:10));
Y2=Y(ismember(sectionID,7:10));

X3=X(ismember(sectionID,11:15));
Y3=Y(ismember(sectionID,11:15));

plot(X1,Y1,color,'LineWidth',2);hold on;
plot(X2,Y2,color,'LineWidth',2);
plot(X3,Y3,color,'LineWidth',2);%hold off;

axis equal;




    

