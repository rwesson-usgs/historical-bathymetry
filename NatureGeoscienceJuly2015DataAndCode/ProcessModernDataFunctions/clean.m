function [ x y z t v] = clean( x,y,z,t,deltatsample)
%   Used in Nature Geoscience paper, July, 2015
%   Rob Wesson
%   deltatsample is sample interval in seconds
%
%   Eliminate NaN's
n = length(x);
igood = find(~isnan(x) & ~isnan(y) & ~isnan(z));
t = t(igood);
x = x(igood);
y = y(igood);
z = z(igood);
m = length(x);
'Number of points containing NaN eliminated'
n - m
%   Eliminate redundant times
dt = diff(t);
ired = find(dt==0);
t(ired+1) = [];
x(ired+1) = [];
y(ired+1) = [];
z(ired+1) = [];
l = length(x);
'Number redundant times eliminated'
m - l
%   Eliminate points when boat is stopped (velocity is less than 1.5 m/s
dx = diff(x);
dy = diff(y);
dr = sqrt(dx.*dx + dy.*dy);
dt = diff(t);
v = dr./(dt*60*60*24/deltatsample);
islow = find(v <= 1.5);
t(islow+1) = [];
x(islow+1) = [];
y(islow+1) = [];
z(islow+1) = [];
v(islow) = [];
v = [0;v];
k = length(x);
'Number of points eliminated because boat is going less than 1.5 m/s'
l - k
%   Eliminate any duplicate points
[~,I,~] = unique([x y],'first','rows');
I = sort(I);
t = t(I);
x = x(I);
y = y(I);
z = z(I);
v = v(I);
j = length(x);
'Number of duplicate points eliminated (first instance retained)'
k - j
end

