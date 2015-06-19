function sd = stdnan(x)
%   Used in Nature Geoscience paper, July, 2015
%   Rob Wesson
[m n] = size(x);
if n==1
    iok = find(~isnan(x));
    sd = std(x(iok));
else
    for i=1:n
        iok = find(~isnan(x(:,i)));
        sd(i) = std(x(iok,i));
    end
end

