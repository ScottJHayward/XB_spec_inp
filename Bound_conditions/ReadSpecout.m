function [AFREQ CDIR DATE E] = ReadSpecout(fname,plot)

fid=fopen(fname);

%read until encountering  frequencies
line=fgetl(fid)
while strcmp(line(1:4),'TIME')==0
    line=fgetl(fid);
end

%read in frequency discretization
line=fgetl(fid);line=fgetl(fid);line=fgetl(fid);line=fgetl(fid);line=fgetl(fid);line=fgetl(fid);
numf=str2num(line(1:11));
AFREQ=zeros(1,numf);
for i=1:numf
    line=fgetl(fid);
    AFREQ(i)=str2num(line(1:10));
end

%read in the spectral discretizations
line=fgetl(fid);line=fgetl(fid);
numd=str2num(line(1:11));
CDIR=zeros(1,numd);
for i=1:numd
    line=fgetl(fid);
    CDIR(i)=str2num(line(1:10));
end

%advance to first time step
fgetl(fid);fgetl(fid);fgetl(fid);fgetl(fid);fgetl(fid);
line=fgetl(fid);

%read DATE, and block out energy for each time step. Concatenate blocked
%data to the bottom of the time step, and proceed to net step
i=1;
while line~=-1
    
    DATE(i,:)=line(1:15);
    line=fgetl(fid);
    Ei=zeros(numd,numf);
    
    
    %if no energy, proceed to next step
    if strcmp(line,'ZERO')==1
        
        line=fgetl(fid);
        
    else
        line=fgetl(fid);
        FACTOR=str2num(line);
        
        for f=1:numf
            line=fgetl(fid);
            Ei(:,f)=str2num(line);
        end
        Ei=Ei*FACTOR;
        line=fgetl(fid);
        
    end
    
    if i==1
        E=Ei;
    else
        E=cat(3,E,Ei);
    end
    i=i+1;
    
end



%plotting data
if plot==1
    figure
    for t=1:i-1
        numf=20
        h=polarplot3d(E(:,1:numf,t)','plottype','surfn','angularrange',[0 360].*(pi/180),'radialrange',AFREQ(1:numf),...
            'tickspacing',10,'View',[0 90],'polardirection','cw'); axis equal tight;grid off;axis off
        
        caxis([0 max(max(max(E)))/3])
        colormap swellnow
        colorbar
        pause(.01)
        
    end
    
end


end
