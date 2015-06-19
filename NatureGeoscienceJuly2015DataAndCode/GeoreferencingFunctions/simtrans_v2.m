function [ xutm yutm ] = simtrans_v2( xpix,ypix,xpix0,ypix0,xutm0,yutm0,x)
%   Used in Nature Geoscience paper, July, 2015
%   Rob Wesson

n = length(xpix);
xutm = [xpix-xpix0 -ypix+ypix0 ones(n,1) zeros(n,1)] * x + xutm0;
yutm = [ypix-ypix0  xpix-xpix0 zeros(n,1)  ones(n,1)] * x + yutm0;

end

