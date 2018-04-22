%Animation function used in CurveSubdAnim.m
function animation2(P,Q,D,d)
t=0;
discr=20;
hold on
CP = ClosePolygon(P);
    plot(CP(1,:),CP(2,:),'LineWidth',2);
for m = 1:d
        plot((1-t/discr)*D(1,m)+(t/discr)*Q(1,m),...
            (1-t/discr)*D(2,m)+(t/discr)*Q(2,m),'o',...
            'MarkerSize',7,'MarkerEdgeColor','k','MarkerFaceColor','k');
        axis([-0.2 1.2 -0.2 1.2]);
end
pause(0.4)
figure
axis([-0.2 1.2 -0.2 1.2]);
discr=20;
for t=0:discr
    clf
    axis([-0.2 1.2 -0.2 1.2]);
    hold on
    CP = ClosePolygon(P);
    plot(CP(1,:),CP(2,:),'LineWidth',2);
    for m = 1:d
        plot((1-t/discr)*D(1,m)+(t/discr)*Q(1,m),...
            (1-t/discr)*D(2,m)+(t/discr)*Q(2,m),'o',...
            'MarkerSize',7,'MarkerEdgeColor','k', 'MarkerFaceColor','k');
    end
    CQ=ClosePolygon(Q);
    CD=ClosePolygon(D);
    plot((1-t/discr)*CD(1,:)+(t/discr)*CQ(1,:),...
        (1-t/discr)*CD(2,:)+(t/discr)*CQ(2,:),'LineWidth',2);
    pause(0.01)
    if t==discr
       figure 
    end
    clf
    plot(CQ(1,:),CQ(2,:),'LineWidth',1.8);
    axis([-0.2 1.2 -0.2 1.2]);
end
end
