function med = mediannan(x)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[m n] = size(x);
if n==1
    iok = find(~isnan(x));
    med = median(x(iok));
else
    for i=1:n
        iok = find(~isnan(x(:,i)));
        med(i) = median(x(iok,i));
    end
end

