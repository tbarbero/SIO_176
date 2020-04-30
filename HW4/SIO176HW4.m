% Tyler Barbero
% SIO 176 
% HW 4 - TCM_LAB

clear all
%% Loading data and assigning values
load('TCM_Data.mat');
load('speed_start_stop.mat');
deg = TCM_degree;
time = datenum(TCM_time);
start = datenum(start_time);
stop = datenum(stop_time);

%% 1.
% Using the TCM Data, make a plot comparing the angle of tilt vs time.
% The x-axis can be a simple index (no x variable) or time.
figure(1)

plot(time,deg)
datetick
xlabel('Time (hh:mm)')
ylabel('Degree of tilt ({\circ})')
title('Degree of tilt vs Time for TCM Data')
saveas(gcf,'~/Desktop/SIO176/HW4/fig1.png')
% savefig('~/Desktop/SIO176/HW4/fig1')
%% 2a.
% Start with the first towing experiment done at 2 cm/s. Plot the angle of 
% tilt just in the time interval of this first experiment.

start1 = find(time == start(1));
stop1 = find(time == stop(1));
time1 = time(start1(1):stop1(16));
deg1 = deg(start1(1):stop1(16));
figure(2)
plot(time1,deg1)
datetick
xlabel('Time (hh:mm:ss)')
ylabel('Degree of Tilt ({\circ})')
title('Degree of tilt vs time for 2cm{s^{-1}} Trial')
saveas(gcf,'~/Desktop/SIO176/HW4/fig2a.png')
% savefig('~/Desktop/SIO176/HW4/fig2a') 
% Find the average degree of tilt for a speed of 2 cm/s.
avg1 = mean(deg1)
%% 2b.
% Now use all the towing experiment data. Calculate the average degree of 
% tilt for every experiment.
averages=[]
for i = 1:length(start)
    a = find(time == start(i));
    starts(i) = a(1);
    b = find(time == stop(i));
    stops(i) = b(length(b));
    times = time(starts(i):stops(i));
    degs = deg(starts(i):stops(i));
    figure(i);
    plot(times,degs);
    datetick
    xlabel('Time (hh:mm:ss)')
    ylabel('Degree of Tilt ({\circ})')
    title('Degree of tilt vs time for ith Trial')
    means = mean(degs)
    averages = [averages; means]    
end

% Produce a plot of speed vs degree. This is your calibration curve!
% Describe its features.

plot(speed, averages)
xlabel('Speeds (cms^{-1})')
ylabel('Degree of Tilt ({\circ})')
title('Speed vs Average Tilt -- Calibration Curve')
saveas(gcf,'~/Desktop/SIO176/HW4/fig2b.png')