function [yArray,xArray,length]=calculateNeighbourCellsFromRadius(r,leaveOut)
%calculate y and x array with the shape [-1 1 0 -1 1] so it can be visited
%by the CA or other routines. 
%r is the radius, leaveOut is the inner radius we want to leave out. make
%it 0 if you want to include everycell, 1 if the center cell must be left
%out, 2 if the center and surrounding cells must be left out, etc...

yData_row=-r:r;

xData_column=-r:r;

sizeOfSide=2*r+1;
yData_grid=zeros(sizeOfSide);
xData_grid=zeros(sizeOfSide);

for c=1:sizeOfSide
yData_grid(c,:)=yData_row;
xData_grid(:,c)=xData_column;
end

%loop to store the indexes in the arrays
loopCount=1;
for yValue=1:sizeOfSide;
    for xValue=1:sizeOfSide;
        
        %check if the cell should be left outside
        posyData=abs(yData_grid(yValue,xValue));
        posxData=abs(xData_grid(yValue,xValue));
        if (posyData<=(leaveOut-1)) && (posxData<=(leaveOut-1))
        else
            yArray(loopCount)=yData_grid(yValue,xValue);
        
            xArray(loopCount)=xData_grid(yValue,xValue);
        
        loopCount=loopCount+1;
        
        end
    end
    
    length=size(yArray,2);
    
end