function coords = draw(fig)

if nargin < 1
  fig = figure;
  axis([0 1 0 1]);
  set(gca,'XTick',[])
  set(gca,'YTick',[])
end

figure(fig);
hold on;
axis manual;

set(fig, 'WindowButtonDownFcn', 'mousePressed');
set(fig, 'WindowButtonUpFcn', 'mouseReleased');

ud = cell(2);
ud{1} = timer('timerfcn', 'disableDrawing', 'startdelay', 1);
set(fig, 'UserData', ud);

while(length(get(fig, 'WindowButtonDownFcn')) > 0); 
  pause(0.1);
end

hold off;

ud = get(fig, 'UserData');
coords = ud{2};
set(fig, 'UserData', []);


function mouseMoved()

cp = get(gca,'CurrentPoint'); % Get cursor position
p = cp(1,1:2);          % Cursor coordinate
plot(p(1),p(2),'.');

ud = get(gcf, 'UserData');
ud{2} = [ud{2}; p];
set(gcf, 'UserData', ud);



function mousePressed()

cp = get(gca,'CurrentPoint'); % Get cursor position
p = cp(1,1:2);          % Cursor coordinate
plot(p(1),p(2),'.');

ud = get(gcf, 'UserData');
ud{2} = [ud{2}; p];
set(gcf, 'UserData', ud);

stop(ud{1});

set(gcf, 'WindowButtonMotionFcn', 'mouseMoved');



function mouseReleased()

ud = get(gcf, 'UserData');
start(ud{1});

set(gcf, 'WindowButtonMotionFcn', []);


