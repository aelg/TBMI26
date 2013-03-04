function C = my_corr(X),
    C = my_cov(X);
    S = diag(C);
    V = S*S';
    C = C./sqrt(V);
end