%%
%CCSubdivision Scheme implementation
%DANIELE FAKHOURY 2017

function [NV,NFV]=GraphCCSub(V,FV)
[ExtE,EV,EF,FE,~]=Initialize(FV);
FPs=(V(FV(:,1),:)+V(FV(:,2),:)+V(FV(:,3),:)+V(FV(:,4),:))/4;
EPs=EdgePoints(FPs,ExtE,EV,EF,V);
[~,~,VPs]=VertexPoints(FPs,V,EV,EF,ExtE,FV);
[NV,NFV]=Subdivide(FPs,EPs,VPs,FE,FV);
end