%%
%Bezier Extraction on regular faces after subdivision on extraordinary
%faces implementation
%DANIELE FAKHOURY 2017

function  BVisualize(Ext,Bez,uniform,string)
if nargin<3
    uniform=0;
    string='';
end

figure
[r,~]=size(Ext);
hold on

for i=1:1 %r
    i=i
    r=r
a=(2^(Ext(end,17)-Ext(i,17))+1)*uniform +10*(1-uniform);
LocalBVisualize(Ext,i,Bez,a);  
end

view(3)
title({['{\bf\fontsize{10} ', string ,' Bezier extraction  }'];
    ['{\color{red}On}  ',num2str(r),'   {\color{red}patches.}  '] })
% axis vis3d
camlight
colormap cool;
shading interp
material dull
end

% 
% function [y]=B(p,i,x)
% y = (nchoosek(p,i)).*x.^(i).*(1-x).^(p-i);
% end


function  LocalBVisualize(Ext,i,Bez,a)

Coeff=[
    Ext(i,1),Ext(i,2),Ext(i,3), Ext(i,4);
    Ext(i,5),Ext(i,6),Ext(i,7), Ext(i,8);
    Ext(i,9),Ext(i,10),Ext(i,11), Ext(i,12);
    Ext(i,13),Ext(i,14),Ext(i,15), Ext(i,16)
    ];

r=linspace(0,1,a);
bern=zeros(4,a);
% for i=0:3
%     bern(i+1,:)=B(3,i,r);
% end

bern(1,:)= (1-r).^3;
bern(2,:)= 3.*(r.*((1-r).^2));
bern(3,:)= 3.*((r.^2).*(1-r));
bern(4,:)= r.^3;


bc=reshape(Bez(Coeff,:),4,4,3);
x=bern'*bc(:,:,1)*bern;
y=bern'*bc(:,:,2)*bern;
z=bern'*bc(:,:,3)*bern;

plot3(x,y,z)
end

