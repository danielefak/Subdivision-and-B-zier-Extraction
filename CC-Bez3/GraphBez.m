%%
%Bezier Extraction on regular faces after 
%subdivision on extraordinary faces implementation
%DANIELE FAKHOURY 2017

function [NV,NFV,NM,Bez]=GraphBez(V,FV,M,NoBord)
[ExtE,EV,EF,FE,BordF]=Initialize(FV);
FPs=(V(FV(:,1),:)+V(FV(:,2),:)+V(FV(:,3),:)+V(FV(:,4),:))/4;
EPs=EdgePoints(FPs,ExtE,EV,EF,V);
[ExtV,VNF,VPs]=VertexPoints(FPs,V,EV,EF,ExtE,FV);
[PX,PY,PZ,OrdFInd,Usefull]=ExtractInit(V,ExtV,VNF,FV,M);
[Bez] = Extract(PX,PY,PZ);
[NV,NFV,NM]=...
    Subdivide(FPs,EPs,VPs,FE,FV,M,OrdFInd,Usefull,NoBord,BordF);
end