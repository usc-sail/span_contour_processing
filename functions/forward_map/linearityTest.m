function [linear,dzdw,resid] = linearityTest(z,w,crit,names)

[~,dzdw,resid] = getFwdMap(z,w,names);
resid = mean(sqrt(resid));
linear = resid < crit;

end