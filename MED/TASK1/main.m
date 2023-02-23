image = imread("Lecture2_data\image_blurred.png");
% figure
% imshow(image);
% title("Deformed")

std_R_noise = std(reshape(double(image(306:486, 1510:1666, 1)), 1, []));
std_G_noise = std(reshape(double(image(306:486, 1510:1666, 2)), 1, []));
std_B_noise = std(reshape(double(image(306:486, 1510:1666, 3)), 1, []));

std_noise_mean = mean([std_R_noise, std_G_noise, std_B_noise]);

std_R = std(reshape(double(image(:, :, 1)), 1, []));
std_G = std(reshape(double(image(:, :, 2)), 1, []));
std_B = std(reshape(double(image(:, :, 3)), 1, []));

std_mean = mean([std_R, std_G, std_B]);

NSR = std_noise_mean^2 / std_mean^2;

imp_char_pom = zeros(477);
%imp_char_pom(:,239) = 1;
% imp_char = imp_char / sum(sum(imp_char));

mu = [0 0]; Sigma = [.0002 .0; .0 .5]; %%nejlepší 0.0002 0.3
[X1,X2] = meshgrid(linspace(-3,3,477)', linspace(-3,3,477)');
X = [X1(:) X2(:)];
p = mvnpdf(X, mu, Sigma);
imp_char = reshape(p, 477, 477);
imp_char_pom(:,239) = imp_char(:,239);
imp_char_pom = imp_char_pom / sum(sum(imp_char_pom));



% figure
% imshow(imp_char, [])
% title("PSF")

%filtered = deconvwnr(image,imp_char, NSR);
% figure
% imshow(filtered)
% title("Reconstructed")
%% Segmentation
% figure
% imshow(image);
% polyg = impoly;
% BW1 = createMask(polyg);
load('mask1.mat')
%%
kernel_size = 45;
mu = [0 0]; Sigma = [50 12; 12 50];%nej: [.8 .2; .2 .8]
[X1,X2] = meshgrid(linspace(-3,3,kernel_size)', linspace(-3,3,kernel_size)');
X = [X1(:) X2(:)];
p = mvnpdf(X, mu, Sigma);
Gau = reshape(p, kernel_size, kernel_size);
Gau = Gau/sum(sum(Gau));

BW = conv2(BW1,Gau, 'same');
BW = cat(3, BW, BW, BW);
%% Filtration of background

imR = image(:,:,1);
imG = image(:,:,2);
imB = image(:,:,3);

obr_vyfilR = wiener2(imR,[6 6]);%% nejlepší 6 6
obr_vyfilG = wiener2(imG,[6 6]);
obr_vyfilB = wiener2(imB,[6 6]);

im_filt = cat(3,obr_vyfilR,obr_vyfilG,obr_vyfilB);
%% Augumentation
filtered = deconvwnr(im_filt,imp_char_pom, NSR);
im_blurred = im2double(filtered) .* BW;
im_sharp = im2double(im_filt) .* (1-BW);

final_image = im_blurred + im_sharp;
final_image = im2uint8(final_image);

deblurredImage = final_image;
estimatedPSF = imp_char_pom;

% figure;imshow(final_image); title('Final image')

figure;sgtitle('NRMSE = 0.00032096; RMSEImage = 5.5550; PSNR = 25.1861');
subplot 121;imshow(final_image);title('Final Image');
subplot 122;imshow(estimatedPSF,[]);title('PSF');