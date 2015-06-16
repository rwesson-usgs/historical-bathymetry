function y = smoother2( x,n)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
nx = length(x);
n2 = floor(n/2);
for i=1:length(x)
    if isnan(x(i))
        y(i) = NaN;
    else
        iminus = max(1,i-n2);
        iplus = min(i+n2,nx);
        idiff = iplus - iminus + 1;
        sample = x(iminus:iplus);
        inan = find(~isnan(sample));
        lnan = length(inan);
        y(i) = sum(sample(inan))/lnan;
    end
end

