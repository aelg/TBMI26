function n = randdraw(v)

% RANDDRAW draws a random integer 1<=n<=size(v) with probabilites
%          proportional to the numbers in v.

x = sum(v)*rand;
c = cumsum(v);
n = sum(x > c) + 1;