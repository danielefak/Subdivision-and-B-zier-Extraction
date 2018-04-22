%Function to evaluate and plot (with an animation)
%a subdivision curve Given polygon P, 
%refinement mask a=(a_(-s),.. a_(t)), boolean anim foranimation

function [Q] = CurveSubdAnim(P,a,s,t,n,anim)
hold on
for i=1:n
    Q = CurveSubdOneIter(P,a,s,t,anim);
    P=Q;
end
end

function [Q] = CurveSubdOneIter(P,a,s,t,anim)
%Splitting step
P1 = repelem(P,1,2);
d = size(P1,2);
P2 = [P1(:,2:d),P1(:,1)];
D = (P1+P2)/2;
%Averaging step
A=D;
Q=a(s+1)*D;
for j=1:s
    B = [A(:,d),A(:,1:d-1)];
    Q = a(s-j+1)*B + Q;
    A = B;
end
A=D;
for j=1:t
    B = [A(:,2:d),A(:,1)];
    Q = a(length(a)-t+j)*B + Q;
    A = B;
end
%Animation step
if(anim)
    animation(P,Q,D,d);
end
end

