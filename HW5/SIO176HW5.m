%% Header
% Tyler Barbero
% SIO 176 
% HW 5
% TEOS-Routines
%% Load data
load CTD57.mat;
load CTD57_RBR065584.mat;
lat = 65.9;
long = -37.9;
%% Convert files
SP = gsw_SP_from_C(cond,temp,pres);
SA = gsw_SA_from_SP(SP,pres,long,lat);
PT = gsw_pt0_from_t(SA,temp,pres);
CT = gsw_CT_from_pt(SA,PT);
SP1 = gsw_SP_from_C(condrbr,temprbr,presrbr);
SA1 = gsw_SA_from_SP(SP1, presrbr,long,lat);
PT1 = gsw_pt0_from_t(SA1,temprbr,presrbr);
CT1 = gsw_CT_from_pt(SA1,PT1);
%% Summary of functions:
% convert to practical salintiy from conductivity
%gsw_SP_from_C(cond,temp,pres)
% convert to absolute salinity from practical salinity
%gsw_SA_from_SP(SP,pres,long,lat)
% convert to potential temperature_knot from absolute salinity
%gsw_pt0_from_t(SA,temp,pres)
% convert to conservative temperature from potential temperature
%gsw_CT_from_pt(SA,PT)
% derive in-situ density from absolute salinity and conservative
% temperature, pressure)
%gsw_rho(SA,CT,pres)
% derive potential density from reference 0 dbar
%sigma0 = gsw_sigma0(SA,CT)
% derive height from pressure
%height = gsw_z_from_p(p,lat,{geo_strf_dyn_height},{sea_surface_geopotental})
% derive depth from height
%depth = gsw_depth_from_z(z) z = height
%% Plots!!!

%% In situ Temperature, Potential Temperature, Conservative Temperature versus pressure
figure(1);
hold on;
plot(temp,pres);
plot(PT,pres);
plot(CT,pres);
plot(temprbr,presrbr);
plot(PT1,presrbr);
plot(CT1,presrbr);
set(gca, "Ydir", 'reverse')
xlabel('Temperature [\circC]')
ylabel('Pressure [dbar]')
title('Temperatures vs Pressure for SB and RBR CTDs')
legend({'In-Situ Temperature(SB)','PT(SB)','CT(SB)','In-Situ Temperature(RBR)','PT(RBR)','CT(RBR)'},'location','Southwest');
grid on;
saveas(gcf,'~/Desktop/SIO176/HW5/fig1.png')
%% Conductivity versus pressure.
figure(2);
hold on
plot(cond,pres, 'c');
plot(condrbr,presrbr, 'r')
xlabel('Conductivity [mS/cm]')
ylabel('Pressure [dbar]')
title('Conductivity vs Pressure for SB and RBR CTDs')
legend({'Conductivity(SB)','Conductivity(RBR)'},'location','Southwest')
set(gca, 'Ydir', 'r')
grid on;
saveas(gcf,'~/Desktop/SIO176/HW5/fig2.png')
%% Practical salinity and Absolute salinity, versus pressure
figure(3);
hold on;
plot(SP,pres);
plot(SA,pres);
plot(SP1,presrbr);
plot(SA1,presrbr);
xlabel('Salinity [psu g/kg]')
ylabel('Pressure [dbar]')
title('Practical and Absolute Salinity vs Pressure for SB and RBR CTDs')
legend({'Practical Salinity(SB)','Absolute Salinity(SB)','Practical Salinity(RBR)','Absolute Salinity(RBR)'},'location', 'Southwest');
set(gca, 'ydir', 'r')
grid on;
saveas(gcf,'~/Desktop/SIO176/HW5/fig3.png')
%% Potential Temperature versus Practical Salinity diagram, overlaying potential density lines.
figure(4)
% create density contour overlay
sx = [30:.1:36];
ty = [-2:.1:5];
[S,T] = meshgrid(sx,ty);
% derive rho values
p_ref = 0;
rho = gsw_rho(S,T,p_ref);
% convert to potential density from in-situ rho
PotDEN = round(rho-1000,2);
contour(S,T,PotDEN, [24:28],'k','ShowText','on');
hold on;
scatter(SP,PT,25,'filled');
scatter(SP1,PT1,25,'filled');
xlim([30 36])
ylim([-2 5])
xlabel('Salinity (g/kg)')
ylabel('Temperature (^oC)')
title('TS Plot Overlay Density Contours for SB and RBR CTDs')
legend({'Density Contours','TS Data(SB)','TS Data(RBR)'},'location','Southwest')
grid on;
saveas(gcf,'~/Desktop/SIO176/HW5/fig4.png')
%% Plot Potential Density vs Depth (figure 5)
figure(7)
height = gsw_z_from_p(pres,lat);
depth = gsw_depth_from_z(height);
PD = gsw_sigma0(SA,CT)
plot(PD,depth)
set(gca, 'ydir', 'r')
xlabel('\sigma_0 (kg/m^3)')
ylabel('Depth (m)')
ylim([-10 700])
title('Potential Density vs Depth')
grid on
saveas(gcf,'~/Desktop/SIO176/HW5/fig7.png')
%% Consider SB Data for TS plot, Try to shift temp, conductivity data
%after shift non zoom
figure(5)
condshift = cond(1:end-1); % changing dimensions tomatch temp shift
tempshift = temp(2:end); % delaying temp one step
presshift = pres(1:end-1); % changing dimensions tomatch temp shift
SPshift = gsw_SP_from_C(condshift,tempshift,presshift); 
SAshift = gsw_SA_from_SP(SPshift,presshift,long,lat);
PTshift = gsw_pt0_from_t(SAshift,tempshift,presshift);
contour(S,T,PotDEN,[24:28],'k','ShowText','on');
hold on
scatter(SP,PT,25,'filled');
scatter(SPshift,PTshift,25,'filled');
xlim([30 36])
ylim([-2 5])
xlabel('Salinity (g/kg)')
ylabel('Temperature (^oC)')
title('TS Plot Overlay Density Contours for SB CTD (non-shift vs shift)')
legend({'Potential Density Contours','TS Data(SB)','TS Data Shifted(SB)'},'location','Southwest')
grid on
saveas(gcf,'~/Desktop/SIO176/HW5/fig5.png')
%% Zoomed in version after shift (5)
figure(6)
contour(S,T,PotDEN,[24:28],'k','ShowText','on');
hold on
scatter(SP,PT,25,'filled');
scatter(SPshift,PTshift,25,'filled');
xlim([32.6 32.9])
ylim([0.5 1.7])
xlabel('Salinity (g/kg)')
ylabel('Temperature (^oC)')
title('TS Plot Overlay Density Contours for SB CTD (non-shift vs shift)(zoomed-in)')
legend({'Potential Density Contours','TS Data(SB)','TS Data Shifted(SB)'},'location','Southwest')
grid on
saveas(gcf,'~/Desktop/SIO176/HW5/fig6.png')