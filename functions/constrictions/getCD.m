function [D,x1,y1,x2,y2] = getCD(Xout,Yout,Xin,Yin)
% GETCD - calculates the closest distance between the polygons whose 
% vertices are given in the (Xout,Yout) and (Xin,Yin) vectors. The distance
% and the closest point(s) on the polygon is(are) returned.
% 
% INPUT:
%  Xout, Yout - coordinates of the superior/posterior articulator in the
%  (X,Y)-plane
%  Xin, Yin - coordinates of the inferior/anterior articulator in the
%  (X,Y)-plane
% 
% FUNCTION OUTPUT: 
%  D - distance between the superior/posterior articulator and the 
%    inferior/anterior articulator in pixels
%  x1, y1 - coordinates on the superior/posterior articulator used to
%    calculate D
%  x2, y2 - coordinates on the inferior/anterior articulator used to
%    calculate D
% 
% SAVED OUTPUT:
%  none
% 
% Tanner Sorensen
% Signal Analysis and Interpretation Laboratory
% Apr. 14, 2017

[D,xPoly1Closest,yPoly1Closest,xPoly2Closest,yPoly2Closest] = spanPolyPolyDist_modified(Xout,Yout,Xin,Yin);
x1 = xPoly1Closest(1);
y1 = yPoly1Closest(1);
x2 = xPoly2Closest(1);
y2 = yPoly2Closest(1);

end
