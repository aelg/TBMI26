function [ w alpha] = SVM2( X, d, C)
%SVM1 Trains a SVM
%   Takes a matrix X of size (numFeatures x numSamples) and a vector d
%   containing the classes coded as +1/-1 (length numSamples)
%   C is a scalar (C > 0) 
%
%   Returns the parameter vector w [b w1 w2 ... ]'

%%
[nFeatures nSamples] = size(X);


options = optimset('Algorithm','active-set');
options.MaxIter = 10000;
alpha = quadprog(diag(d)*(X)'*X*diag(d), -ones(nSamples,1),[],[],d',0,zeros(nSamples,1), C * ones(nSamples,1),[],options);

supportVectors = find(alpha > 1e-4 * C);
w = X*(alpha.*d);
%

nSV = length(supportVectors);
b = 0;
for n = 1:nSV
    tmp = 0;
    bSV = supportVectors(n);
    for m = 1:nSV
        cSV = supportVectors(m);
        tmp = tmp + alpha(cSV)*d(cSV)*X(:,cSV)'*X(:,bSV);
    end
    
    b = b + d(bSV) - tmp;
    
    
end

b = b/nSV;

w = [b; w];




end

