function [ x y ] = helmert( p,q,p0,q0,x0,y0,abcd)

[m n] = size(p);
if n ~= 1
    p = p';
    q = q';
end

n = length(p);
x = [p-p0 -q+q0  ones(n,1) zeros(n,1)] * abcd + x0;
y = [q-q0  p-p0 zeros(n,1)  ones(n,1)] * abcd + y0;

end

