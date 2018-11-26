%% Generate timeline map and source to sink map 
clear all;
close all;
clc;

kk =1;
% 
% cd 'C:\Users\isabel16\Desktop\subsidenceMaps'

%% Load subsidence and select the desired area
% subs=load('C:\Users\isabel16\Desktop\SubsidenceMaps\subsidenceMap(HGHR_RRLR).mat');
% subs=load('C:\Users\isabel16\Desktop\SubsidenceMaps\subsidenceMap(HGLR_rotational).mat');
% subs=load('C:\Users\isabel16\Desktop\SubsidenceMaps\subsidenceMap(HGLR_RRHR).mat');
% subs.subsidence = subs.subsidence(190:300,123:203,:);
% subs.subsidence = subs.subsidence(315:370,5:145,:);


% crossSectionPlot=figure('Visible','off');
fig = figure(1);


% x = 40;
x = 78;
y = size(subs.subsidence,1);
z = size(subs.subsidence,3);

it  = z;

long = y;

glob.subsLineAge = [1:500:it];
glob.timeLineCount= size(glob.subsLineAge,2);  

zco = zeros(y,glob.timeLineCount);
ii = 1;
    for i=1:glob.timeLineCount
        

        k = glob.subsLineAge(i);

        if k <= it
     
            topog = sum(subs.subsidence(:,:,1:k),3).*-1;
            zco(:,ii) = topog(:,x);
            yco = 1:y;

%             line(yco,zco,  'LineWidth',2, 'color', 'red');
%             hold on
          ii = ii+1;
            
        end
        
    end
area(zco);
ylabel('Depth (m)','FontSize',24,'FontWeight','bold');
xlabel('y(km)','FontSize',24,'FontWeight','bold');
ax = gca;
ax.LineWidth = 0.6;
ax.FontSize = 20;
ax.FontWeight = 'bold';
xticks([1 10 20 30 40 50 60 70 80 90 100]);
xticklabels (0:2:20);
axis tight

    
%% General
% set figure position and dimension
width = 80;     % Width in inches
height = 80;    % Height in inches
set(fig, 'Position', [0.5 0.5 width*10, height*10]); %<- Set size


%% Save image using save_fig

set(fig,'Color','none'); % set transparent background
set(gca,'Color','none');

export_fig( sprintf('SubsidenceHistory'),... 
   '-png', '-transparent', '-m8', '-q101');
