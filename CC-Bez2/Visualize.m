function  Visualize(V,F,iter,string)
clf
[r,~]=size(F);
if r>0
    patch('vertices',V,'faces',F,'facecolor','b')
    title({['{\bf\fontsize{10} ', string ,...
        ' subdivision by Catmull Clark scheme}'];
        ['{\color{red}Round:}  ',num2str(iter),....
        '  {\color{red} Faces:}  ',num2str(r)] })
    view(3)
    pause(50*eps);
end
end