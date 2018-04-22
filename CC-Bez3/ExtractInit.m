function [PointsX,PointsY,PointsZ,OrdFInd,Usefull]=...
    ExtractInit(V,ExtV,VNF,FV,M)
[f,~]=size(FV);
i=1:f;
Usefull=zeros(f,1);
OrdFInd=((ExtV(FV(i,1))+ExtV(FV(i,2))+...
    ExtV(FV(i,3))+ExtV(FV(i,4)))==0 & M(i)>0);
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

function C = intersect(A,B)
P = zeros(1, max(max(A),max(B)) ) ;
P(A) = 1;
C = B(logical(P(B)));
end