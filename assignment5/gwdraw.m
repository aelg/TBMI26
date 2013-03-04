function gwdraw()
% Draw Gridworld and robot.
  
global GWXSIZE;
global GWYSIZE;
global GWPOS;
global GWFEED;
global GWTERM;
global GWROBOT;
global GWGOAL;

cla;
pause(0.2);
hold on;
title('Feedback Map');
xlabel('Y');
ylabel('X');
axis equal;
axis ij;
imagesc(GWFEED);
hold on;
image3(GWROBOT,[0 1/size(GWROBOT,1) GWPOS(2)-0.5; 1/size(GWROBOT,2) ...
		0 GWPOS(1)-0.5; 0 0 1]);
colorbar;
   
for x = 1:GWXSIZE
  for y = 1:GWYSIZE
    if GWTERM(x,y)
      image3(GWGOAL,[0 1/size(GWGOAL,1) y-0.5; 1/size(GWGOAL,2) ...
		      0 x-0.5; 0 0 1]);
    end
  end
end
pause(0.2);
    



