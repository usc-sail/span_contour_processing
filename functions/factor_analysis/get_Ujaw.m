function U_jaw = get_Ujaw(contourdata)
% GET_UJAW - extract jaw factor for vocal-tract factor analysis as in: Asterios Toutios, Shrikanth S. Narayanan, "Factor 
% analysis of vocal-tract outlines derived from real-time magnetic resonance imaging data",ICPhS, Glasgow, UK, 2015.
% http://sipi.usc.edu/~toutios/
%
% Asterios Toutios
% University of Southern California
% Nov 15, 2017

SectionsID=contourdata.SectionsID;

D=[contourdata.X,contourdata.Y];

d=size(D,2);

meandata=ones(size(D,1),1)*mean(D);

Dnorm=D-meandata;

vtsection=[5,3]; %Jaw + Incisor

% 01 Epiglottis
% 02 Tongue
% 03 Incisor
% 04 Lower Lip
% 05 Jaw
% 06 Trachea
% 07 Pharynx
% 08 Upper Bound
% 09 Left Bound
% 10 Low Bound
% 11 Palate
% 12 Velum
% 13 Nasal Cavity
% 14 Nose
% 15 Upper Lip

SecID2=[SectionsID,SectionsID];

Dnorm(:,~ismember(SecID2,vtsection))=0;

[U,V,varpercent,m]=span_pca(Dnorm,d);

close all;

U_jawraw=U;

%%% GFA

vtsection=[1:6];


SectionsID=contourdata.SectionsID;

D=[contourdata.X,contourdata.Y];

meandata=ones(size(D,1),1)*mean(D);

Dnorm=D-meandata;

SecID2=[SectionsID,SectionsID];

Dnorm(:,~ismember(SecID2,vtsection))=0;

N = size(D,1);

% Covariance matrix
R = Dnorm'*Dnorm/N;

size(R)

% GFA Overall

t1=U_jawraw(:,1);

v=t1'*R*t1;

h1=t1/sqrt(v);

f1=(h1'*R)';

%a1=inv(R)*f1;

R2=R-f1*f1';

U_jaw=f1;

