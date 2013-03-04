% Load face and non-face data and plot a few examples
load faces, load nonfaces
faces = double(faces); nonfaces = double(nonfaces);

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

% Generate Haar feature masks

nbrHaarFeatures = 200;
haarFeatureMasks = GenerateHaarFeatureMasks(nbrHaarFeatures);

figure(3)
colormap gray
for k = 1:min(25, nbrHaarFeatures)
    subplot(5,5,k),imagesc(haarFeatureMasks(:,:,k),[-1 2])
    axis image,axis off
end

% Create a training data set with a number of training data examples
% from each class. Non-faces = class label y=-1, faces = class label y=1

nbrTrainExamples = 500;
trainImages = cat(3,faces(:,:,1:nbrTrainExamples),nonfaces(:,:,1:nbrTrainExamples));
xTrain = ExtractHaarFeatures(trainImages,haarFeatureMasks);
yTrain = [ones(1,nbrTrainExamples), -ones(1,nbrTrainExamples)];

%%

% Outer for loop is to repeat the training with some new Haar features.
% In each loop the best Haar features from the previous run are saved and
% some new are generated. Hopefully there will be many good weak
% classifiers left at the end.
%for m = 1:5,
    disp(sprintf('m: %d', m));
    % Init weights
    d = (ones(1,nbrTrainExamples*2))/(nbrTrainExamples*2);
    nbrClassifiers = 60;
    %{
    if(m ~= 1), % Skip this in first run.
        % Find the ~ten most important features.
        sortedClassifiers = sortrows(Classifiers, -5);
        features = unique(sortedClassifiers(1:10,2));
        % Update xTrain.
        xTrain = xTrain(features, :);
        haarFeatureMasks = cat(3, haarFeatureMasks(:,:,features), GenerateHaarFeatureMasks(nbrHaarFeatures-length(features)));
        xTrain =[ExtractHaarFeatures(trainImages,haarFeatureMasks)];
    end
    %}
    Classifiers = [];
    % Find nbrClassifiers classifiers.
    for classifier = 1:nbrClassifiers,
        disp(sprintf('Classifier #: %d', classifier));
        
        % Brute force the best weak classifier
        eps = inf;
        p  = 0;
        bestTreshold = 0;
        bestFeature = 0;
        bestErrors = [];
        
        % Iterate through all features.
        for k = 1:nbrHaarFeatures,
            % Calculate error when threshould is -inf
            e = min(0, yTrain)*(-d)';
            
            % Sort on tresholds that we need to check.
            [trainData I] = sort(xTrain(k,:));
            
            % Iterate through tresholds.
            for l = 1:nbrTrainExamples*2,
                curTresh = trainData(l);
                % Update error.
                e = e + d(I(l))*yTrain(I(l));
                
                % Save if a better classifier is found.
                if(e < eps),
                    eps = e;
                    p = 1;
                    bestTreshold = curTresh;
                    bestFeature = k;
                    %bestErrors = errors;
                    bestFeatureError = e;
                elseif(1 - e < eps),
                    %errors = ~errors;
                    eps = 1 - e;
                    p = -1;
                    bestTreshold = curTresh;
                    bestFeature = k;
                    %bestErrors = errors;
                    bestFeatureError = 1-e;
                end
            end
        end
        % Find the error vector for the best classifier.
        errors = ((xTrain(bestFeature,:) < bestTreshold) & (yTrain == 1)) | ((xTrain(bestFeature,:) >= bestTreshold) & (yTrain == -1));
        if(p == -1),
            errors = ~errors;
        end
        
        % Find correct classifications.
        correct = 1-errors*2;
        if(eps > 0),
            alpha = log((1-eps)/eps)/2;
        else
            alpha = 100;
        end
        
        % Update weight vector.
        d = d.*exp(-correct.*alpha);
        % Limit max and min values of weights.
        d = max(0.1/(nbrTrainExamples*2), d);
        d = min(10/(nbrTrainExamples*2), d);
        % Normalize.
        d = d/sum(d);
        % Save classifier and some interesting stuff.
        Classifiers = [Classifiers; eps bestFeature bestTreshold p alpha sum(errors)];
    end
%end

% Calculate performance in training
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

