function [NV,NFV]=Subdivide(FPs,EPs,VPs,FE,FV)
[e,~]=size(EPs);
[f,~]=size(FV);
NV=[FPs;EPs;VPs];
i=1:f;
NFV1=[i' f*ones(f,1)+FE(i,4) ...
    (f+e)*ones(f,1)+FV(i,1) f*ones(f,1)+FE(i,1)];
NFV2=[i' f*ones(f,1)+FE(i,1)....
    (f+e)*ones(f,1)+FV(i,2) f*ones(f,1)+FE(i,2)];
NFV3=[i' f*ones(f,1)+FE(i,2)...
    (f+e)*ones(f,1)+FV(i,3) f*ones(f,1)+FE(i,3)];
NFV4=[i' f*ones(f,1)+FE(i,3)...
    (f+e)*ones(f,1)+FV(i,4) f*ones(f,1)+FE(i,4)];
NFV=[NFV1;NFV2;NFV3;NFV4];
end