%%Script for CC subdivision and Bezier extraction
clear           % clear variables
clc             % clear command window
clf             % clear figure
%PARAMETERS
iter=2;    %number of iterations
prog=1;    %shows intermediate steps
Mesh=8;
%Select Mesh:
%  1  Klein bottle        2  Cube
%  3  Cube less 1 face    4  Cube less 2 faces
%  5  Tube                6  Square
%  7  Star                8  Torus
%  9  Duck                10 Cow

[V,FV,string]=SelectMesh(Mesh);
[r,~]=size(FV);
Visualize(V,FV,0,string)

for i=1:iter
    [NV,NFV]=GraphCCSub(V,FV);
    V=NV;
    FV=NFV;
    if prog
        Visualize(V,FV,i,string)
    end
end
if prog==0
    Visualize(V,FV,i,string)
end