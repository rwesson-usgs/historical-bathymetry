function mn = meannan(x)
%   Used in Nature Geoscience paper, July, 2015
%   Rob Wesson
[m n] = size(x);
if n==1
    iok = find(~isnan(x));
    mn = mean(x(iok));
else
    for i=1:n
        iok = find(~isnan(x(:,i)));
        mn(i) = mean(x(iok,i));
    end
end

