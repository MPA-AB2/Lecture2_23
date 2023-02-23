obr = imread('image_blurred.png'); 
LEN = 10; THETA = 90;
PSF = fspecial('motion', LEN, THETA);
PSF2 = zeros(477,477);
PSF2(round(477/2):round(477/2)+10,round(477/2)) = PSF;
[j psfr] = deconvblind(maskedImage,PSF2);
%%
j_gauss = imgaussfilt(j,4);
j = imnlmfilt(j_gauss);
%%
[a b] = find(BW==1);
for i = 1:length(a)
    obr(a(i),b(i),1) = j(a(i),b(i),1);
    obr(a(i),b(i),2) = j(a(i),b(i),2);
    obr(a(i),b(i),3) = j(a(i),b(i),3);
end
%%
recon = deconvlucy(obr,psfr);
%%
figure(1)
subplot 131
imshow(imread('sample.png'))
title('orig')
subplot 132
imshow(obr)
title('1st')
subplot 133
imshow(recon)
title('2nd')
