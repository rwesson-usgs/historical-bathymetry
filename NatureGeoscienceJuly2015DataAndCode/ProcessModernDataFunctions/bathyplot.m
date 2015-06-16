function bathyplot(X,Y,Z)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

figure
surf(X,Y,-Z)
view(2)
shading flat
hold on
axis equal
colorbar
end


