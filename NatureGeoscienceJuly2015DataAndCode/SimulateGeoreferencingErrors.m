%   Simulate errors in georeferencing
%   Nature Geoscience paper, July, 2015
%   Rob Wesson

clear 

path(path,'SimulateGeoreferencingErrorsFunctions')

%   UTM coordinates of control points from modern map
rs2004=[    631620.355	5895566.152; %	southeast tip
            630575.80	5896783.400; %  piedras
            632521.729	5898918.051; %	aguada
            628546.115	5901371.864; %	western tip
            631440.203	5907277.997; %	northeast corner
            629883.466	5908465.835; %	center of farallon
            630356.798	5905749.435] %	lighthouse   

load HistoricalData/HistoricalData
load HistoricalData/HistoricalData_georeferenced
load AggregateModel/GarminModelcor
load DepthDifferenceFunctions/AllPoly_v3

%   The analysis will be done within the conservative polygon (xcon,ycon)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Net corrections to get to MSL

%   Mean truncation error
MTE1804 = 0.418;
MTE1835 = 0.2285;
MTE1886 = 0.25;

%   Correction from survey datum to MSL
CtoMSL = 0.9;

%   Correction for sea level rise
CforSLR1804 = 0.2;
CforSLR1835 = 0.2;
CforSLR1886 = 0.2;

%   Correction = MTE + CtoMSL + SLRise

dDz1804 = MTE1804 + CtoMSL + CforSLR1804
dDz1835 = MTE1835 + CtoMSL + CforSLR1835
dDz1886 = MTE1886 + CtoMSL + CforSLR1886

z1804m = z1804m + dDz1804;
z1835m = z1835m + dDz1835;
z1886m = z1886m + dDz1886;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Set up parameters to georeference from pixel coordinates on images to UTM

r = rs2004(1:6,1);
s = rs2004(1:6,2);


p1804 = [p1804(1:4) p1804(6:7)];
q1804 = [q1804(1:4) q1804(6:7)];
q1804 = 6410 - q1804;
            
p1835 = [p1835(1:4) p1835(6:7)];
q1835 = [q1835(1:4) q1835(6:7)];
q1835 = 7271 - q1835;


t = rs2004(1:7,1);
u = rs2004(1:7,2);

p1886 =[p1886(1:4),p1886(6:8)];
q1886 =[q1886(1:4),q1886(6:8)];
q1886 = 4214 - q1886;


[abcd1804 x01804 y01804 p01804 q01804 rms1804 flag] = findhelmert( r,s,p1804,q1804 )

[abcd1835 x01835 y01835 p01835 q01835 rms1835 flag] = findhelmert( r,s,p1835,q1835 )

[abcd1886 x01886 y01886 p01886 q01886 rms1886 flag] = findhelmert( t,u,p1886,q1886 )


[ xcp1804 ycp1804 ] = helmert( p1804,q1804,p01804,q01804,x01804,y01804,abcd1804);

[ xcp1835 ycp1835 ] = helmert( p1835,q1835,p01835,q01835,x01835,y01835,abcd1835);

[ xcp1886 ycp1886 ] = helmert( p1886,q1886,p01886,q01886,x01886,y01886,abcd1886);

%   Set up parameters for simulation

ntrials = 10000;

%   sdmeters is the standard deviation in meters of the uncertainty in location
%   of the control point or sounding

sdmeters = [ 0 10 50 100 150 200 250 300 350 400 450 500];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   1804

%   Estimate systematic uncertainty owing to georeferencing

mndzc = zeros(ntrials,length(sdmeters));
mndzct = zeros(ntrials,length(sdmeters));
ndz = zeros(ntrials,length(sdmeters));
abcdr =zeros(ntrials,length(sdmeters),4);

for j=1:length(sdmeters);

    xpix = xyz1804(:,1);
    ypix = 6410 - xyz1804(:,2);
    zpix     = z1804m;
   
    sfac = sqrt(abcd1804(1)^2 +abcd1804(2)^2);
    n =length(p1804);

    for i=1:ntrials
        [ dx dy ] = random_offsets(0,sdmeters(j),sfac,n);
        p = p1804' + dx;
        q = q1804' + dy;
        
        [abcdrhold x0r y0r p0r q0r rmsr flag] = findhelmert( r,s,p,q );
        
        abcdr(i,j,1)  = abcdrhold(1);
        abcdr(i,j,2)  = abcdrhold(2);
        abcdr(i,j,3)  = abcdrhold(3);
        abcdr(i,j,4)  = abcdrhold(4);
        [ xr yr ] = helmert( xpix,ypix,p0r,q0r,x0r,y0r,abcdrhold);
        [dz mndz mndzc(i,j) sddz(i,j) ndz(i,j)] = compare_depthsv2(Fgpostc,Xa,Ya,Zgpostc,xr,yr,z1804m,1,xcon,ycon,0,0,[],[] );
    end
    
end


