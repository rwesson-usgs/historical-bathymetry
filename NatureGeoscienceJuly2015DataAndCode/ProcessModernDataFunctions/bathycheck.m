function bathycheck(titlestr,x,y,z )
%   Used in Nature Geoscience paper, July, 2015
%   Rob Wesson

F = TriScatteredInterp(x,y,z);
[Xa Ya] = meshgrid(6.31e5:50:6.4e5,5.892e6:50:5.9e6);
Z = F(Xa,Ya);
bathyplot(Xa,Ya,Z)
plot(x,y,'k.')
title(titlestr)
end

