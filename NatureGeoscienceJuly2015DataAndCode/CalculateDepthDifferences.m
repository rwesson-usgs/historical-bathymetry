%   Calculate depth differences between aggregate post-earthquake model and
%   earlier surveys

%   Used in Nature Geoscience paper, July, 2015
%   Rob Wesson

clear 


path(path,'DepthDifferenceFunctions')
load AllPoly_v3
load HistoricalData/HistoricalData_georeferenced
load AggregateModel/GarminModelcor
load AggregateModel/CorrectedGarminData

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
z1886mc = z1886m + MTE1886 + CtoMSL + CforSLR1886;
z1835mc = z1835m + MTE1835 + CtoMSL + CforSLR1835;
z1804mc = z1804m + MTE1804 + CtoMSL + CforSLR1804;

dDz1804 = MTE1804 + CtoMSL + CforSLR1804;
dDz1835 = MTE1835 + CtoMSL + CforSLR1835;
dDz1886 = MTE1886 + CtoMSL + CforSLR1886;

'1804'

[meandz1804,stddz1804,ndz1804,steofmean1804,uncormeandz1804] = Depthdifandhistv2(Fgpostc,Xa,Ya,Zgpostc,xcon,ycon,xy1804utm(:,1),xy1804utm(:,2),z1804mc,dDz1804,'1804')



'1835'

[meandz1835,stddz1835,ndz1835,steofmean1835,uncormeandz1835] = Depthdifandhistv2(Fgpostc,Xa,Ya,Zgpostc,xcon,ycon,xy1835utm(:,1),xy1835utm(:,2),z1835mc,dDz1835,'1835')


'1886'

[meandz1886,stddz1886,ndz1886,steofmean1886,uncormeandz1886] = Depthdifandhistv2(Fgpostc,Xa,Ya,Zgpostc,xcon,ycon,xy1886utm(:,1),xy1886utm(:,2),z1886mc,dDz1886,'1886')


'January 2010'
[meandz2010,stddz2010,ndz2010,steofmean2010,uncormeandz2010] = Depthdifandhistv2(Fgpostc,Xa,Ya,Zgpostc,xcon,ycon,xgjan2010,ygjan2010,zgjan2010c,0,'January 2010')



