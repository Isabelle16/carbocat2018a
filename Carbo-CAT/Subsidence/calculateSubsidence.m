function [glob] = calculateSubsidence(glob, subs, iteration)

% Apply uniform subsidence to all previous layers of strata

for k=1:iteration % Subside all layers

glob.strata(:,:,k) = glob.strata(:,:,k) - subs.subsidence(:,:,iteration);

end




