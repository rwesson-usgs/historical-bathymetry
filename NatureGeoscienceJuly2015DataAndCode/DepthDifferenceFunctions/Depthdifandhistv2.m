function [meandz,stddz,ndz,steofmean,uncormeandz] = Depthdifandhist(F,X,Y,Z,xp,yp,x,y,zc,dDz,plottitle)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
bins = -10:.1:10;
contours = [0 -1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12 -13 -14 -15 -16 -17 -18 -19 -20 -21 -22 -23 -24 -25 -26 -27 -28 -29 -30 -31 -32 -33];
formatSpec = '%3.2f\n';
formatSpec2 = '%3d\n';

ip = inpolygon(x,y,xp,yp);
zpred = F(x,y);
dz = zc - zpred;

meandz = mean(dz(ip))
uncormeandz = meandz - dDz;
stddz = std(dz(ip))
ndz = length(dz(ip))
steofmean = std(dz(ip))/sqrt(ndz)
ddz = dz - meandz;

   figure
    axes('position',[0.1 .1 .55 .7])
    
   %    make legend
   h0 = plot(6.39e5,5.8995e6,'k*');
   hold on
   h1 = plot(6.39e5,5.8995e6,'ko');
   set(h1,'Markersize',10)
   set(h1,'MarkerFaceColor','r')
   
   h2 = plot(6.39e5,5.8995e6,'ko');
   set(h2,'Markersize',7)
   set(h2,'MarkerFaceColor','r')
   
   h3 = plot(6.39e5,5.8995e6,'ko');
   set(h3,'Markersize',5)
   set(h3,'MarkerFaceColor','k')

   h4 = plot(6.39e5,5.8995e6,'ko');
   set(h4,'Markersize',7)
   set(h4,'MarkerFaceColor','g')

   h5 = plot(6.39e5,5.8995e6,'ko');
   set(h5,'Markersize',10)
   set(h5,'MarkerFaceColor','g')

   legend('Outside Model','r<-1.5 m','-1.5,r,-0.5','-0.5<r<0.5','0.5<r<1.5','r>1.5','Location',[0.54 0.685 0.07 0.07])
   
    [C hc] =  contour(X,Y,-Z,contours);
    hcl = clabel(C,hc, [0 -5 -10 -15 -20 -25 -30]);
    set(hcl,'FontSize',5)
    xlim([6.315e5 6.395e5])
    ylim([5.893e6 5.9e6])
    axis equal
    hold on
    
   
    plot(xp,yp,'k')
    
   for i=1:length(ddz)
        if(isnan(ddz(i)))
            plot(x(i),y(i),'k*')
        end
        if ddz(i) > -0.5 & ddz(i) < 0.5
            h1=plot(x(i),y(i),'ko');
            set(h1,'MarkerFaceColor','k')
            set(h1,'Markersize',5)
        end
        if ddz(i )> -1.5 & ddz(i) < -0.5
            h1=plot(x(i),y(i),'ko');
            set(h1,'Markersize',7)
            set(h1,'MarkerFaceColor','r')
        end
        if ddz(i) >  0.5 & ddz(i) < 1.5
            h1=plot(x(i),y(i),'ko');
            set(h1,'Markersize',7)
            set(h1,'MarkerFaceColor','g')
        end
        if ddz(i) < -1.5
            h1=plot(x(i),y(i),'ko');
            set(h1,'Markersize',10)
            set(h1,'MarkerFaceColor','r')
        end
        if ddz(i) > 1.5
            h1=plot(x(i),y(i),'ko');
            set(h1,'Markersize',10)
            set(h1,'MarkerFaceColor','g')
        end
    end
    histdz = hist(dz(ip),bins);
    %figure
    %subplot(1,2,2)
    %title('')
    title(plottitle)
    xlabel('UTM Easting, m')
    ylabel('UTM Northing, m')


    axes('position',[.75 .2 .2 .6])
    ylim([-6 6])
    hb= barh(bins,histdz*100/sum(histdz))
    set(gca,'YDir','reverse')
    ylabel('Difference in Depth, m (relative to 2011, down is deeper)')
    hold on 
    text(3,5,['Mean* = ',num2str(meandz,formatSpec)])
    text(3,7,['S.E.M. =',num2str(stddz/sqrt(ndz),formatSpec)])
    text(3,9,['n =',num2str(ndz,formatSpec2)])
    xlabel('Percent')
    text(2,14,'*Data adjusted')
    text(2,15,'for tidal datum and ')
    text(2,16,['truncation, \Delta d =',num2str(dDz,formatSpec)])
    ylim([-10 10])
    grid on
    xlim([0 20])
    set(gcf,'PaperOrientation', 'landscape')
    print -depsc2
end

