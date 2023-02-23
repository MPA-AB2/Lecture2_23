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
PSF(168:308,238) = 1/140;

%%

r = medfilt2(r);
g = medfilt2(g);
b = medfilt2(b);


%%

sr = estimate_noise(r);
sg = estimate_noise(g);
sb = estimate_noise(b);
%%

r = imgaussfilt(r,sr);
g = imgaussfilt(g,sg);
b = imgaussfilt(b,sb);

%%
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
obr(segmented == zel)=final_im(segmented == zel);

figure
imshow(obr)