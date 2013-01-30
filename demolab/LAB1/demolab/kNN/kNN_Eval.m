function [] = kNN_Eval()
%KNN_EVAL Uses the function kNN to classify data
%   Just call kNN_Eval() when kNN() is implemented

%%
% Try kNN on case 1
close all
display('Running kNN on Case 1 of 3. Please hold.')
load case1
figure(1)
subplot(221)
kNN_Plot(X, y, 1);
title('Case 1, k = 1')
subplot(222)
kNN_Plot(X, y, 2);
title('Case 1, k = 2')
subplot(223)
kNN_Plot(X, y, 3);
title('Case 1, k = 3')
subplot(224)
kNN_Plot(X, y, 9);
title('Case 1, k = 9')

% Try kNN on case 2
display('Running kNN on Case 2 of 3. Please hold.')
load case2
figure(2)
subplot(221)
kNN_Plot(X, y, 1);
title('Case 2, k = 1')
subplot(222)
kNN_Plot(X, y, 2);
title('Case 2, k = 2')
subplot(223)
kNN_Plot(X, y, 3);
title('Case 2, k = 3')
subplot(224)
kNN_Plot(X, y, 9);
title('Case 2, k = 9')

% Try kNN on case 2
display('Running kNN on Case 3 of 3. Please hold.')
load case3
figure(3)
subplot(221)
kNN_Plot(X, y, 1);
title('Case 3, k = 1')
subplot(222)
kNN_Plot(X, y, 2);
title('Case 3, k = 2')
subplot(223)
kNN_Plot(X, y, 3);
title('Case 3, k = 3')
subplot(224)
kNN_Plot(X, y, 9);
title('Case 3, k = 9')
display('done')

end


function [ output_args ] = kNN_Plot( X, y, k )
%KNN_PLOT Plots the case data
%   kNN_Plot(X,y) Where X are coordinate and y the class

%%
set(0,'DefaultAxesColorOrder',[1 1 0;1 0 1;1 1 1],...
      'DefaultAxesLineStyleOrder','x|o|.')


% colormap(jet(6))
classes = unique(y);
% colormap(lines(length(classes)*2))




ymin = min(X(1,:))-0.5;
ymax = max(X(1,:))+0.5;
xmin = min(X(2,:))-0.5;
xmax = max(X(2,:))+0.5;

kNN2 = @(x) kNN(x,X,y,k);


sGrid = 50;
xi=linspace(xmin, xmax, sGrid);
yi=linspace(ymin, ymax, sGrid);
[XI,YI] = meshgrid(xi,yi);
I = zeros(sGrid,sGrid);
for n = 1:length(XI(:))
        I(n) = kNN2([YI(n);XI(n)]);
end
% hold all
imagesc(yi,xi,I');
colormap(jet)




hold all
plot(X(1,y==classes(1)),X(2,y==classes(1)),'LineWidth',1.5)

for n = 2: length(classes)
%     hold all
    plot(X(1,y==classes(n)),X(2,y==classes(n)),'LineWidth',1.5)
end
hold off

axis([ymin ymax xmin xmax])



end