supermn = mean(mndzc)
supersd = std(mndzc)
supern = mean(ndz)
    
    
figure
[ax,h1,h2] = plotyy(sdmeters,supermn,sdmeters,supersd);

set(h1, 'Marker','*')
set(h2, 'Marker','+')
grid on
legend('Mean of Means','Standard Deviation')
title('Simulation of Errors in Locating Control Points on 1804 Chart')
xlabel('Standard Deviation  of x and y Offsets on 1804 Chart Relative to Modern, m')
set(get(ax(1),'Ylabel'),'String','Mean Difference in Depth, 1804-2011, Mean of Means, m ') 
set(get(ax(2),'Ylabel'),'String','Standard Deviation of Means, m') 

%   Estimate random uncertainties from independent positions errors in
%   soundings

mndzc = zeros(ntrials,length(sdmeters));
ndz = zeros(ntrials,length(sdmeters));
for j=1:length(sdmeters);

    sfac = sqrt(abcd1804(1)^2 +abcd1804(2)^2);
    n =length(xyz1804(:,1));

    for i=1:ntrials
        [ dx dy ] = random_offsets(0,sdmeters(j),sfac,n);
        p = xyz1804(:,1) + dx;
        q = 6410 - xyz1804(:,2) + dy;
        
        [ xr yr ] = helmert( p,q,p01804,q01804,x01804,y01804,abcd1804);
        [dz mndz mndzc(i,j) sddz ndz(i,j)] = compare_depthsv2(Fgpostc,Xa,Ya,Zgpostc,xr,yr,zpix,1,xcon,ycon,dDz1804,0,[],[] );
    end
    
end

supermn = mean(mndzc)
supersd = std(mndzc)
supern = mean(ndz)

figure
[ax,h1,h2] = plotyy(sdmeters,supermn,sdmeters,supersd);

set(h1, 'Marker','*')
set(h2, 'Marker','+')
grid on
legend('Mean of Means','Standard Deviation')
title('Simulation of Independent Position Errors on 1804 Chart')
xlabel('Standard Deviation  of x and y Offsets in Soundings on 1804 Chart, m')
set(get(ax(1),'Ylabel'),'String','Mean Difference in Depth, 1804-2011, Mean of Means, m ') 
set(get(ax(2),'Ylabel'),'String','Standard Deviation of Means, m') 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   1835

%   Estimate systematic uncertainty owing to georeferencing

mndzc = zeros(ntrials,length(sdmeters));
mndzct = zeros(ntrials,length(sdmeters));
ndz = zeros(ntrials,length(sdmeters));
abcdr =zeros(ntrials,length(sdmeters),4);

for j=1:length(sdmeters);

    xpix = xyz1835(:,1);
    ypix = 7271 - xyz1835(:,2);
    zpix     = z1835m;
    
    sfac = sqrt(abcd1835(1)^2 +abcd1835(2)^2);
    n =length(p1835);
    
    for i=1:ntrials
        [ dx dy ] = random_offsets(0,sdmeters(j),sfac,n);
        
        p = p1835' + dx;
        q = q1835' + dy;
        
        [abcdrhold x0r y0r p0r q0r rmsr flag] = findhelmert( r,s,p,q );
        abcdr(i,j,1)  = abcdrhold(1);
        abcdr(i,j,2)  = abcdrhold(2);
        abcdr(i,j,3)  = abcdrhold(3);
        abcdr(i,j,4)  = abcdrhold(4);
        [ xr yr ] = helmert( xpix,ypix,p0r,q0r,x0r,y0r,abcdrhold);
        [dz mndz mndzc(i,j) sddz ndz(i,j)] = compare_depthsv2(Fgpostc,Xa,Ya,Zgpostc,xr,yr,zpix,1,xcon,ycon,dDz1835,0,[],[] );
    end
    
end

supermn = mean(mndzc)
supersd = std(mndzc)
supern = mean(ndz)
    
    
figure
[ax,h1,h2] = plotyy(sdmeters,supermn,sdmeters,supersd);

set(h1, 'Marker','*')
set(h2, 'Marker','+')
grid on
legend('Mean of Means','Standard Deviation')
title('Simulation of Errors in Locating Control Points on 1835 Chart')
xlabel('Standard Deviation  of x and y Offsets on 1835 Chart Relative to Modern, m')
set(get(ax(1),'Ylabel'),'String','Mean Difference in Depth, 1835-2011, Mean of Means, m ') 
set(get(ax(2),'Ylabel'),'String','Standard Deviation of Means, m') 
    
%   Estimate random uncertainties from independent positions errors in
%   soundings

mndzc = zeros(ntrials,length(sdmeters));
ndz = zeros(ntrials,length(sdmeters));
for j=1:length(sdmeters);

    sfac = sqrt(abcd1835(1)^2 +abcd1835(2)^2);
    n =length(xyz1835(:,1));

    for i=1:ntrials
        [ dx dy ] = random_offsets(0,sdmeters(j),sfac,n);
        p = xyz1835(:,1) + dx;
        q = 7271 - xyz1835(:,2) + dy;
        
        [ xr yr ] = helmert( p,q,p01835,q01835,x01835,y01835,abcd1835);
        [dz mndz mndzc(i,j) sddz ndz(i,j)] = compare_depthsv2(Fgpostc,Xa,Ya,Zgpostc,xr,yr,zpix,1,xcon,ycon,dDz1835,0,[],[] );
    end
    
