function [ x0,y0,iout,jout,zi,zj,dz ] = intersections_diffs(xp,yp,x1,y1,z1,x2,y2,z2)
%   Used in Nature Geoscience paper, July, 2015
%   Rob Wesson
switch nargin
	case 5
        ip = inpolygon(x1,y1,xp,yp);
        x1 = x1(ip);
        y1 = y1(ip);
        z1 = z1(ip);
		[x0,y0,iout,jout] = intersections(x1,y1,1);
        x2 = x1;
        y2 = y1;
        z2 = z1;
	case 8
        ip = inpolygon(x1,y1,xp,yp);
        x1 = x1(ip);
        y1 = y1(ip);
        z1 = z1(ip);
        iq = inpolygon(x2,y2,xp,yp);
        x2 = x2(iq);
        y2 = y2(iq);
        z2 = z2(iq);
		[x0,y0,iout,jout] = intersections(x1,y1,x2,y2,1);
end
zi = [];
zj = [];
dz = [];
for i =1:length(x0);
    iseg = floor(iout(i));
    jseg = floor(jout(i));
    if (isnan(iseg) | isnan(jseg)|isnan(iseg+1)|isnan(jseg+1))
        zi(i) = NaN;
        zj(i) = NaN;
        dz(i) = NaN;
    else
        r1 = sqrt((x1(iseg+1)-x1(iseg))^2 + (y1(iseg+1) - y1(iseg))^2);
        r2 = sqrt((x2(jseg+1)-x2(jseg))^2 + (y2(jseg+1) - y2(jseg))^2);
        if (r1>100 | r2>100)
            zi(i) = NaN;
            zj(i) = NaN;
            dz(i) = NaN;
        else
            %i
            zi(i) = z1(iseg) + mod(iout(i),1)*(z1(iseg+1) - z1(iseg));
            zj(i) = z2(jseg) + mod(jout(i),1)*(z2(jseg+1) - z2(jseg));
            dz(i) = zj(i) - zi(i);
        end
    end
end
dz = dz(:);
figure
plot(dz,'or')
figure
plot(x1,y1,'.')
hold on
plot(x2,y2,'g.')
plot(x0,y0,'or')
for i=1:length(dz)
    if isnan(dz(i))
        plot(x0(i),y0(i),'xr')
    else
        %text(x0(i),y0(i),[num2str(zi(i),2) ',' num2str(zj(i),2) ',' num2str(dz(i),2)])
        text(x0(i)+10,y0(i)+10, num2str(dz(i),2))
    end
end
plot(xp,yp,'k--')
axis equal
grid on

