image = imread("Lecture2_data\image_blurred.png");

im2 = imresize(image, 0.125);
figure
imshow(im2)
title("Downsampled")

%% Prepare estimate of PSF
window = 41;
mu = [0 0]; Sigma = [.0001 .0; .0 .6];
[X1,X2] = meshgrid(linspace(-3,3,window)', linspace(-3,3,window)');
X = [X1(:) X2(:)];
p = mvnpdf(X, mu, Sigma);
psf_est = reshape(p, window, window);
psf_est = psf_est / sum(sum(psf_est));

%% deconvolove
[J,psfr] = deconvblind(im2,psf_est);

prelim_result = imresize(J, 8);

figure
imshow(prelim_result)
title("Upsampled")

%% Prepare mask
load('mask.mat')

kernel_size = 45;
mu = [0 0]; Sigma = [.8 .2; .2 .8];
[X1,X2] = meshgrid(linspace(-3,3,kernel_size)', linspace(-3,3,kernel_size)');
X = [X1(:) X2(:)];
p = mvnpdf(X, mu, Sigma);
Gau = reshape(p, kernel_size, kernel_size);
Gau = Gau/sum(sum(Gau));

BW = conv2(BW1,Gau, 'same');
BW = cat(3, BW, BW, BW);

%% Fuse images

im_blurred = im2double(prelim_result) .* BW;
im_sharp = im2double(image) .* (1-BW);
final_image = im_blurred + im_sharp;
final_image = im2uint8(final_image);

deblurredImage = final_image;
estimatedPSF = imresize(psfr,[477,477],'Method','bilinear');

figure;sgtitle('NRMSE = 0.6833; RMSEImage = 7.1373; PSNR = 23.5103');
subplot 121;imshow(final_image);title('Final Image');
subplot 122;imshow(estimatedPSF,[]);title('PSF');