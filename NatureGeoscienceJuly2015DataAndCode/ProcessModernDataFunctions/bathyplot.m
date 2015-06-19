function bathyplot(X,Y,Z)
%   Used in Nature Geoscience paper, July, 2015
%   Rob Wesson

figure
surf(X,Y,-Z)
view(2)
shading flat
hold on
axis equal
colorbar
end