end

supermn = mean(mndzc)
supersd = std(mndzc)
supern = mean(ndz)
    
figure
[ax,h1,h2] = plotyy(sdmeters,supermn,sdmeters,supersd);

set(h1, 'Marker','*')
set(h2, 'Marker','+')
grid on
legend('Mean of Means','Standard Deviation')
title('Simulation of Independent Position Errors on 1835 Chart')
xlabel('Standard Deviation  of x and y Offsets in Soundings on 1835 Chart, m')
set(get(ax(1),'Ylabel'),'String','Mean Difference in Depth, 1835-2011, Mean of Means, m ') 
set(get(ax(2),'Ylabel'),'String','Standard Deviation of Means, m') 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   1886

%   Estimate systematic uncertainty owing to georeferencing

mndzc = zeros(ntrials,length(sdmeters));
mndzct = zeros(ntrials,length(sdmeters));
ndz = zeros(ntrials,length(sdmeters));
abcdr =zeros(ntrials,length(sdmeters),4);

for j=1:length(sdmeters);

    xpix = xyz1886(:,1);
    ypix = 4214 - xyz1886(:,2);
    zpix     = z1886m;
    
    sfac = sqrt(abcd1886(1)^2 +abcd1886(2)^2);
    n =length(p1886);

    for i=1:ntrials
        [ dx dy ] = random_offsets(0,sdmeters(j),sfac,n);
        p = p1886' + dx;
        q = q1886' + dy;
        
        [abcdrhold x0r y0r p0r q0r rmsr flag] = findhelmert( t,u,p,q );
        
        abcdr(i,j,1)  = abcdrhold(1);
        abcdr(i,j,2)  = abcdrhold(2);
        abcdr(i,j,3)  = abcdrhold(3);
        abcdr(i,j,4)  = abcdrhold(4);
        [ xr yr ] = helmert( xpix,ypix,p0r,q0r,x0r,y0r,abcdrhold);
        [dz mndz mndzc(i,j) sddz ndz(i,j)] = compare_depthsv2(Fgpostc,Xa,Ya,Zgpostc,xr,yr,zpix,1,xcon,ycon,dDz1886,0,[],[] );
    end
    
end


supermn = mean(mndzc)
supersd = std(mndzc)
supern = mean(ndz)
    
    
figure
[ax,h1,h2] = plotyy(sdmeters,supermn,sdmeters,supersd);

set(h1, 'Marker','*')
set(h2, 'Marker','+')
grid on
legend('Mean of Means','Standard Deviation')
title('Simulation of Errors in Locating Control Points on 1886 Chart')
xlabel('Standard Deviation  of x and y Offsets on 1886 Chart Relative to Modern, m')
set(get(ax(1),'Ylabel'),'String','Mean Difference in Depth, 1886-2011, Mean of Means, m ') 
set(get(ax(2),'Ylabel'),'String','Standard Deviation of Means, m') 
    
%   Estimate random uncertainties from independent positions errors in
%   soundings

mndzc = zeros(ntrials,length(sdmeters));
ndz = zeros(ntrials,length(sdmeters));

for j=1:length(sdmeters);

    sfac = sqrt(abcd1886(1)^2 +abcd1886(2)^2);
    n =length(xyz1886(:,1));

    for i=1:ntrials
        [ dx dy ] = random_offsets(0,sdmeters(j),sfac,n);
        p = xyz1886(:,1) + dx;
        q = 4214 - xyz1886(:,2) + dy;
        
        %[abcdr x0r y0r p0r q0r rmsr] = findhelmert( r,s,p,q );
        [ xr yr ] = helmert( p,q,p01886,q01886,x01886,y01886,abcd1886);
        [dz mndz mndzc(i,j) sddz ndz(i,j)] = compare_depthsv2(Fgpostc,Xa,Ya,Zgpostc,xr,yr,zpix,1,xcon,ycon,dDz1886,0,[],[] );
    end
    
end

supermn = mean(mndzc)
supersd = std(mndzc)
supern = mean(ndz)
    
figure
[ax,h1,h2] = plotyy(sdmeters,supermn,sdmeters,supersd);

set(h1, 'Marker','*')
set(h2, 'Marker','+')
grid on
legend('Mean of Means','Standard Deviation')
title('Simulation of Independent Position Errors on 1886 Chart')
xlabel('Standard Deviation  of x and y Offsets in Soundings on 1886 Chart, m')
set(get(ax(1),'Ylabel'),'String','Mean Difference in Depth, 1886-2011, Mean of Means, m ') 
set(get(ax(2),'Ylabel'),'String','Standard Deviation of Means, m') 




