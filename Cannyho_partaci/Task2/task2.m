img = imread("image_blurred.png");
estimated_PSF = zeros(477,477);
LEN = 20;
PSF = fspecial('motion',LEN,90);
estimatedPSF(round(477/2):round(477/2)+LEN, round(477/2)) = PSF;

[J P]= deconvblind(maskedImage,estimatedPSF,5);
figure; imshow(J); title('Restored Image');
figure; imshow(P,[],'notruesize');
title('Restored PSF');