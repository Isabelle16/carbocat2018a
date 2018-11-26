
fprintf('Partial vector method 1:\n');
test = [3 1 2; 6 4 5; 9 7 8]
x = 2; y = 2;
offsetX = [0,1,-1];
x1 = x + offsetX

for y1 = y-1:y+1
    answer = test(y1,x1)
end

% Problem with method 1 is how to exclude x=2 y=2 matrix center point?


fprintf('Partial vector method 2:\n');
%test = [3 1 2; 6 4 5; 9 7 8]
test = [1 2 3; 4 5 6; 7 8 9]

x = [2 3 1];
test(:,x)



fprintf('Index array vectored method 1:\n');
test = [1 2 3; 4 5 6; 7 8 9]

xInc = [0 1 -1 1 -1 0 1 -1];
yInc = [-1 -1 -1 0 0 1 1 1];
x=2; y=2;
k=1:8;
test(y+yInc(k),x+xInc(k))


fprintf('Index array loop method 1:\n');
test = [1 2 3; 4 5 6; 7 8 9]

xInc = [0 1 -1 1 -1 0 1 -1];
yInc = [-1 -1 -1 0 0 1 1 1];
x=2; y=2;
for k=1:8
    fprintf('%d ',test(y+yInc(k),x+xInc(k)));
end


