%   Basic georeferencing for historical charts used in
%   Nature Geoscience paper, July, 2015
%   Rob Wesson
  

clear

path(path,'GeoreferencingFunctions')
load HistoricalData/HistoricalData

%   UTM coordinates of prominent geographic features on Isla Santa Maria
%   as read from modern chart

rs2004=[    631620.355	5895566.152; %	southeast tip
            630575.80	5896783.400; %  piedras
            632521.729	5898918.051; %	aguada
            628546.115	5901371.864; %	western tip
            631440.203	5907277.997; %	northeast corner
            629883.466	5908465.835; %	center of farallon
            630356.798	5905749.435]; %	lighthouse
        

r = rs2004(1:6,1);
s = rs2004(1:6,2);
r0 = mean(r);
s0 = mean(s);
r1 = r - r0;
s1 = s - s0;

%   load pixel coordinates of same geographic features on ISM as read
%   on historical charts

%   extract desired features, shift from image (y-down from 
%   upper left hand corner) to xy system
%   (y-up from lower left hand corner), and subtract means

p1804 = [p1804(1:4) p1804(6:7)];
q1804 = [q1804(1:4) q1804(6:7)];
q1804 = 6410 - q1804;
p0_1804 = mean(p1804);
q0_1804 = mean(q1804);
p1_1804 = p1804 - p0_1804;
q1_1804 = q1804 - q0_1804;
            
p1835 = [p1835(1:4) p1835(6:7)];
q1835 = [q1835(1:4) q1835(6:7)];
q1835 = 7271 - q1835;
p0_1835 = mean(p1835);
q0_1835 = mean(q1835);
p1_1835 = p1835 - p0_1835;
q1_1835 = q1835 - q0_1835;


t = rs2004(1:7,1);
u = rs2004(1:7,2);
t0 = mean(t);
u0 = mean(u);
t1 = t - t0;
u1 = u - u0;

p1886 =[p1886(1:4),p1886(6:8)];
q1886 =[q1886(1:4),q1886(6:8)];
q1886 = 4214 - q1886;
p0_1886 = mean(p1886);
q0_1886 = mean(q1886);
p1_1886 = p1886 - p0_1886;
q1_1886 = q1886 - q0_1886;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   Find transformation from pixel to utm  by
%   solving lsq matrix equation for control points
%   then transform historical data to utm

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   1804

b= [r1;s1];
A = [p1_1804' -q1_1804';q1_1804' p1_1804'];
ab = lsqr(A,b);
abcd1804 = [ab;0;0]
rms1804 = sqrt((b - A*ab)'*(b-A*ab))/length(b)

[xutm1804 yutm1804 ] = simtrans_v2(xyz1804(:,1),6410-xyz1804(:,2),p0_1804,q0_1804,r0,s0,abcd1804);

xy1804utm = [xutm1804 yutm1804];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   1835


b= [r1;s1];
A = [p1_1835' -q1_1835';q1_1835' p1_1835'];
ab = lsqr(A,b);
abcd1835 = [ab;0;0]
rms1835 = sqrt((b - A*ab)'*(b-A*ab))/length(b)

[xutm1835 yutm1835 ] = simtrans_v2(xyz1835(:,1),7271-xyz1835(:,2),p0_1835,q0_1835,r0,s0,abcd1835);

xy1835utm = [xutm1835 yutm1835];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%   1886

b= [t1;u1];
A = [p1_1886' -q1_1886';q1_1886' p1_1886'];
ab = lsqr(A,b);
abcd1886 = [ab;0;0]
rms1886 = sqrt((b - A*ab)'*(b-A*ab))/length(b)

[xutm1886 yutm1886] = simtrans_v2(xyz1886(:,1),4214-xyz1886(:,2),p0_1886,q0_1886,r0,s0,abcd1886);

xy1886utm = [xutm1886 yutm1886];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

save HistoricalData_georeferenced  xy1804utm xy1835utm xy1886utm z1804m z1835m z1886m
