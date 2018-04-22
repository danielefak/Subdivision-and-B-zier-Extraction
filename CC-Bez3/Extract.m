function [Bez] = Extract(PX,PY,PZ)
q=1/4; h=1/2;
HM=[q q 0 0 q q 0 0; 0 h 0 0 0 h 0 0;
    0 0 h 0 0 0 h 0; 0 0 q q 0 0 q q; 
    0 0 0 0 h h 0 0; 0 0 0 0 0 1 0 0;
    0 0 0 0 0 0 1 0;0 0 0 0 0 0 h h];
LM=rot90(HM,2); 
HBezX= HM*PX(1:8,:);%
LBezX=LM*PX(9:16,:);
MultiBezX=[HBezX;LBezX];
BezX= reshape(MultiBezX,[],1);
HBezY= HM*PY(1:8,:);%
LBezY=LM*PY(9:16,:);
MultiBezY=[HBezY;LBezY];
BezY= reshape(MultiBezY,[],1);
HBezZ= HM*PZ(1:8,:);%
LBezZ=LM*PZ(9:16,:);
MultiBezZ=[HBezZ;LBezZ];
BezZ= reshape(MultiBezZ,[],1);
Bez=[BezX BezY BezZ];%
end