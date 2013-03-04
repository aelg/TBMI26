function m = mean(X),
    m = sum(X, 2)./size(X, 2);
end