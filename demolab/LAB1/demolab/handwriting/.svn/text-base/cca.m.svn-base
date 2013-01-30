function [rho,wx,wy] = cca(x,y)
%
% [rho,wx,wy] = cca(x,y)
%
% Calculates the canonical correlation
%
% x and y are [dimension x observations] matrices where the number of
% observations must be equal but the dimensions may differ.
%


[dimx,N] = size(x);
[dimy,N] = size(y);

mx = sum(x,2)/N;
x = x - mx(:,ones(1,N));
my = sum(y,2)/N;
y = y - my(:,ones(1,N));

z = [x;y];
C = 1/N*z*z';

Cxx = C(1:dimx,1:dimx);
Cyy = C(dimx+1:end,dimx+1:end);
Cxy = C(1:dimx,dimx+1:end);
Cyx = Cxy';

invCyy = inv(Cyy);
[wx,rho] = sorteig(inv(Cxx)*Cxy*invCyy*Cyx);
rho = sqrt(rho(1));
wx = wx(:,1);
wy = invCyy*Cyx*wx;
wy = wy/norm(wy);
