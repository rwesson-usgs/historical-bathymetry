%   Process Garmin and Humminbird Bathymetric Data for Isla Santa Maria
%   Used in Nature Geoscience paper, July, 2015
%   Rob Wesson

path(path,'ProcessModernDataFunctions')

%   January 2010

load Data_Garmin/Garmin_2010_1_13
load Data_Garmin/Garmin_2010_1_15
[depmatg1 tg1 tbeging1 tendg1 zbestg1 elevg1] = process_garmin_bathy_data_v2(Garmin_2010_1_13,2010,1,13,-37.044637,-73.509878,10);
[depmatg2 tg2 tbeging2 tendg2 zbestg2 elevg2] = process_garmin_bathy_data_v2(Garmin_2010_1_15,2010,1,15,-37.044637,-73.509878,10);

tgjan2010 = [tg1;tg2];
zgjan2010 = [zbestg1;zbestg2];
depmatjan2010 = [depmatg1;depmatg2];
[xgjan2010 ygjan2010 zone] = deg2utm(depmatjan2010(:,2),depmatjan2010(:,3));

[xgjan2010 ygjan2010 zgjan2010 tgjan2010 vgjan2010] = clean(xgjan2010,ygjan2010,zgjan2010,tgjan2010,5);
[xgjan2010 ygjan2010 zgjan2010 tgjan2010 vgjan2010] = clean(xgjan2010,ygjan2010,zgjan2010,tgjan2010,5);

load BigPoly

%   March 2010

load Data_Garmin/Garmin_2010_3_22
Garmin_2010_3_22(982:1019,10) = NaN;
Garmin_2010_3_22(1041:1073,10) = NaN;
[depmatg3 tg3 tbeging3 tendg3 zbestg3 elevg3] = process_garmin_bathy_data_v2(Garmin_2010_3_22,2010,3,22,-37.044637,-73.509878,20);

tgmar2010 = tg3;
zgmar2010 = zbestg3;
depmatmar2010 = depmatg3;
[xgmar2010 ygmar2010 zone] = deg2utm(depmatmar2010(:,2),depmatmar2010(:,3));

[xgmar2010 ygmar2010 zgmar2010 tgmar2010 vgmar2010] = clean(xgmar2010,ygmar2010,zgmar2010,tgmar2010,2);
[xgmar2010 ygmar2010 zgmar2010 tgmar2010 vgmar2010] = clean(xgmar2010,ygmar2010,zgmar2010,tgmar2010,2);


%   February 2011

load Data_Garmin/Garmin_2011_2_22
load Data_Garmin/Garmin_2011_2_24
Garmin_2011_2_22(2774:2790,10) = NaN;
Garmin_2011_2_24(4188:4220,10) = NaN;
Garmin_2011_2_24(4387:4397,10) = NaN;

[depmatg4 tg4 tbeging4 tendg4 zbestg4 elevg4] = process_garmin_bathy_data_v2(Garmin_2011_2_22,2010,2,22,-37.044637,-73.509878,10);
[depmatg5 tg5 tbeging5 tendg5 zbestg5 elevg5] = process_garmin_bathy_data_v2(Garmin_2011_2_24,2010,2,24,-37.044637,-73.509878,10);

tg2011 = [tg4;tg5];
zg2011 = [zbestg4;zbestg5];
depmat2011 = [depmatg4;depmatg5];
[xg2011 yg2011 zone] = deg2utm(depmat2011(:,2),depmat2011(:,3));

[xg2011 yg2011 zg2011 tg2011 vg2011] = clean(xg2011,yg2011,zg2011,tg2011,2);
[xg2011 yg2011 zg2011 tg2011 vg2011] = clean(xg2011,yg2011,zg2011,tg2011,2);



%   March 2013
load Data_Garmin/Garmin_2013_3_2
load Data_Garmin/Garmin_2013_3_3
Garmin_2013_3_2(5200:5400,10) = NaN;
Garmin_2013_3_2(5500:5600,10) = NaN;
[depmatg6 tg6 tbeging6 tendg6 zbestg6 elevg6] = process_garmin_bathy_data_v2(Garmin_2013_3_2,2013,3,2,-37.044637,-73.509878,20);
[depmatg7 tg7 tbeging7 tendg7 zbestg7 elevg7] = process_garmin_bathy_data_v2(Garmin_2013_3_3,2013,3,3,-37.044637,-73.509878,10);
tg2013 = [tg6;tg7];
zg2013 = [zbestg6;zbestg7];
depmatg2013 = [depmatg6;depmatg7];
[xg2013 yg2013 zone] = deg2utm(depmatg2013(:,2),depmatg2013(:,3));

[xg2013 yg2013 zg2013 tg2013 vg2013] = clean(xg2013,yg2013,zg2013,tg2013,2);
[xg2013 yg2013 zg2013 tg2013 vg2013] = clean(xg2013,yg2013,zg2013,tg2013,2);

