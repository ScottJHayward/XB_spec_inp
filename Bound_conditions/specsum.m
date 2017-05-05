function [date, bw, Dat, f] = specsum(fname,shift);
%for DATA_spec, SKIP=1, otherwise, SKIP=0    
 
%bw=bandwidth
%Dat=data from file of interest... could be Energy, A1, R1, etc. 
%f=frequency

fid=fopen(fname,'r');
fgetl(fid);

% starts at Hour zero (AKA... now)
% 
%%%change later to incorporate 24 hours...

    
H=str2num(fgetl(fid));


%[year, month, day, hour, minute]
date=H(1:5);


%DATA_spec file is different, shift is equal to 6 in that instance. otherwise, it is 5. 
% shift=-1;
% if H(1,6)==9.999
% shift=0;
% end



%only choosing 25 bands for now, can change to 46 later...
skip=5;
for i=1:1:35
    
    
    %this might look rather complicated, but it simply fills in the wave info for each location
    Dat(i)=H(2*(i+skip)+shift);
    f(i)=H(2*(i+skip)+1+shift);
    bw(i)=H(2*(i+skip+1)+1+shift)-H(2*(i+skip)+1+shift);
    
end


fclose all


end