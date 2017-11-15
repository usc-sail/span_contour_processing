function U_tng = get_Utng(contourdata, U_jaw)
% GET_UTNG - extract tongue factors for vocal-tract factor analysis as in: Asterios Toutios, Shrikanth S. Narayanan, "Factor 
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

%Dnorm=Dnorm-Dnorm*f1*pinv(f1);

vtsection=[2]; % Tongue

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


U_tngraw=U;

%%% GFA

vtsection=[1,2];

%contourdata=contourdata_pca;

SectionsID=contourdata.SectionsID;

D=[contourdata.X,contourdata.Y];

D=D-D*U_jaw*pinv(U_jaw);

meandata=ones(size(D,1),1)*mean(D);

Dnorm=D-meandata;

SecID2=[SectionsID,SectionsID];

Dnorm(:,~ismember(SecID2,vtsection))=0;

N= size(D,1);

% Covariance matrix
R = Dnorm'*Dnorm/N

% GFA Overall

for i=1:10
    
    t1=U_tngraw(:,i);
    
    v=t1'*R*t1;
    
    h1=t1/sqrt(v);
    
    f1=(h1'*R)';
    
    %a1=inv(R)*f1;
    
    R=R-f1*f1';
    
    U(:,i)=f1;
    
end;


U_tng=U;
