%Script to plot subdivision
 a0 = [1,1]/2; a1 = [1,2,1]/4; a2 = [1,3,3,1]/8;
 a3 = [1,-2,3]/2; anim=true;
 P = [0,0,1,1;0,1,1,0];
 Q = CurveSubd(P,a0,0,1,4,anim);