function U_lip = get_Ulip(contourdata, U_jaw)
% GET_ULIP - extract lip factors for vocal-tract factor analysis as in: Asterios Toutios, Shrikanth S. Narayanan, "Factor 
% analysis of vocal-tract outlines derived from real-time magnetic resonance imaging data",ICPhS, Glasgow, UK, 2015.
% http://sipi.usc.edu/~toutios/
%
% Asterios Toutios
% University of Southern California
% Nov 15, 2017

SectionsID=contourdata.SectionsID;

D=[contourdata.X,contourdata.Y];

D=D-D*U_jaw*pinv(U_jaw);

meandata=ones(size(D,1),1)*mean(D);

Dnorm=D-meandata;

vtsection=[4,15]; % Lower and upper lip

% 01 Epiglottis
% 02 Tongue
% 03 Incisor
% 04 Lower Lip
% 05 Jaw
% 06 Trachea
% 07 Low Pharynx
% 08 Arytenoid
% 09 High Pharynx
% 10 Outer Margin
% 11 Palate
% 12 Velum
% 13 Nasal Cavity
% 14 Nose
% 15 Upper Lip

SecID2=[SectionsID,SectionsID];

Dnorm(:,~ismember(SecID2,vtsection))=0;

[U,V,varpercent,m]=span_pca(Dnorm,size(D,2));

U_lip=U;
