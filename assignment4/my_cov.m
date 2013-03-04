function C = my_cov(X),
    m = mean(X);
    Xnorm = [];
    for i = 1:size(X, 2),
        Xnorm(:,i) = X(:,i) - m;
    end
    C = (Xnorm * Xnorm')/(size(X,2)-1);
end