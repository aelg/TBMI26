

%{
prototypes = [];
for k = 0:9,
    figure(1);
    disp(sprintf('Draw a %d!', k));
    prototypes(:,:,k+1) = draw(1, 200);
end
%}

figure(1);
y = draw(1, 200);

Cyy = my_cov(y);
%Cyy =  y(:)*y(:)';

a = [];

for k = 0:9,
    Cxy = my_crosscov(prototypes(:,:,k+1),y);
    Cyx = my_crosscov(y,prototypes(:,:,k+1));
    Cxx = my_cov(prototypes(:,:,k+1));
    %Cxx = reshape(prototypes(:,:,k+1), 40,1)*reshape(prototypes(:,:,k+1), 40, 1)';
    %Cxy = reshape(prototypes(:,:,k+1), 40,1)*y(:)';
    %Cyx = y(:)*reshape(prototypes(:,:,k+1), 40,1)';
    %[U, D, V] = svd(inv(Cxx)*Cxy*inv(Cyy)*Cyx);
    [ev1,ee1] = sorteig(inv(Cxx)*Cxy*inv(Cyy)*Cyx);
    [ev2,ee2] = sorteig(inv(Cyy)*Cyx*inv(Cxx)*Cxy);
    a(k+1) = [ee1(1)];
    %eigg = max(b)
    %svdd = D(1,1);
    %a(k+1) = D(1,1);
    %D(1,1)
    %[U, D, V] = svd(inv(Cyy)*Cyx*inv(Cxx)*Cxy);
    %a(k+1) = abs(a(k+1)-D(1,1));
    %D(1,1)
    disp('asdf')
end

[dummy, I] = sort(a,'descend');
I - 1 
a

%Cxy = my_crosscov(prototypes(:,:,k+1)',y') - my_crosscov(y',prototypes(:,:,k+1)')
