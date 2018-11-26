function [d]=ascii_type (a,b)
% it accepts two numbers (a,b) and creates the equivalent vectors (vec1,vec2). 
%It creates a matrix where all element of vec2 are paired with each element
%of vec1

vec1=1:a;
vec2=1:b;

size=length(vec1)*length(vec2);

d=zeros(size,2);

for i=1:length(vec2)
    for j=0:length(vec2):(size-length(vec2))
        d(i+j,:)=[vec1(1+(j/length(vec2))),vec2(i)];
    end
end

end
            