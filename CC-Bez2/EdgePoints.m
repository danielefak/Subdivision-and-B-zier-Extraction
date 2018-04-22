function EPs=EdgePoints(AllFPs,ExtE,EV,EF,V)
[e,~]=size(EV);
EPs=zeros(e,3);
EPs(ExtE==0,:)=(V(EV(ExtE==0,1),:)+ V(EV(ExtE==0,2),:) +...
    AllFPs(EF(ExtE==0,1),:) +  AllFPs(EF(ExtE==0,2),:))/4;
EPs(ExtE==1,:)=(V(EV(ExtE==1,1),:)+ V(EV(ExtE==1,2),:))/2;
end