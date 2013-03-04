function C = my_crosscov(X, Y),
    Xm = mean(X);
    Ym = mean(Y);
    Xnorm = [];
    Ynorm = [];
    for i = 1:size(X, 2),
        Xnorm(:,i) = X(:,i) - Xm;
        Ynorm(:,i) = Y(:,i) - Ym;
    end
    %Xnorm
    %size(X,2)
    C = (Xnorm * Ynorm')/(size(X,2)-1);
end