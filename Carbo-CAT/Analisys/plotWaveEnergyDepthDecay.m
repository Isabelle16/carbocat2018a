function plotWaveEnergyDepthDecay
close all;
clear all;
clc;

ff = figure(20);

% calculate the exponential decrease of wave energy with water depth
% general equation: 
% y = f(x); f(x) = a(1-r)^x   where: a = initial value; 
%                                    r = growth/decay rate;
%                                    x = step
%
% In our case:  energy(z) = maxEnergy*(1-r)^z
maxDepth = 70;
z = 0:1:maxDepth;
energy = zeros(maxDepth);
maxEnergy = 10000;
r = 0.08; % r is consistent with a wave base of 60 meters 

energy1 = maxEnergy*(1-r).^z;
energy2 = 8000*(1-r).^z;
energy3 = 6000*(1-r).^z;
energy4 = 4000*(1-r).^z;
energy5 = 2000*(1-r).^z;

plot(z,energy1,z,energy2,z,energy3,z,energy4,z,energy5,'LineWidth',2.5);
% axis ij
ylabel('Energy Density (J/m^3)');
xlabel('Water Depth (m)');
axis tight 
grid on;
   set(gca,'FontSize',35)

% set figure position and dimension
width = 85;     % Width in inches
height = 85;    % Height in inches
set(ff, 'Position', [0.5 0.5 width*15, height*15]); %<- Set size



%% Save image using save_fig
set(ff,'Color','none'); % set transparent background
set(gca,'Color','none');
% 
export_fig( sprintf('WaveEnergyDecay %d',1),...
   '-png', '-transparent', '-m12', '-q101');
       
   
   
   
   
   
   
   







end