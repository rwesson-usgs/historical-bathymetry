function bathycheck(titlestr,x,y,z )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

F = TriScatteredInterp(x,y,z);
[Xa Ya] = meshgrid(6.31e5:50:6.4e5,5.892e6:50:5.9e6);
Z = F(Xa,Ya);
bathyplot(Xa,Ya,Z)
plot(x,y,'k.')
title(titlestr)
end

