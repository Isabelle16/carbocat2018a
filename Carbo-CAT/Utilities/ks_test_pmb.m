function [D,Dx,p] = ks_test_pmb(F1, x1, F2, x2)

n1 = length(F1);
nx1 = length(x1);
n2 = length(F2);
nx2 = length(x2);

% Trap any problems with different vector lengths
if n1 ~= n2
    fprintf('Length of function vectors are different: %d %d\n', n1, n2);
    p=-1;
    return;
end

if nx1 ~= nx2
    fprintf('Length of xcoord vectors are different: %d %d\n', nx1, nx2);
    p=-1;
    return;
end

if n1 ~= nx1 | n2 ~= nx2
    fprintf('Length of function vectors and xcoord vectors are different: %d %d and %d %d\n', n1, nx1, n2, nx2);
    p=-1;
    return;
end

D=0;
Dx = 0;
for i=1:n1
    if (abs(F1(i) - F2(i)) > D)
        D = abs(F1(i) - F2(i));
        Dx = i;
    end
end

lamda =(sqrt(n1)+0.12+0.11/sqrt(n1))* D;
for i=1:30
    Qks(i) = power(-1, i-1) * exp((-2)*i*i*lamda*lamda);
end

Qks;
p = 2*sum(Qks);



