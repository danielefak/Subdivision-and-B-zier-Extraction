function BVisualize2(Bez,ni,string)
S(:,:,1,:)=reshape(Bez(:,1),4,4,[]);
S(:,:,2,:)=reshape(Bez(:,2),4,4,[]);
S(:,:,3,:)=reshape(Bez(:,3),4,4,[]);

[~, ~, ~, np]=size(S);
u=linspace(0,1,ni);
figure;
hold on;
r=u;
bern=zeros(4,ni);
bern(1,:)= (1-r).^3;
bern(2,:)= 3.*(r.*((1-r).^2));
bern(3,:)= 3.*((r.^2).*(1-r));
bern(4,:)= r.^3;

% Evaluating and plotting Bezier surface 
for k=1:np
    %interpolation of kth patch
    Q = bezierpatchinterp2(bern, S(:,:,:,k),ni); 
    surface(Q(:,:,1),Q(:,:,2),Q(:,:,3)); %Plot
end

camlight
colormap cool;
shading interp
material dull
view(3); 
title({['{\bf\fontsize{10} ', string ,' Bezier extraction  }'];
    ['{\color{red}On}  ',num2str(np),'   {\color{red}patches.}  '] })
box;  
end


function Q=bezierpatchinterp2(bern,P,ni)
[~, ~, dim]=size(P);
Q=zeros(ni,ni,dim);
bc=P;
Q(:,:,1)=bern'*bc(:,:,1)*bern;
Q(:,:,2)=bern'*bc(:,:,2)*bern;
Q(:,:,3)=bern'*bc(:,:,3)*bern;
end