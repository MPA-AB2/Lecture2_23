%nacteni obrazu
obr = im2double(imread('Lecture2_data\image_blurred.png'));
segmented = im2double(imread('Lecture2_data\OstrihanaZ.png'));

zel = segmented(1877,4930,:);

r = obr(:,:,1);
g = obr(:,:,2);
b = obr(:,:,3);

%imshow(obr)
%%
%odhad PSF
PSF = zeros(477);
PSF(162:314,239) = 1/152;

%%
%r = imgaussfilt(r,8);
%g = imgaussfilt(g,8);
%b = imgaussfilt(b,8);
r = medfilt2(r,[5 5]);
g = medfilt2(g,[5 5]);
b = medfilt2(b,[5 5]);

obrnew = zeros(3456,5184,3);
obrnew(:,:,1) = r;
obrnew(:,:,2) = g;
obrnew(:,:,3) = b;
%%

sr = estimate_noise(r);
sg = estimate_noise(g);
sb = estimate_noise(b);
%%
r = imgaussfilt(r,sr);
g = imgaussfilt(g,sg);
b = imgaussfilt(b,sb);

%%
obr_filt = zeros(3456,5184,3);
obr_filt(:,:,1) = r;
obr_filt(:,:,2) = g;
obr_filt(:,:,3) = b;
%figure
%imshow(r)
%%


r_filtered = deconvwnr(r,PSF,100);
g_filtered = deconvwnr(g,PSF,100);
b_filtered = deconvwnr(b,PSF,100);

%figure
%subplot 131
%imshow(r_filtered,[])
%subplot 132
%imshow(g_filtered,[])
%subplot 133
%imshow(b_filtered,[])


%%
final_im = zeros(3456,5184,3);
final_im(:,:,1) = r_filtered*100;
final_im(:,:,2) = g_filtered*100;
final_im(:,:,3) = b_filtered*100;

figure
imshow(final_im,[])
%%
obrnew(segmented == zel)=final_im(segmented == zel);

figure
imshow(obrnew)

%%
obrnew = obrnew*255;
%%
deblurredImage = uint8(obrnew);
estimatedPSF = PSF;
%imwrite(obr,'obr.png')
%%
