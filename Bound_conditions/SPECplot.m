clc;clear all;close all; fclose all;
%clc;clear all; fclose all;

[date, bw, E, ff]=specsum('.\inputs\DATA_spec.txt',1);
[date, bw, A1, ff]=specsum('.\inputs\DATA_dir1.txt',0);
[date, bw, A2, ff]=specsum('.\inputs\DATA_dir2.txt',0);
[date, bw, R1, ff]=specsum('.\inputs\DATA_r1.txt',0);
[date, bw, R2, ff]=specsum('.\inputs\DATA_r2.txt',0);


%convert direction
Dir=-1*((A1(1,:)+A2(1,:))./2)+270;
    

%create directional wave spectrum
%replace missing data 
del=find(A1==999.0000);
A1(del)=0;
del=find(A2==999.0000);
A2(del)=0;
del=find(R1==999.0000);
R1(del)=0;
del=find(R2==999.0000);
R2(del)=0;

% %seperate variables 
% E=x(:,3);
A=100:1:360;
% R1=x(:,4);
% R2=x(:,5);
% A1=x(:,6);
% A2=x(:,7);



%initialize spectrum variable
D=zeros(25,length(A));


for f=1:1:length(E)
    for a=1:length(A)
    
        
        %solve for D(f,A)
%    D(f,a)=E(f)/pi*(R1(f)*cosd(A(a)-A1(f))+R2(f)*cosd(2*(A(a)-A2(f))));
     D(f,a)=1030*bw(f)*E(f)/pi*(.5*R1(f)*cosd(A(a)-A1(f))+R2(f)*cosd(2*(A(a)-A2(f))));

        
    end
end
ff1=1./ff;
newff=linspace(ff1(1),ff1(25),200);
%eliminate negative areas
neg=find(D<0);
D(neg)=0;

[th1,r1]=meshgrid(A,ff1);
[th2,r2]=meshgrid(A(1):.25:A(length(A)),newff);
D2=interp2(th1,r1,D,th2,r2,'cubic');

neg=find(D2<0);
D2(neg)=0;



neg=find(D2<0);
D2(neg)=0;

t2 = [90 360]*pi/180;


% %% Surface plot, compass convention, color is radial direction gradient

cl=0:.01:.5;




  figure('color','white');
  subplot(1,2,1)
h=polarplot3d(D2,'plottype','surfn','angularrange',t2,'radialrange',[r2(1,1) r2(200,1)],...
       'tickspacing',10,'View',[0 90],'polardirection','cw','contourlines',cl);
   
   
   
   
   %,'RadLabels',20,'RadLabelLocation',{130 0.001},...'Radlabelcolor','white');%,'Xticklabels','Yticklabels','');
% 
%  
                      set(gca,'xticklabel','');
                 set(gca,'yticklabel','');
                 axis equal;axis off
                 freezeColors
              %   title('Spectral Energy Density')
               %  colorbar
%                 set(gca,'yaxis','off');
%                 
%                 grid off
                
                