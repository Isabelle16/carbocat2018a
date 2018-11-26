% function [grads, maxSlope] = neighbourGradients(topog,glob, yco, xco)
% 
%     %% Calculate gradients between each model cell and its eight neighbours 
%      % grads(i,j,1): gradient between cell(i,j) and east cell(i,j+1) and so on
%      % clockwise.
%      
%     N = [0 -1;-1 -1;-1 0;-1 +1;0 +1;+1 +1;+1 0;+1 -1];  
%     [a, b] = size(topog); 
%     grads = zeros(a,b,8); 
%     maxSlope = zeros(yco, xco);
%     
%     for c = 2 : 2 : 8
%      grads(:,:,c) = (circshift(topog,[N(c,1) N(c,2)])-topog)/(sqrt(2)*glob.dx);  
%     end 
%     for c = 1 : 2 : 7
%      grads(:,:,c) = (circshift(topog,[N(c,1) N(c,2)])-topog)/glob.dx;
%     end
%     
%     %grads(1,:,:) = grads(2,:,:);
%     grads = atan(grads)/pi*2;  % negative gradients indicate outflow 
%     
%     dummyMaxSlope = grads;
%     dummyMaxSlope(dummyMaxSlope>0) = 0; % set inflow equal to zero
%     dummyMaxSlope = abs(dummyMaxSlope);
%     
%     
%     
%     
%     
%     for i = 1:yco
%         for j = 1:yco
%              maxSlope(i,j) = max(dummyMaxSlope(i,j,:));
%         end
%     end
%     
%     
%  end
