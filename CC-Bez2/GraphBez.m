%%
%Bezier Extraction on regular faces after subdivision on extraordinary 
%faces implementation
%DANIELE FAKHOURY 2017

%%
function [NV,NFV,NM,Bez]=GraphBez(V,FV,M,NoBord)
if nargin<4
    NoBord=0;
end
[ExtE,EV,EF,FE,BordF]=Initialize(FV);
FPs=(V(FV(:,1),:)+V(FV(:,2),:)+V(FV(:,3),:)+V(FV(:,4),:))/4;
EPs=EdgePoints(FPs,ExtE,EV,EF,V);
[ExtV,VNF,VPs]=VertexPoints(FPs,V,EV,EF,ExtE,FV);
[PX,PY,PZ,OrdFInd,Usefull]=ExtractInit(V,ExtV,VNF,FV,M);
[Bez] = Extract(PX,PY,PZ);
[NV,NFV,NM]=Subdivide(FPs,EPs,VPs,FE,FV,M,OrdFInd,Usefull,NoBord,BordF);
end

%%
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


%%
function [NV,NFV,NM]=Subdivide(FPs,EPs,VPs,FE,FV,M,OrdF,Usefull,NoBord,BF)
[e,~]=size(EPs);
[f,~]=size(FV);
%Create new Vertices and new Faces
NV=[FPs;EPs;VPs];
i=1:f;
NFV1=[i' f*ones(f,1)+FE(i,4) (f+e)*ones(f,1)+FV(i,1) f*ones(f,1)+FE(i,1)];
NFV2=[i' f*ones(f,1)+FE(i,1) (f+e)*ones(f,1)+FV(i,2) f*ones(f,1)+FE(i,2)];
NFV3=[i' f*ones(f,1)+FE(i,2) (f+e)*ones(f,1)+FV(i,3) f*ones(f,1)+FE(i,3)];
NFV4=[i' f*ones(f,1)+FE(i,3) (f+e)*ones(f,1)+FV(i,4) f*ones(f,1)+FE(i,4)];
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

%%
function C = intersect(A,B)
 P = zeros(1, max(max(A),max(B)) ) ;
 P(A) = 1;
 C = B(logical(P(B)));
end

%%
function [BFs]=BFacePoints(V,F,i)
a=4/9;
b=2/9;
c=1/9;
M= V(F(i,:),:);
BFs=[a,b,c,b ; b,a,b,c ;c,b,a,b; b,c,b,a ]*M;
end

%%
function [PointsX,PointsY,PointsZ,OrdFInd,Usefull]=ExtractInit(V,ExtV,VNF,FV,M)
[f,~]=size(FV);
i=1:f;
Usefull=zeros(f,1);
OrdFInd=...
  ((ExtV(FV(i,1))+ExtV(FV(i,2))+ExtV(FV(i,3))+ExtV(FV(i,4)))==0 & M(i)>0);
OrdF=i(OrdFInd);

PointsX=zeros(16,f);
PointsY=zeros(16,f);
PointsZ=zeros(16,f);

for i=OrdF
Points=zeros(16,3);

P1=FV(i,1);
P2=FV(i,2);
P3=FV(i,3);
P4=FV(i,4);
VN1=VNF(P1,VNF(P1,:)~=i);  
VN2=VNF(P2,VNF(P2,:)~=i);
VN3=VNF(P3,VNF(P3,:)~=i);
VN4=VNF(P4,VNF(P4,:)~=i);
E1=intersect(VN1,VN2);
E2=intersect(VN2,VN3);
E3=intersect(VN3,VN4);
E4=intersect(VN4,VN1);
V1=VN1(VN1~=E1 & VN1~=E4);
V2=VN2(VN2~=E2 & VN2~=E1);
V3=VN3(VN3~=E3 & VN3~=E2);
V4=VN4(VN4~=E4 & VN4~=E3);
AllNeigh=[E1,E2,E3,E4,V1,V2,V3,V4];
[par,~]=size(OrdFInd(OrdFInd(AllNeigh)==0));
if par>0
Usefull(i)=1;
end
%Filling matrices for Extraction
a=1:4;

BFP =  BFacePoints(V,FV,i);
BFPV1= BFacePoints(V,FV,V1);
BFPV2= BFacePoints(V,FV,V2);
BFPV3= BFacePoints(V,FV,V3);
BFPV4= BFacePoints(V,FV,V4);
BFPE1= BFacePoints(V,FV,E1);
BFPE2= BFacePoints(V,FV,E2);
BFPE3= BFacePoints(V,FV,E3);
BFPE4= BFacePoints(V,FV,E4);

Points(1,:)=BFPV1(a(FV(V1,:)==P1),:);
Points(2,:)=BFPE1(a(FV(E1,:)==P1),:);
Points(3,:)=BFPE1(a(FV(E1,:)==P2),:);
Points(4,:)=BFPV2(a(FV(V2,:)==P2),:);
Points(5,:)=BFPE4(a(FV(E4,:)==P1),:);
Points(6,:)=BFP(1,:);
Points(7,:)=BFP(2,:);
Points(8,:)=BFPE2(a(FV(E2,:)==P2),:);
Points(9,:)=BFPE4(a(FV(E4,:)==P4),:);
Points(10,:)=BFP(4,:);
Points(11,:)=BFP(3,:);
Points(12,:)=BFPE2(a(FV(E2,:)==P3),:);
Points(13,:)=BFPV4(a(FV(V4,:)==P4),:);
Points(14,:)=BFPE3(a(FV(E3,:)==P4),:);
Points(15,:)=BFPE3(a(FV(E3,:)==P3),:);
Points(16,:)=BFPV3(a(FV(V3,:)==P3),:);

PointsX(:,i)=Points(:,1);
PointsY(:,i)=Points(:,2);
PointsZ(:,i)=Points(:,3);
end

PointsX=PointsX(:,OrdF);
PointsY=PointsY(:,OrdF);
PointsZ=PointsZ(:,OrdF);
end

%%
function [Bez] = Extract(PX,PY,PZ)
q=1/4;
h=1/2;
HM=[q q 0 0 q q 0 0;
    0 h 0 0 0 h 0 0;
    0 0 h 0 0 0 h 0;
    0 0 q q 0 0 q q;
    0 0 0 0 h h 0 0;
    0 0 0 0 0 1 0 0;
    0 0 0 0 0 0 1 0;
    0 0 0 0 0 0 h h];
LM=rot90(HM,2);

HBezX= HM*PX(1:8,:);
LBezX=LM*PX(9:16,:);
MultiBezX=[HBezX;LBezX];
BezX= reshape(MultiBezX,[],1);

HBezY= HM*PY(1:8,:);
LBezY=LM*PY(9:16,:);
MultiBezY=[HBezY;LBezY];
BezY= reshape(MultiBezY,[],1);

HBezZ= HM*PZ(1:8,:);
LBezZ=LM*PZ(9:16,:);
MultiBezZ=[HBezZ;LBezZ];
BezZ= reshape(MultiBezZ,[],1);

Bez=[BezX BezY BezZ];
end

%%
function [ExtVforExtr,VNF,VPs]=VertexPoints(FPs,V,EV,EF,ExtE,FV)
[v,~]=size(V);
[e,~]=size(EV);
VNF=zeros(v,4);
VPs=zeros(v,3);
allV=1:v;
E=1:e;
BV=unique([EV(ExtE==1,1); EV(ExtE==1,2)]);
occVert=histc(FV(:),1:v);
occVert(BV)=0;
OrdV=allV(occVert==4 & occVert>0 );
ExtV=allV(occVert~=4 & occVert>0 );
%for extraction
ExtVforExtr=zeros(v,1);
ExtVforExtr(allV(occVert~=4))=1;
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
N=zeros(4,ov);
M=zeros(4,ov);

if ov>0
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
VNF(OrdV,:)=N;
end