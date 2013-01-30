function [ w ] = SVM1( X, d)
%SVM1 Trains a SVM
%   Takes a matrix X of size (numFeatures x numSamples) and a vector d
%   containing the classes coded as +1/-1 (length numSamples)
%
%   Returns the parameter vector w [b w1 w2 ... ]'

%%
[nFeatures nSamples] = size(X);

H = eye(nFeatures+1);
H(1,1) = 0;
f = zeros(nFeatures+1,1);

A = diag(d)*[ones(nSamples,1) X'];

c = ones(nSamples,1);
options = optimset('Algorithm','active-set');

w = quadprog(H,f,-A,-c,[],[],[],[],[],options);


end

