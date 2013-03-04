nbrTrain = 60;

[dummy,i]=sort(rand(1000,1),1,'ascend'); %From 1000 samples ...
i=i(1:nbrTrain); %... we choose 10 at random
[a, b, c] = backprop_network(X2(:,i), D2(:,i), Xt2, Dt2, Xe2);