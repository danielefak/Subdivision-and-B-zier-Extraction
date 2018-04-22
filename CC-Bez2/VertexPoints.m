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