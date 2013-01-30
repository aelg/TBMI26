function h = draw_mark(sign,pos)
axis([0 4 0 4])
axis('image')

string = ['X';'O'];
poslist = [1 3; 1 2; 1 1; 2 3; 2 2; 2 1; 3 3; 3 2; 3 1]-0.15*[ones(9,1),zeros(9,1)];
color=[1 0 0; 0 1 0];
h=text(poslist(pos,1),poslist(pos,2),string(sign));
set(h,'Color',color(sign,:));
set(h,'FontSize',32);
drawnow