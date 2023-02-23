obr = imread('image_blurred.png');
% gray = rgb2gray(obr);
LEN = 20; THETA = 90;
PSF = fspecial('motion', LEN, THETA);
estimatedPSF = zeros(477,477);
estimatedPSF(round(477/2):round(477/2)+LEN,round(477/2)) = PSF;
% PSF2(PSF2>0) = 1;
% estimatedPSF = imrotate(estimatedPSF,135);

% % 
% segmented = imcrop(obr, [1000 5000 1000 5200]);
% segmented = load("segmented2.mat");
% segmented = segmented.segmented2;
x1 = 1;
y1 = 700;
x2 = 5184;
y2 = 2706;
segmented = imcrop(obr, [x1,y1,x2,y2]);imshow(segmented)

filtered = deconvlucy(segmented,estimatedPSF);
%imshow(filtered)
filtered_gauss = imgaussfilt(filtered,4);

final = [obr(1:y1,:,:);filtered_gauss;obr(3408:end,:,:)];
filtered_nlm = imnlmfilt(final);

deblurredImage = imgaussfilt(filtered_nlm,4);
imshow(final)


figure
subplot 211
imshow(deblurredImage)
subplot 212
imshow(estimatedPSF,[])