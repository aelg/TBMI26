function disableDrawing()

set(gcf, 'WindowButtonDownFcn', '');
set(gcf, 'WindowButtonUpFcn', '');
set(gcf, 'WindowButtonMotionFcn', '');
