function [depmat t tbegin tend zbest] = process_nmea_bathy_data(filename,yr,mo,day,lat,lon)
%   Used in Nature Geoscience paper, July, 2015
%   Rob Wesson
path(path,'/Applications/tmd_toolbox')
path(path,'/Applications/tmd_toolbox/DATA')

B = nmea2matlab(filename);

depmat = depth_extract_v3(yr,mo,day,B);
t = depmat(:,1);
[ y mnx medx stdx trmnx ] = rejectoutliers_v2(depmat(:,1),depmat(:,4),1,20,20,1);
y2 = smoother2(y,20)';

%figure
%plot(t,y2,'k')
%hold on
y3=smoother2(y2,20)';
%plot(t,y3,'c')
%grid on
tbegin = t(1)
tend = t(length(t))
dv1 = datevec(tbegin)
dv2 = datevec(tend)
dt = datenum(0,0,0,0,1,0);
tp = datenum(dv1(1),dv1(2),dv1(3),dv1(4),dv1(5),0):dt:datenum(dv2(1),dv2(2),dv2(3),dv2(4),dv2(5)+1,0);
[zp,conlist] = tide_pred('Model_atlas',tp,lat,lon,'z');
zpint = interp1(tp,zp,t);
zbest = y3 - zpint;
depmat = [depmat y y2 y3 zpint zbest];