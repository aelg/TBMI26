function cOut = kNN( x, Y, c, k)
%KNN Your own kNN classifier!
%   ‘cOut’ will be your output from kNN() and should thus be one of the
%   classes defined in ‘c’.
%
%   ‘x’ is the feature vector we want to classify
%
%   ‘Y’ is a matrix containing the training feature vectors used to classify 
%   new vectors
%
%   ‘c’ is a vector containing the class of every vector in ‘Y’
%
%   ‘k’ is the number of neighbours that will participate in the voting
%   procedure.
%
%   There are many ways to implement kNN, but the functions max, hist, sort
%   and sum might be worth looking at. (Ie type 'help sum' or 'doc sum')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Enter you own code here %
%%%%%%%%%%%%%%%%%%%%%%%%%%%


% To start with cOut will be given a random class between 1 and 3
%cOut = round(rand(1)*3+1);

%Calculate all distances to x
dist = zeros(length(Y), 1);
for i = 1:length(Y),
    dist(i) = sum( (Y(:,i)-x).^2 );
end

% Sort distances
[A,I] = sort(dist);

% Pick out k nearest neighbours and save their classes.
classes = zeros(k, 1);
for i = 1:k,
    classes(i) = c(I(i));
end

% Create a histogram of classes.
[N,X] = hist(classes, length(c));

% Find largest bin
[ma, Ind] = max(N);

% Return class of largest bin
cOut = X(Ind);

end

