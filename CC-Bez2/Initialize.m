function [ExtEdges,EV,EF,FE,BordF]=Initialize(FV)
[f,~]=size(FV);
BordF=zeros(f,1);
% E=Edges List
E1=sort(FV(:,[1,2]), 2);
E2=sort(FV(:,[2,3]), 2);
E3=sort(FV(:,[3,4]), 2);
E4=sort(FV(:,[4,1]), 2);
E_full = [E1;E2;E3;E4];
[EV,inde1,indf] = unique(E_full,'rows','first');
[e,~]=size(EV);
% Face-edge list
FE = reshape(indf,[],4); 
% Edge-face list
[~,inde2,~] = unique(E_full,'rows','last');
EF_full = [inde1 inde2];
EF = mod((EF_full-1),f)+1;
EF(EF(:,1)==EF(:,2),2) =0; 
ExtEdges=zeros(e,1);
ExtEdges(EF(:,2)==0)=1;
BordF(EF(ExtEdges==1,1))=1;
end