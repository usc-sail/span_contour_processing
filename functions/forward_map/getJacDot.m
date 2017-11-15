function jacDot = getJacDot(dzdt,dwdt,names)

[jawIndx,tngIndx,lipIndx,velIndx] = getIndxs(names);
nf = sum([jawIndx,tngIndx,lipIndx,velIndx]);
nz = 6;
jacDot = zeros(nz,nf);

% multiple task variables (approach B)
% LA ~ jaw + lips1 + lips2
LzInd = 1;
LwInd = [find(jawIndx) find(lipIndx)];
dLdw=lscov(dwdt(:,LwInd),dzdt(:,LzInd));
jacDot(LzInd,LwInd) = dLdw';
% TIP,PALATE,ROOT ~ jaw + tongue1 + ... + tongue4
TRzInd = [2 3 5];
TRwInd = [find(jawIndx) find(tngIndx)];
dTRdw=lscov(dwdt(:,TRwInd),dzdt(:,TRzInd));
jacDot(TRzInd,TRwInd) = dTRdw';
% DORSUM ~ jaw + tongue1 + ... + tongue4 + vel
DzInd = 4;
DwInd = [find(jawIndx) find(tngIndx) find(velIndx)];
dDdw=lscov(dwdt(:,DwInd),dzdt(:,DzInd));
jacDot(DzInd,DwInd) = dDdw';
% VEL ~ vel
VzInd = 6;
VwInd = find(velIndx);
dVdw=lscov(dwdt(:,VwInd),dzdt(:,VzInd));
jacDot(VzInd,VwInd) = dVdw';

end