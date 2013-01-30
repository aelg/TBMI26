function [] = kNN_Eval_Brain(k)
%KNN_EVAL_BRAIN Summary of this function goes here
%   Detailed explanation goes here
%%

if nargin < 1
    k = 3;
end

% Load images
T1 = sum(imread('T1image.png'),3)/3;
T2 = sum(imread('T2image.png'),3)/3;
T1 = T1(33:374,89:493);
T2 = T2(33:374,89:493);
load brainmasks

T1masked = zeros([size(T1,1) size(T1,2) 3]); 
T1Masked(:,:,1) = T1.*~whiteMask.*~grayMask;
T1Masked(:,:,2) = T1.*~csfMask.*~grayMask;
T1Masked(:,:,3) = T1.*~whiteMask.*~csfMask;
% Plot images
figure(1)
imagesc(T1Masked/255)
axis image
colormap(gray)
title('MRI: T1 Image')


T2masked = zeros([size(T2,1) size(T2,2) 3]); 
T2Masked(:,:,1) = T2.*~whiteMask.*~grayMask;
T2Masked(:,:,2) = T2.*~csfMask.*~grayMask;
T2Masked(:,:,3) = T2.*~whiteMask.*~csfMask;

figure(2)
imagesc(T2Masked/255)
axis image
colormap(gray)
title('MRI: T2 Image')

% Extract samples from masks
x1 = [T1(csfMask == 1); T1(whiteMask == 1); T1(grayMask == 1)]';
x2 = [T2(csfMask == 1); T2(whiteMask == 1); T2(grayMask == 1)]';
y = [csfMask(csfMask == 1)==1; whiteMask(whiteMask == 1)*2; grayMask(grayMask == 1)*3]';
X = [x1;x2];

% Classify pixels
display('Running kNN on the brain MRI data. Please hold.')
figure(3)
plot_Brain(T1,T2,X,y,k);
colormap([0 0 0; 1 0 0; 0 1 0; 0 0 1])
display('Done!')

end

function im = plot_Brain(T1,T2,X,y,k)
    
    im = zeros(size(T1));
    for m = 1:size(im,1)
        for n = 1:size(im,2)
            if T1(m,n) + T2(m,n) ~= 0
                im(m,n) = kNN([T1(m,n);T2(m,n)],X,y,k);
            end
        end
    end
    
    imagesc(im)
    
end
