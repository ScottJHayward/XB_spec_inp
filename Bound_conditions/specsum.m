function [date, bw, Dat, f] = specsum(fname,line,shift);
%for DATA_spec, SKIP=1, otherwise, SKIP=0    
%line tells which line to read 

%bw=bandwidth
%Dat=data from file of interest... could be Energy, A1, R1, etc. 
%f=frequency

fid=fopen(fname,'r');

%skip unwanted lines
if line>1
    for i=1:line-1
        fgetl(fid);
    end
end
fgetl(fid);  

%read in Data
H=str2num(fgetl(fid));

%[year, month, day, hour, minute]
date=H(1:5);

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