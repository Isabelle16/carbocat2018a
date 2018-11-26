function [q, c] = kstest(F1, x1, F2, x2, alpha)

% function [q, c] = kstest(F1, x1, F2, x2, alpha)
%
% Kolmogorov-Smirnov-Test for the distributions
% F1(x1) and F2(x2). The significance level 'alpha' can
% be omitted; it then defaults to 0.05.
% F1, x1, F2, x2 must all be vectors; F1 and x1 must
% be the same length, F2 and x2 must also be the same length.
% F1 and F2 must be strict monotonically ascending functions,
% i.e. every x-value is assigned a unique F-value and vice versa.
%
% To compare an empirical distribution with a 'true' distribution,
% set 'x2 = []' (empty matrix). Then, F1 and F2 must be the same 
% length and it is assumed that F2 is the 'true' distribution and 
% given at the points x1.
% 
% 'q' is the test value of the KS-Test, and 'c' is the value to 
% compare. E.g., let alpha be 0.05, and q > c, then we can say
% that the two compared distributions are different with a 
% probability of at least 0.95.
%
% F(x) = 0 for x < min{x}
% F(x) = 1 for x > max{x}
% This is true for empirical F's and a good approximation
% for sampled 'true' F's if the amount of samples N is
% large enough. 

% Rev.1.1, 09.02.2000 (Armin Günter: possibility to apply the test to
%    'true' distributions)
% Rev.1.2, 07.02.2001 (A.G.: Bug fixed: a program line was at
%    a wrong position)

% sort(A):
% For identical values in A, the location in the input array 
% determines location in the sorted list.

if ~exist('alpha', 'var')
   alpha = .05;
end

if isempty(x2)
   if length(F1(:)) ~= length(F2(:))
      error('F1 and F2 must be the same length. See help text.')
   end
   x2 = x1;
   n1 = length(x1(:));
   n2 = n1;
   L = n1;
else
   n1 = length(x1(:));
   n2 = length(x2(:));
   L = n1*n2/(n1+n2);
end

[x, Ix] = sort([x1(:); x2(:)]);
F = [F1(:); F2(:)];
F = F(Ix);
% values in x that belong to F2:
xx2 = Ix > n1;
% locations in x, where the following x
% belongs to the other F
jump = find(diff(xx2));
jump(end + 1) = jump(end) + 1;
% compare first values to zero
% because F(x) = 0 for x < min{x}
dF = F(1:jump(1));
for i = 1:length(jump)-1
   dF = [dF; abs(F(jump(i)) - F(jump(i)+1:jump(i+1))) ];
end
% compare last values to one
% because F(x) = 1 for x > max{x}
dF = [dF; 1 - F(jump(end):end)];
q = max(dF);

c = sqrt(-.5*log(.5*alpha)) / sqrt(L);

return
