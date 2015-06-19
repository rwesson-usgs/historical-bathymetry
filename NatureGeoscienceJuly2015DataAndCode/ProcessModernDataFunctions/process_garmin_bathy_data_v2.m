function [depmat t tbegin tend zbest elev] = process_garmin_bathy_data_v2(B,yr,mo,day,lat,lon,nsmooth)
%   Used in Nature Geoscience paper, July, 2015
%   Rob Wesson

path(path,'/Applications/tmd_toolbox')
path(path,'/Applications/tmd_toolbox/DATA')

%B = load(filename);
%size(B);
t = datenum(B(:,1),B(:,2),B(:,3),B(:,4),B(:,5),B(:,6));
z = B(:,10);
elev = B(:,9);

[ y mnx medx stdx trmnx ] = rejectoutliers_v2(t,z,1,35,20,1);
y2 = smoother2(y,nsmooth)';

%figure
%plot(t,y2,'k')
%hold on
y3=smoother2(y2,20)';
%plot(t,y3,'c')
%grid on
tbegin = t(1);
tend = t(length(t));
dv1 = datevec(tbegin);
dv2 = datevec(tend);
dt = datenum(0,0,0,0,1,0);
tp = datenum(dv1(1),dv1(2),dv1(3),dv1(4),dv1(5),0):dt:datenum(dv2(1),dv2(2),dv2(3),dv2(4),dv2(5)+1,0);
[zp,conlist] = tide_pred('Model_atlas',tp,lat,lon,'z');
zpint = interp1(tp,zp,t);
zbest = y3 - zpint;
depmat = [t B(:,7) B(:,8) y y2 y3 zpint zbest];