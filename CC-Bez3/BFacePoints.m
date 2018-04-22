function [BFs]=BFacePoints(V,F,i)
a=4/9; b=2/9; c=1/9;
BFs=[a,b,c,b ; b,a,b,c ;c,b,a,b; b,c,b,a ]* V(F(i,:),:);
end