%%

% Calculate performance on validation data.
validateImages = cat(3,faces(:,:,nbrTrainExamples+1:end),nonfaces(:,:,nbrTrainExamples+1:end));
xValidate = ExtractHaarFeatures(validateImages,haarFeatureMasks);
yValidate = [ones(1, length(faces)-nbrTrainExamples), -ones(1,length(nonfaces)-nbrTrainExamples)];
nbrValidateExamples = length(faces)+length(nonfaces) - nbrTrainExamples*2;
nbrCorrect = 0;
correctly_classified = [];
incorrectly_classified_faces = [];
incorrectly_classified_nonfaces = [];
for k = 1:nbrValidateExamples,
    res = 0;
    strong = sum((2*(xValidate(Classifiers(:,2), k).*Classifiers(:,4) >= Classifiers(:,4).*Classifiers(:,3))-1).*Classifiers(:,5));
    if(strong > 0)
        res = 1;
    else
        res = -1;
    end
    if(res == yValidate(k)), % Correctly classified.
        nbrCorrect = nbrCorrect + 1;
        correctly_classified = [correctly_classified k];
    else % Incorrectly classified.
        if(yValidate(k) == 1)
            incorrectly_classified_faces = [incorrectly_classified_faces; k strong];
        else
            incorrectly_classified_nonfaces = [incorrectly_classified_nonfaces; k strong];
        end
    end
end
disp(sprintf('Validation: %d of %d (%0.4f%%) correct', nbrCorrect, nbrValidateExamples, 100*nbrCorrect/(nbrValidateExamples)));
%%

% Plot number of correct classification on the number of weak classifiers
% used.
correct_array = [];
for i = 1:nbrClassifiers
    nbrCorrect = 0;
    for k = 1:1000,
        res = 0;
        if(sum((2*(xValidate(Classifiers(1:i,2), k).*Classifiers(1:i,4) >= Classifiers(1:i,4).*Classifiers(1:i,3))-1).*Classifiers(1:i,5)) > 0)
            res = 1;
        else
            res = -1;
        end
        if(res == yValidate(k)),
            nbrCorrect = nbrCorrect + 1;
        end
    end
    correct_array = [correct_array nbrCorrect];
end
figure(5);
plot(correct_array/10);
title('Effect of # classifiers');
xlabel('# classifiers');
ylabel('# Correct classifications (%)');
ylim([80 100]);

%%

% Find the most important Haar features.
sortedClassifiers = sortrows(Classifiers, -5);
features = unique(sortedClassifiers(:,2));
xTrain = xTrain(features, :);
haarFeatureMasks = cat(3, haarFeatureMasks(:,:,features), GenerateHaarFeatureMasks(nbrHaarFeatures-length(features)));
xTrain =[ExtractHaarFeatures(trainImages,haarFeatureMasks)];

% Plot them
figure(2);
title('Best Haar features');
colormap gray
for k = 1:min(length(features), 20)
    subplot(4,5,k),imagesc(haarFeatureMasks(:,:,features(k)),[-1 2])
    axis image,axis off
end
%%
% Plot some correctly classified images.
figure(3);
colormap gray
for k = 1:10
    subplot(4,5,k),imagesc(validateImages(:,:,correctly_classified(k)));
    if k == 3
        title('Correctly classified');
    end
    axis image,axis off
end
for k = 1:10
    subplot(4,5,k+10),imagesc(validateImages(:,:,correctly_classified(k+5000)))
    axis image,axis off
end

%%
% Plot some incorrectly classified images.
figure(4);
hold off;
incorrectly_classified_nonfaces = sortrows(incorrectly_classified_nonfaces,2);
incorrectly_classified_faces = sortrows(incorrectly_classified_faces,2);
colormap gray
for k = 1:10
    subplot(4,5,k),imagesc(validateImages(:,:,incorrectly_classified_faces(k,1)));
    if k == 3
        title('Incorrectly classified faces');
    end
    axis image,axis off
end

for k = 1:10
    subplot(4,5,k+10),imagesc(validateImages(:,:,incorrectly_classified_nonfaces(k,1)));
    if k == 3
        title('Incorrectly classified nonfaces');
    end
    axis image,axis off
end