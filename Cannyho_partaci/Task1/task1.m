obr = imread('image_blurred.png');
LEN = 100; THETA = 90;
PSF = fspecial('motion', LEN, THETA);
estimatedPSF = zeros(477,477);
estimatedPSF(round(477/2):round(477/2)+LEN,round(477/2)) = PSF;

filtered = deconvlucy(maskedImage,estimatedPSF);
filtered_gauss = imgaussfilt(filtered,4);
filtered_nlm = imnlmfilt(filtered_gauss);

[a b] = find(BW==1);
for i = 1:length(a)
    obr(a(i),b(i),1) = filtered_nlm(a(i),b(i),1);
    obr(a(i),b(i),2) = filtered_nlm(a(i),b(i),2);
    obr(a(i),b(i),3) = filtered_nlm(a(i),b(i),3);
end

deblurredImage = imgaussfilt(obr,4);

figure
subplot 211
imshow(deblurredImage)
subplot 212
imshow(estimatedPSF,[])