% Load face and non-face data and plot a few examples
load faces, load nonfaces
faces = double(faces); nonfaces = double(nonfaces);
%{
figure(1)
colormap gray
for k=1:25
    subplot(5,5,k), imagesc(faces(:,:,10*k)), axis image, axis off
end
figure(2)
colormap gray
for k=1:25
    subplot(5,5,k), imagesc(nonfaces(:,:,10*k)), axis image, axis off
end
%}
% Generate Haar feature masks

nbrHaarFeatures = 200;
haarFeatureMasks = GenerateHaarFeatureMasks(nbrHaarFeatures);
%{
figure(3)
colormap gray
for k = 1:min(25, nbrHaarFeatures)
    subplot(5,5,k),imagesc(haarFeatureMasks(:,:,k),[-1 2])
    axis image,axis off
end
%}
% Create a training data set with a number of training data examples
% from each class. Non-faces = class label y=-1, faces = class label y=1

nbrTrainExamples = 100;
trainImages = cat(3,faces(:,:,1:nbrTrainExamples),nonfaces(:,:,1:nbrTrainExamples));
xTrain = ExtractHaarFeatures(trainImages,haarFeatureMasks);
yTrain = [ones(1,nbrTrainExamples), -ones(1,nbrTrainExamples)];

validateImages = cat(3,faces(:,:,nbrTrainExamples+1:end),nonfaces(:,:,nbrTrainExamples+1:end));
xValidate = ExtractHaarFeatures(validateImages,haarFeatureMasks);
yValidate = [ones(1, length(faces)-nbrTrainExamples), -ones(1,length(nonfaces)-nbrTrainExamples)];
nbrValidateExamples = length(faces)+length(nonfaces) - nbrTrainExamples*2;
%%

d = (ones(1,nbrTrainExamples*2))/(nbrTrainExamples*2);
nbrClassifiers = 50;
Classifiers = [];
ee = [];
dd = [];
featureMask = ones(1, nbrHaarFeatures);
for classifier = 1:nbrClassifiers,
    disp(sprintf('Classifier #: %d', classifier));
    eps = inf;
    p  = 0;
    bestTreshold = 0;
    bestFeature = 0;
    bestErrors = [];
    for k = 1:nbrHaarFeatures,
        %if(featureMask(k) == 0),
        %    continue
        %end
        bestFeatureError = 100;
        e = 0;
        [trainData I] = sort(xTrain(k,:));
        for l = 1:nbrTrainExamples*2,
            curTresh = xTrain(k, l);
            %errors = ((xTrain(k,:) < curTresh) & (yTrain == 1)) | ((xTrain(k,:) >= curTresh) & (yTrain == -1));
            %e = sum(d.*errors);
            e = e + d(I(l))*yTrain(I(l));
            if(e < eps),
                eps = e;
                p = 1;
                bestTreshold = curTresh;
                bestFeature = k;
                %bestErrors = errors;
                bestFeatureError = e;
            elseif(1 - e < eps),
                errors = ~errors;
                eps = 1 - e;
                p = -1;
                bestTreshold = curTresh;
                bestFeature = k;
                %bestErrors = errors;
                bestFeatureError = 1-e;
            end
            if(min(e, 1-e) < bestFeatureError),
                bestFeatureError = min(e, 1-e);
            end
        end
        %if sum(featureMask) > 20 && bestFeatureError > 0.2,
        %    featureMask(k) = 0;
        %end
    end
    correct = 1-bestErrors*2;
    if(eps > 0),
        alpha = log((1-eps)/eps)/2;
    else
        alpha = 100;
    end
    d = d.*exp(-correct.*alpha);
    %d = max(0.1/(nbrTrainExamples*2), d);
    %d = min(10/(nbrTrainExamples*2), d);
    %d = d/sum(d);
    Classifiers = [Classifiers; eps bestFeature bestTreshold p alpha sum(bestErrors)];
    ee = [ee; bestErrors];
    ee = [ee; correct];
    dd = [dd; d];
end
%{
figure(4)
colormap gray
for k = 1:min(25, nbrTrainExamples*2)
    subplot(5,5,k),imagesc(trainImages(:,:,k))
    if(xTrain(bestFeature, k)*p >= p*bestTreshold),
        hold on;
        plot(0, 0, 'go');
        hold off;
    else
        hold on;
        plot(0, 0, 'ro');
        hold off;
    end
    axis image,axis off
end
%}

nbrCorrect = 0;
for k = 1:nbrTrainExamples*2,
    res = 0;
    if(sum((2*(xTrain(Classifiers(:,2), k).*Classifiers(:,4) >= Classifiers(:,4).*Classifiers(:,3))-1).*Classifiers(:,5)) > 0)
        res = 1;
    else
        res = -1;
    end
    if(res == yTrain(k)),
        nbrCorrect = nbrCorrect + 1;
    end
end
disp(sprintf('Training: %d of %d (%0.4f%%) correct', nbrCorrect, nbrTrainExamples*2, 100*nbrCorrect/(nbrTrainExamples*2)));

nbrCorrect = 0;
for k = 1:nbrValidateExamples,
    res = 0;
    if(sum((2*(xValidate(Classifiers(:,2), k).*Classifiers(:,4) >= Classifiers(:,4).*Classifiers(:,3))-1).*Classifiers(:,5)) > 0)
        res = 1;
    else
        res = -1;
    end
    if(res == yValidate(k)),
        nbrCorrect = nbrCorrect + 1;
    end
end
disp(sprintf('Validation: %d of %d (%0.4f%%) correct', nbrCorrect, nbrValidateExamples, 100*nbrCorrect/(nbrValidateExamples)));