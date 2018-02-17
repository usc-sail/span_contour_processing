function [dzdt,dwdt] = getGrad(z,w,t,file)
% getGrad - returns time derivative of task variables and factor weights,
% splitting by file identifier so that discontinuities are not differenced.
% 
% Tanner Sorensen, March 7, 2016

fileBreaks = [1; find(diff(file)==1); size(z,1)];

dzdt = NaN(size(z,1),size(z,2));
dwdt = NaN(size(w,1),size(w,2));
for i=2:max(file)+1
    ii = fileBreaks(i-1):fileBreaks(i);
    [~,dzdt(ii,:)] = gradient(z(ii,:),t);
    [~,dwdt(ii,:)] = gradient(w(ii,:),t);
end

end