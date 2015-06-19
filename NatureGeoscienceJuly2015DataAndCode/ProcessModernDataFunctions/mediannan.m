function med = mediannan(x)
%   Used in Nature Geoscience paper, July, 2015
%   Rob Wesson
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