%   All post earthquake Garmin data
%   Check depth differences at line crossings

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Calculating all the line intersections takes lots of memory!!!...
%   and takes a long time
%   If your machine hangs up here, you may want to skip this step...

[x0gpost,y0gpost,ioutgpost,joutgpost,zigpost,zjgpost,dzgpost] = ...
    intersections_diffs_v2(xp,yp,[xgmar2010;xg2011;xg2013],[ygmar2010;yg2011;yg2013],[zgmar2010;zg2011;zg2013]);

figure
plot(xp,yp,'k--')
hold on
plot([xgmar2010;xg2011;xg2013],[ygmar2010;yg2011;yg2013],'k.')
scatter(x0gpost,y0gpost,400,dzgpost,'.')
grid on
axis equal
hcolorbar = colorbar;
ylabel(hcolorbar,'Difference, m')
title('Depth Differences at Line Crossings, All Post-Earthquake Garmin Data')
xlabel('UTM Easting, m')
ylabel('UTM Northing, m')
%print -dpsc2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   Make Preliminary Garmin model from posteq data

Fgpost = TriScatteredInterp([xgmar2010;xg2011;xg2013],[ygmar2010;yg2011;yg2013],[zgmar2010;zg2011;zg2013]);


%   Process 2011 Humminbird data

[depmat3 t3 tbegin3 tend3 zbest3] = process_nmea_bathy_data_v2('Data_Humminbird/NmeaLog-2-22-2011.log.txt',2011,2,22,-37.044637,-73.509878);
[depmat4 t4 tbegin4 tend4 zbest4] = process_nmea_bathy_data_v2('Data_Humminbird/NmeaLog-2-24-2011.txt',2011,2,24,-37.044637,-73.509878);

depmat4(1:1930,:) = [];
t4(1:1930) = [];
zbest4(1:1930) = [];

n4 = length(t4);
depmat4(n4-446:n4,:) = [];
t4(n4-446:n4) = [];
zbest4(n4-446:n4) = [];

t2011 = [t3;t4];
depmat2011 = [depmat3;depmat4];
z2011 = [zbest3;zbest4];
[x2011 y2011 zone] = deg2utm(depmat2011(:,2),depmat2011(:,3));


[x2011 y2011 z2011 t2011 v2011] = clean(x2011,y2011,z2011,t2011,1);
[x2011 y2011 z2011 t2011 v2011] = clean(x2011,y2011,z2011,t2011,1);


%   Compare 2011 Humminbird with all Post Garmin Data

ip = inpolygon(x2011,y2011,xp,yp);
z2011pred = Fgpost(x2011(ip),y2011(ip));
dz2011garpost = z2011(ip) - z2011pred;
figure
plot(z2011(ip),dz2011garpost,'*')
polytool(z2011pred,z2011(ip))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   Correct Garmin Data to Sea Water Using Comparison with 2011 Humminbird

zgmar2010c = zgmar2010*1.0392 - 0.0935;
zg2011c = zg2011*1.0392 - 0.0935;
zg2013c = zg2013*1.0392 - 0.0935;

zgjan2010c = zgjan2010*1.0392 - 0.0935;

%   Correct for Transducer Depth

Transducer_depth = 0.15;

zgmar2010c = zgmar2010c + Transducer_depth;
zg2011c = zg2011c + Transducer_depth;
zg2013c = zg2013c + Transducer_depth;
zgjan2010c = zgjan2010c + Transducer_depth;

%   Calculate Model using corrected Post-earthquake Garmin data

Fgpostc = TriScatteredInterp([xgmar2010;xg2011;xg2013],[ygmar2010;yg2011;yg2013],[zgmar2010c;zg2011c;zg2013c]);
[Xa Ya] = meshgrid(6.31e5:50:6.4e5,5.892e6:50:5.9e6);
Zgpostc = Fgpostc(Xa,Ya);

save AggregateModel/GarminModelcor Xa Ya Fgpostc Zgpostc

save AggregateModel/CorrectedGarminData xgjan2010 xgmar2010 xg2011 xg2013 ygjan2010 ygmar2010 yg2011 yg2013 zgjan2010c zgmar2010c zg2011c zg2013c

%   Plot final corrected model

bathyplot(Xa,Ya,Zgpostc)
plot(xp,yp,'k--')
plot([xgmar2010;xg2011;xg2013],[ygmar2010;yg2011;yg2013],'k.')
hcolorbar = colorbar;
ylabel(hcolorbar,'Depth, m')
grid on
xlabel('UTM Easting, m')
ylabel('UTM Northing, m')
title('Final Corrected Model, All Post-EarthquakeGarmin Data')
set(gcf, 'PaperOrientation', 'landscape');
oldSettings = fillPage(gcf)
axis equal
%print -dpsc2



