close all;

addpath('../../Lecture2_data/')
addpath('../../')
blurredIm = imread('image_blurred.png');

figure;
subplot 131, imshow(blurredIm)

% Create PSF
estimatedPSF = zeros(477);
rows = 100:377;
cols = 239;
nRows = length(rows);
nCols = length(cols);

linePSF = ones(nRows,1);
windowRow = hamming(nRows);
windowCol = ones(nCols,1);
linePSF = windowRow.*linePSF;
rectPSF = repmat(linePSF,1,nCols);
rectPSF = rectPSF.*repmat(windowCol',nRows,1);
estimatedPSF(rows,cols) = rectPSF;
estimatedPSF = estimatedPSF ./ sum(estimatedPSF,'all');
subplot 132, imshow(estimatedPSF,[])

% Load mask
mask = logical(rgb2gray(imread('mask2.png')));
mask = cat(3,mask,mask,mask);

% Estimate noise
% bg = roipoly(blurredIm);
% bgVAR = var(im2double(blurredIm(bg)));
% NSR = bgVAR ./ var(im2double(blurredIm(:)));

% Deconvolve
deblurredImage = deconvlucy(blurredIm,estimatedPSF,5);
deblurredImage(~mask) = blurredIm(~mask);

% Filter noise
imSmall = imresize(deblurredImage, 0.25);
imSmall = imnlmfilt(imSmall, 'DegreeOfSmoothing', 5, 'SearchWindowSize', 9);
deblurredImage = imresize(imSmall, 4);
subplot 133, imshow(deblurredImage);

% Save variables
save('output.mat', 'deblurredImage', 'estimatedPSF');

[NRMSE_PSF, RMSE_Image, PSNR] = evaluateMotion('output.mat')

figure;
subplot 121, imshow(blurredIm)
subplot 122, imshow(deblurredImage)
