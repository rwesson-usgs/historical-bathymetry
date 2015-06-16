function tm = trimmeannan(x,percent)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[m n] = size(x);
if n==1
    iok = find(~isnan(x));
    tm = trimmean(x(iok),percent);
else
    for i=1:n
        iok = find(~isnan(x(:,i)));
        tm(i) = trimmean(x(iok,i),percent);
    end
end

