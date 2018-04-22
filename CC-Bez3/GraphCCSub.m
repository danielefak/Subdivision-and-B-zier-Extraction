%%
%CCSubdivision Scheme implementation
%DANIELE FAKHOURY 2017

%%
function [NV,NFV]=GraphCCSub(V,FV)
[ExtE,EV,EF,FE]=Initialize(FV);
FPs=(V(FV(:,1),:)+V(FV(:,2),:)+V(FV(:,3),:)+V(FV(:,4),:))/4;
EPs=EdgePoints(FPs,ExtE,EV,EF,V);
VPs=VertexPoints(FPs,V,EV,EF,ExtE,FV);
[NV,NFV]=Subdivide(FPs,EPs,VPs,FE,FV);
end

%%
function [ExtEdges,EV,EF,FE]=Initialize(FV)
[f,~]=size(FV);
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
end

%%
function EPs=EdgePoints(AllFPs,ExtE,EV,EF,V)
[e,~]=size(EV);
EPs=zeros(e,3);
EPs(ExtE==0,:)=(V(EV(ExtE==0,1),:)+ V(EV(ExtE==0,2),:) +...
    AllFPs(EF(ExtE==0,1),:) +  AllFPs(EF(ExtE==0,2),:))/4;
EPs(ExtE==1,:)=(V(EV(ExtE==1,1),:)+ V(EV(ExtE==1,2),:))/2;
end

%%
function [NV,NFV]=Subdivide(FPs,EPs,VPs,FE,FV)
[e,~]=size(EPs);
[f,~]=size(FV);
NV=[FPs;EPs;VPs];
i=1:f;
NFV1=[i' f*ones(f,1)+FE(i,4) (f+e)*ones(f,1)+FV(i,1) f*ones(f,1)+FE(i,1)];
NFV2=[i' f*ones(f,1)+FE(i,1) (f+e)*ones(f,1)+FV(i,2) f*ones(f,1)+FE(i,2)];
NFV3=[i' f*ones(f,1)+FE(i,2) (f+e)*ones(f,1)+FV(i,3) f*ones(f,1)+FE(i,3)];
NFV4=[i' f*ones(f,1)+FE(i,3) (f+e)*ones(f,1)+FV(i,4) f*ones(f,1)+FE(i,4)];
NFV=[NFV1;NFV2;NFV3;NFV4];
end

%%
function [VPs]=VertexPoints(FPs,V,EV,EF,ExtE,FV)
[v,~]=size(V);
[e,~]=size(EV);
VPs=zeros(v,3);
allV=1:v;
E=1:e;
BV=unique([EV(ExtE==1,1); EV(ExtE==1,2)]);
occVert=histc(FV(:),1:v);
occVert(BV)=0;
OrdV=allV(occVert==4 & occVert>0 );
ExtV=allV(occVert~=4 & occVert>0 );

%Extraordinary vertices
for k=ExtV
    P=V(k,:);
    EdgesInK=[E(EV(:,1)==k) E(EV(:,2)==k)];
    n=occVert(k);
    R=mean((V(EV(EdgesInK,1),:) +  V(EV(EdgesInK,2),:))./2);
    NFaces=unique([EF(EdgesInK,1);EF(EdgesInK,2)]);
    S=mean(FPs(NFaces,:));
    VPs(k,:)=((n-3)*P + 2*R + S )/n;
end

%Border vertices 
A=EV;
[r,~]=size(BV);
O=E(ExtE==0);
[~,o]=size(O);
A(O,:)=zeros(o,2);
A=A';
B=A(:)';
N=zeros(2,r);
[~,ind]=ismember(BV',B);
N(1,:)=ind;
B(ind)=0;
[~,ind]=ismember(BV',B);
N(2,:)=ind;
N=ceil(N/2)';

VPs(BV,:)= (V(EV(N(:,1),1),:) + V(EV(N(:,1),2),:) +...
    V(EV(N(:,2),1),:) + V(EV(N(:,2),2),:))/ 8 + V(BV,:)*(4/8);

%Ordinary vertices
[~,ov]=size(OrdV);
if ov>0
N=zeros(4,ov);
M=zeros(4,ov);
%Find 4 neigh faces and find 4 edges
A=FV';
B=A(:)';
C=EV';
D=C(:)';

for k=1:4
[~,ind]=ismember(OrdV,B);
N(k,:)=ind;
B(ind)=0;
[~,ind]=ismember(OrdV,D);
M(k,:)=ind;
D(ind)=0;
end
M=ceil(M/2)';
N=ceil(N/4)';

%Calculate VPs
P=V(OrdV,:);
S=(FPs(N(:,1),:)+ FPs(N(:,2),:)+ FPs(N(:,3),:)+ FPs(N(:,4),:))/4;
R=((V(EV(M(:,1),1),:)+V(EV(M(:,1),2),:))/2+... 
   (V(EV(M(:,2),1),:)+V(EV(M(:,2),2),:))/2+...
   (V(EV(M(:,3),1),:)+V(EV(M(:,3),2),:))/2+...
   (V(EV(M(:,4),1),:)+V(EV(M(:,4),2),:))/2 )/4;

VPs(OrdV,:)=(S+2*R+P)/4 ;
end
end