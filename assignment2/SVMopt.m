%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Create some training data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% First we create some training data
% Class 1
mu1 = [-1;2]; % the mean vector
sigma1= 0.5; % Standard deviation
% Class 2
mu2 = [1;0];
sigma2 = 0.5;

% How many samples do we want of each class?
nsmp1 = 100;
nsmp2 = 100;
% Create the samples
x1 = bsxfun(@plus,sigma1*randn(2,nsmp1),mu1);
x2 = bsxfun(@plus,sigma2*randn(2,nsmp2),mu2);

% Create the X and d vector
X = [x1 x2];
d = ones(size(X,2),1);
d(1:nsmp1) = - 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% First SVM Implementation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Optimize SVM
w = SVM1(X,d);

% Plot Data

figure(1),clf
hold on
plot(x1(1,:),x1(2,:),'.r')
plot(x2(1,:),x2(2,:),'.b')
axisSize = axis;
t = linspace(axisSize(1),axisSize(2),100);
dline = -(w(1) + w(2)*t)/w(3);
plot(t,dline,'k-','linewidth',2)
axis(axisSize)
hold off
title('Solution using the first SVM implementation')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Second SVM Implementation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set C (C > 0)
C = 3;

% Optimize SVM
[w alphas] = SVM2(X,d, C);

% Plot Data

figure(2), clf
hold on
plot(x1(1,:),x1(2,:),'.r')
plot(x2(1,:),x2(2,:),'.b')
axisSize = axis;
t = linspace(axisSize(1),axisSize(2),100);
dline = -(w(1) + w(2)*t)/w(3);
plot(t,dline,'k-','linewidth',2)
axis(axisSize)
hold off
title('Solution using the second SVM implementation')