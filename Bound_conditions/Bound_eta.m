%recreate surface elevation time series, based on multiple wave groups. 

clc;clear all; fclose all

[date, bw, E, f]=specsum('./inputs2/DATA_spec.txt',1);
[date, b, A1, f]=specsum('./inputs2/DATA_dir1.txt',0);
[date, b, A2, f]=specsum('./inputs2/DATA_dir2.txt',0);
[date, b, R1, f]=specsum('./inputs2/DATA_r1.txt',0);
[date, b, R2, f]=specsum('./inputs2/DATA_r2.txt',0);

%H=E./bw./1030./9.8*3.28084^2;
H=sqrt(4*E./(bw.*(1030*9.8)));

% figure
% subplot(3,1,1)
% plot(H)
% subplot(3,1,2)
% plot(bw)
% subplot(3,1,3)
% plot(f)

t=linspace(1,1000,10000);
sig=2*pi.*f;

k=4*pi^2.*f.^2./9.8;


eta=zeros(length(f),10000);

for i=1:1:length(f)

eta(i,:)=H(i)./2.*cos(-sig(i).*t);

end

eta2=ones(1,length(t));

for i=1:1:length(f)

eta2(:)=eta2+eta(i,:);

end
% figure
% plot(eta2)

%find direction
Dir=((A1(1,:)+A2(1,:))./2);
nums=find(Dir ~= -999);


%initialize spatial grid
x=-1000:15:1000;
y=-1000:15:1000;

[xx yy]=meshgrid(x,y);

%solve for L, and it's x- and y- projections
L=9.8./(2.*pi.*f.^2);
Lx=2.*L.*sind(Dir);     %x-projection of wavelength
Ly=2.*L.*sind(90-Dir);  %y-projection

zzx=find(Lx==0);
zzy=find(Ly==0);

%convert from wavelength to wavenumber, and sigma
kx=2.*pi./Lx;
ky=2.*pi./Ly;

kx(zzx)=0;
ky(zzy)=0;

sig=(2*pi).*f;

%define t and number of frequancies
times=-50:.5:50;
freqs=[linspace(0.1,nums(length(nums)),.5*length(times)),nums(length(nums))*ones(1,length(times))];
it=1;


%subplot(1,2,2)
% writerObj = VideoWriter('FileName.avi');
% set(writerObj,'FrameRate',20) % ~25 is normal playback speed (frames per sec)
% open(writerObj);
%  
% set(gca,'nextplot','replacechildren');
% set(gcf,'Renderer','zbuffer');


for t=1:100
    
    FF=ceil(freqs(it));
    FF=length(nums-3);
for i=1:FF
    eta2d(:,:,i)=H(i)/2.*(cos(kx(i)*xx+ky(i)*yy+sig(i).*t));
    
end

%preallocating surface elevations
eta=sum(eta2d,3);

% waterfall(x,y,eta')
surf(x,y,eta)
figure(2)

plot(eta(:,10))
colormap water
alpha(.8)

zlim([-5 5])

set(gca,'XTickLabel','','YTickLabel','','ZTickLabel','')

% h1=xlabel('W<------------>E');
% set(h1,'rotation',8)%'fontsize',15)
% h2=ylabel('N<------------>S');
% set(h2,'rotation',-65)%,'fontsize',15)
% 
%title('Sea Surface Conditions')

view([0 60])
%view([-15 50])
pause(.1)


fname=['./WaveGif/frame',num2str(it),'.png'];
%saveas(gcf,fname)

it=it+1;

% 
% frame = getframe(gcf); %(can be getframe(gcf) to include the entire figure)
% writeVideo(writerObj,frame);
% 


end

% close(writerObj)
