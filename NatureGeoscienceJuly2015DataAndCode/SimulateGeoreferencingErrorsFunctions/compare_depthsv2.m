function [dz mndz mndzc sddz ndz zest] = compare_depthsv2_2015(F,X,Y,Z,x,y,z,ipoly,xpoly,ypoly,dDz,iplot,bins,plottitle )
%   Used in Nature Geoscience paper, July, 2015
%   Rob Wesson

%   F,X,Y,Z model
%   x,y,z data
%   if ipoly ==1, calculate statistics only for obs within poy defined by
%   xpoly,ypoly
%   dDz, correction for tidal datum and truncation
%   if iplot == 1, plot residuals and histogram to plot titled 'plotttitle'

%   set constants
contours = [0 -1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12 -13 -14 -15 -16 -17 -18 -19 -20 -21 -22 -23 -24 -25 -26 -27 -28 -29 -30 -31 -32 -33];
formatSpec = '%3.2f\n';
formatSpec2 = '%3d\n';
dDz =0;

%   calculate dx and statistics
zest = F(x,y);
dz = z - zest;
if ipoly ==1
    ip = inpolygon(x,y,xpoly,ypoly);
    in = find(ip==1 & ~isnan(dz));
else
    in = ~isnan(dz);
end
mndz = mean(dz(in));
sddz = std(dz(in));
ndz = length(dz(in));
%mndzc = mndz + dDz;
mndzc = mndz;
ddz = dz - mndz;


%   if desired, make plot

if iplot == 1
    figure
    axes('position',[0.1 .1 .55 .7])
    [C hc] =  contour(X,Y,-Z,contours);
    hcl = clabel(C,hc, [0 -5 -10 -15 -20 -25 -30]);
    set(hcl,'FontSize',5)
    xlim([6.315e5 6.395e5])
    ylim([5.893e6 5.9e6])
    axis equal
    hold on
    if ipoly ==1
        plot(xpoly,ypoly,'k')
    end
    for i=1:length(ddz)
        if(isnan(ddz(i)))
            plot(x(i),y(i),'k*')
        else
            t1 = text(x(i),y(i),num2str(ddz(i),formatSpec));
            set(t1,'FontSize',5)
            hold on
            if (abs(ddz(i))>2)
                h1=plot(x(i),y(i),'ro');
                set(h1,'Markersize',14)
            end
        end
    end
    histdz = hist(dz(in)+dDz,bins);
    %figure
    %subplot(1,2,2)
    %title('')
    title(plottitle)

    axes('position',[.75 .2 .2 .6])
    ylim([-6 6])
    hb= barh(bins,histdz*100/sum(histdz))
    set(gca,'YDir','reverse')
    ylabel('Difference in Depth, m (relative to 2011, down is deeper)')
    hold on 
    text(3,5,['Mean* = ',num2str(mndz+dDz,formatSpec)])
    text(3,7,['S.E.M. =',num2str(sddz/sqrt(ndz),formatSpec)])
    text(3,9,['n =',num2str(ndz,formatSpec2)])
    xlabel('Percent')
    text(2,14,'*Data adjusted')
    text(2,15,'for tidal datum and ')
    text(2,16,['truncation, \Delta d =',num2str(dDz,formatSpec)])
    ylim([-10 10])
    grid on
    set(gcf,'PaperOrientation', 'landscape')
    print -depsc2
end

end

