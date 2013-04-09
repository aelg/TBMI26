load countrydata;

C = my_cov(countrydata);
figure(1);
colormap gray;
imagesc(C);
colorbar;
title('Covariance');

C = my_corr(countrydata);
figure(2);
colormap gray;
imagesc(C);
colorbar;
title('Correlation');

%PCA
normCountrydata = my_norm(countrydata);
%C
C = my_corr(normCountrydata)

figure(3);
[U S V] = svd(C)
plot(diag(S), 'bo');

W = U(:,1:2);

figure(4);
clf;
Y = W'*normCountrydata;
classcolor = ['ro', 'go', 'bo'];
classcolor
for k = 1:length(normCountrydata),
    plot(Y(1,k), Y(2,k), classcolor(int8(countryclass(k)*2:countryclass(k)*2+1)+1));
    hold on;
end
plot(Y(1,42), Y(2,42), 'xr');
for i = 1:length(countries),
    disp(i)
    disp(countries(i,:))
end
