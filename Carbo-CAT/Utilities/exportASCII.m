function exportASCII(glob,iteration,variable,FName)

output=ascii_type(glob.ySize,glob.xSize);

% variable=glob.strata(:,:,1:iteration);
% variableName='strata';

length=uint64(glob.xSize*glob.ySize);
exportVariable=variable(:,:,1);
lala=reshape(exportVariable,[length,1]);
output(1:length,3)=lala;

start=zeros(1,1,'uint64');
ends=zeros(1,1,'uint64');
start=start+length+1;
ends=ends+length*2;

for t=2:iteration
    output(start:ends,1:2)=output(1:length,1:2);
    exportVariable=variable(:,:,t);
    lala=reshape(exportVariable,[length,1]);
    output(start:ends,3)=lala;
    start=ends+1;
    ends=start-1+(length);

end

% FName = sprintf('exportASCII_%s.txt', variableName);

save(FName,'-ASCII','output');
end