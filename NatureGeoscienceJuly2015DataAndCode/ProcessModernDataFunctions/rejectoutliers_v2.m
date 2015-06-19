function [ y mnx medx stdx trmnx ] = rejectoutliers_v2(t,x,min_x,max_x,npt,dz)
%   Used in Nature Geoscience paper, July, 2015
%   Rob Wesson
imin = find(x<min_x);
x(imin) = NaN;
imax = find(x>max_x);
x(imax) = NaN;
%figure
%plot(t,x)
%hold on
n = length(x);
ncol = ceil(n/npt);
if (ncol*npt~=npt)
    xtra = NaN*ones(ncol*npt-n,1);
    x = [x;xtra];
    t = [t;xtra];
end
X= reshape(x,npt,ncol);
T= reshape(t,npt,ncol);
tmn = meannan(T);
mnx = meannan(X);
medx = mediannan(X);
stdx = stdnan(X);
trmnx = trimmeannan(X,90);

%plot(tmn,mnx,'g+')
%plot(tmn,medx,'c+')
%plot(tmn,trmnx,'r+')

xest = interp1(tmn,trmnx,t);
inotok = find(abs(xest-x)>dz);
y=x;
y(inotok)=NaN;
ijunk=find(isnan(xest));
y(ijunk)=NaN;

%plot(t,y,'r')
%grid on
y = y(1:n);