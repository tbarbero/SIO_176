% Tyler Barbero
% SIO 176
% ARGO-Part2
clear all;
%% Load Data
argo = load('~/Desktop/SIO176/HW7/float5903390.mat')
lat = argo.latitude(1,:);
lon = argo.longitude(1,:);
sal = argo.salinity(:,:);
pres = argo.pressure(1,:);
temp = argo.temperature(:,:);
date = argo.date(1,:);
p_ref=0;
SA = gsw_SA_from_SP(sal,pres,lon',lat');
PT = gsw_pt_from_t(SA,temp,pres,p_ref);
CT = gsw_CT_from_pt(SA,PT);
sig = gsw_sigma0(SA,CT);

% create empty array to get indexes of specific date interval
date_org = strings(length(argo.date),1);
for i=1:length(date_org)
    date_org(i) = datestr(date(i));
end
clear i;
%% Plot trajectory
m_proj('mercator','lat',[45 65],'long',[-75 -20]);
m_coast('patch',[.7 .7 .7],'edgecolor','r');
h=m_line(lon(1),lat(1),'marker','o','color','k','linewi',0.2,'linest','none','markersize',2,'markerfacecolor','blue');
%h=m_line(lon(316),lat(316),'marker','o','color','k','linewi',0.2,'linest','none','markersize',2,'markerfacecolor','blue');
m_grid('linestyle','none','tickdir','out','linewidth',3);
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.1, 0.07, 0.8, 0.75]);
m_line(lon,lat,'linewi',0.2,'color','r');
%% Pcolor: CT vs Time
figure(1)
pcol = pcolor(date,pres,PT');
set(pcol, 'EdgeColor', 'none');
s.FaceColor = 'interp';
set(gca,'YDir','reverse')
xlabel('Time')
ylabel('Pressure (dbar)')
title('Conservative Temperature vs Time at All Depths')
datetick('x','mmmYY','keeplimits')
a=colorbar
colormap Jet;
a.Label.String = '(^oC)'
% put contours
hold on;
contour(date,pres,CT','k');
saveas(gcf,'PcolorCT.png')
%   h.LevelList=round(h.LevelList,1);  %rounds levels to 3rd decimal place
%   clabel(c,h);
%% Pcolor: Absolute Salinity vs Time
figure(2)
pcol = pcolor(date,pres,SA');
set(pcol, 'EdgeColor', 'none');
s.FaceColor = 'interp';
set(gca,'YDir','rev')
xlabel('Time')
ylabel('Pressure (dbar)')
title('Absolute Salinity vs Time at All Depths')
datetick('x','mmmYY')
a=colorbar
a.Label.String = '(g/kg)'
% put contours
hold on;
contour(date,pres,SA','k');
saveas(gcf,'PcolorSal.png')
%% CT vs Time (anomaly)
figure(3)
pcol = pcolor(date(103:174),pres,PT(103:174,:)');
set(pcol, 'EdgeColor', 'none');
s.FaceColor = 'interp';
set(gca,'YDir','reverse')
ylim([0 800])
xlabel('Time')
ylabel('Pressure (dbar)')
title('Conservative Temperature vs Time at All Depths [2014-2016]')
datetick('x','mmmYY','keeplimits')
a = colorbar
a.Label.String = ('(^oC)')
colormap Jet;
% put contours
hold on;
contour(date,pres,PT',15,'k');
saveas(gcf,'CTanomaly.png')
%% SA vs Time (anomaly)
figure(4)
pcol = pcolor(date(103:174),pres,SA(103:174,:)');
set(pcol, 'EdgeColor', 'none');
s.FaceColor = 'interp';
set(gca,'YDir','reverse')
ylim([0 800])
xlabel('Time')
ylabel('Pressure (dbar)')
title('Absolute Salinity vs Time at All Depths [2014-2016]')
datetick('x','mmmYY','keeplimits')
a = colorbar
a.Label.String = ('(g/kg)')
colormap Jet;
% put contours
hold on;
contour(date,pres,SA',15,'k');
saveas(gcf,'SAanomaly.png')
%% plot TS Diagram
figure(5)
sx = [33:.1:36];
ty = [-3:.1:15];
[S,T] = meshgrid(sx,ty);
rho = gsw_rho(S,T,p_ref);
PDEN = round(rho-1000,2);
contour(S,T,PDEN,[24:0.5:28.5],'k','ShowText','on');
hold on;
scatter(SA(:),PT(:),'filled');
xlabel('Absolute Salinity (psu)')
ylabel('Potential Temperature (^oC)')
title('TS Diagram')
% %% make 316,400 pressure matrix
% pres1 = []
% for i=1:316
%     pres1 = [pres1; pres];
% end
% clear i
%% Trying to interpolate MLD-null values (Sigma)
MLDsig = [];
for i=3:316
    for j=3:399
        a = sig(i,3);
        b = abs(a-sig(i,j+1));
        if b<=0.1
            continue % next j-iteration
        elseif b>0.1
            MLDsig = [MLDsig pres(j)];
            break;
        else
            continue % next j-iteration
        end 
    end
    fakematrix = zeros(1,i-2); % size of fakematrix=(1,1)
    % interpolate here
    interpolatedvalSIG = ((pres(j)+pres(j+1))/2);
    if size(MLDsig) == size(fakematrix) % if size = size then do this
        MLDsig = [MLDsig interpolatedvalSIG];
    end
end
MLDsig = [MLDsig interpolatedvalSIG];
clear i
clear j
%% Trying to interpolate MLD-null values (PT)
MLDpt = [];
for i=3:316
    for j=3:399
        a = PT(i,3);
        b = abs(a-PT(i,j+1));
        if b<=0.2
            continue % next j-iteration
        elseif b>0.2
            MLDpt = [MLDpt pres(j)];
            break;
        else
            continue % next j-iteration
        end
    end
    fakematrix = zeros(1,i-2);
    %interpolate here
    interpolatedvalPT = ((pres(j)+pres(j+1))/2);
    if size(MLDpt) == size(fakematrix)
        MLDpt = [MLDpt interpolatedvalPT];
    end
end
MLDpt = [MLDpt interpolatedvalPT];
clear i
clear j
%% MLD on SAL
figure(7)
contourf(date,pres,SA');
hold on
scatter(date,MLDpt','filled','blue');
scatter(date,MLDsig','filled','red');
% plot(date,MLDpt','blue','linewidth',2);
% plot(date,MLDsig','red','linewidth',2)

set(gca,'YDir','rev');
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.1, 0.07, 0.8, 0.75]);
title('MLD on Absolute Salinity vs Time at All Depths')
xlabel('Time')
ylabel('Pressure (dbar)')
%ylim([0 700]);
datetick('x','mmmYY')
a = colorbar
a.Label.String = '(g/kg)'
legend('Salinity Contours','MLD-PT def','MLD-sigma0 def','location','southwest')
saveas(gcf,'MLDonSAL.png')
%% MLD on PT
figure(8)
contourf(date,pres,PT');
hold on
scatter(date,MLDpt','filled','blue');
scatter(date,MLDsig','filled','red');
% plot(date,MLDpt','blue','linewidth',2);
% plot(date,MLDsig','red','linewidth',2)

set(gca,'YDir','rev');
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.1, 0.07, 0.8, 0.75]);
title('MLD on Potential Temperature vs Time at All Depths')
xlabel('Time')
ylabel('Pressure (dbar)')
%ylim([0 700]);
datetick('x','mmmYY')
a = colorbar
a.Label.String = '(^oC)'
legend('Salinity Contours','MLD-PT def','MLD-sigma0 def','location','southwest')
saveas(gcf,'MLDonPT.png')

%% Plot anamoly + MLD
figure(8)
contourf(date(103:174),pres,SA(103:174,:)');
set(gca,'YDir','rev');
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.1, 0.07, 0.8, 0.75]);
title('MLD on Absolute Salinty vs Time at All Depths (2014-2016)')
xlabel('Time')
ylabel('Pressure (dbar)')
% ylim([0 700]);
datetick('x','mmmYY')
a = colorbar
a.Label.String = '(g/kg)'
hold on
scatter(date(103:174),MLDpt(103:174)','blue','filled')
scatter(date(103:174),MLDsig(103:174)','red','filled')
plot(date(103:174),MLDpt(103:174)','blue','linewidth',2)
plot(date(103:174),MLDsig(103:174)','red','linewidth',2)
legend('Salinity Contours','MLD-PT def','MLD-sigma0 def','location','southwest')
saveas(gcf,'MLD Anomaly.png')
%%  Plot anamoly + MLD
figure(9)
pcol = pcolor(date(103:174),pres,sig(103:174,:)');

set(pcol, 'EdgeColor', 'none');
s.FaceColor = 'interp';
set(gca,'YDir','rev');
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.1, 0.07, 0.8, 0.75]);
title('Potential Density vs Time Overlay MLDs (2014-2016)')
xlabel('Time')
ylabel('Pressure (dbar)')
% ylim([0 700]);
datetick('x','mmmYY')
a = colorbar
a.Label.String = '(kg/m3)'
hold on
contour(date,pres,sig','k');
scatter(date(103:174),MLDpt(103:174)','blue','filled')
scatter(date(103:174),MLDsig(103:174)','red','filled')
plot(date(103:174),MLDpt(103:174)','blue','linewidth',0.5)
plot(date(103:174),MLDsig(103:174)','red','linewidth',0.5)
legend('','Salinity Contours','MLD-PT def','MLD-sigma0 def','location','southeast')
saveas(gcf,'SIGvTimeOverlayMLD.png')