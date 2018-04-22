%%Script for  Bezier extraction
%PARAMETERS
iter=2;    %number of iterations
prog=1;    %shows intermediate steps
ni=15;     %for Bezier visualization
iterB=6;   %number of iteration to extract border faces
Mesh=8;
%Select Mesh:
%  1  Klein bottle        2  Cube
%  3  Cube less 1 face    4  Cube less 2 faces
%  5  Tube                6  Square
%  7  Star                8  Torus
%  9  Duck                10 Cow
[V,FV,string]=SelectMesh(Mesh);
Visualize(V,FV,0,string)
M=ones(size(FV,1),1);
NBez=zeros(0,3);
OBez=NBez;
for i=1:iter
    if i<iterB
        [NV,NFV,NM,Bez]=GraphBez(V,FV,M,0);
    else
        [NV,NFV,NM,Bez]=GraphBez(V,FV,M,1);
    end
    M=NM;
    V=NV;
    FV=NFV;
    NBez=[OBez;Bez];
    OBez=NBez;
    if prog
        Visualize(V,FV,i,string)
    end
end
%Visualize Extraction
BVisualize2(NBez,ni,string);
