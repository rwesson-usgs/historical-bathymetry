function [abcd x0 y0 p0 q0 rmserr flag] = findhelmert( x,y,p,q )
%   Used in Nature Geoscience paper, July, 2015
%   Rob Wesson

[m n] = size(x);
if n ~= 1
    x = x';
    y = y';
  
end
[m n] = size(p);
if n ~= 1
    p = p';
    q = q';
end
n = length(x);

x0 = mean(x);
y0 = mean(y);
p0 = mean(p);
q0 = mean(q);

x1 = x - x0;
y1 = y - y0;
p1 = p - p0;
q1 = q - q0;

b= [x1;y1];
A = [p1 -q1    ones(n,1) zeros(n,1)
     q1  p1  zeros(n,1)  ones(n,1)];
 
[abcd flag] = lsqr(A,b);
if flag~=0
    'Problem in lsqr'
end
eps - b - A*abcd;
rmserr = sqrt((b - A*abcd)'*(b-A*abcd))/n;

end

