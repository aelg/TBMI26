function N = my_norm(X),
    N = [];
    XVar = diag(my_cov(X));
    for i = 1:size(X, 1),
        N(i,:) = X(i,:)/sqrt(XVar(i,:));
    end
end