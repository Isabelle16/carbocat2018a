function [Lr] = calculateWaveLength(glob,g,WD,y,x,Ldeep,Li)

d = WD(y,x);
T = glob.wavePeriod;

if d > Li/2
    Lr = Ldeep;
else
    a = ((2*pi)*sqrt(d/g))/T;
    Lr = Ldeep*((real(tanh((a)^1.5)))^(2/3));
end

end

