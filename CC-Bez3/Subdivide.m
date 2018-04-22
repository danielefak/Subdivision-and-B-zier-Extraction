function [NV,NFV,NM]=...
    Subdivide(FPs,EPs,VPs,FE,FV,M,OrdF,Usefull,NoBord,BF)
[e,~]=size(EPs);
[f,~]=size(FV);
%Create new Vertices and new Faces
NV=[FPs;EPs;VPs];
i=1:f;
NFV1=[i' f*ones(f,1)+FE(i,4)...
    (f+e)*ones(f,1)+FV(i,1) f*ones(f,1)+FE(i,1)];
NFV2=[i' f*ones(f,1)+FE(i,1)...
    (f+e)*ones(f,1)+FV(i,2) f*ones(f,1)+FE(i,2)];
NFV3=[i' f*ones(f,1)+FE(i,2)...
    (f+e)*ones(f,1)+FV(i,3) f*ones(f,1)+FE(i,3)];
NFV4=[i' f*ones(f,1)+FE(i,3)...
    (f+e)*ones(f,1)+FV(i,4) f*ones(f,1)+FE(i,4)];
%Remove inused vertices
ExtF=OrdF==0;
Usefull=M.*(Usefull+ExtF);
if NoBord==1
  Usefull=Usefull-BF;
end
[m,~]=size(Usefull);
mark=1:m;
i=mark(Usefull>0);
NFV=[NFV1(i,:);NFV2(i,:);NFV3(i,:);NFV4(i,:)];
U=(reshape(NFV,1,[]));
[C,~,iC] = unique(U);
NV=NV(C,:);
NFV=reshape(iC,[],4);
%New Marked Faces
NM=[ExtF(i);ExtF(i);ExtF(i);ExtF(i)];
end