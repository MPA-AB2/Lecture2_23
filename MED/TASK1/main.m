image = imread("Lecture2_data\image_blurred.png");
figure
imshow(image);
title("Deformed")

std_R_noise = std(reshape(double(image(306:486, 1510:1666, 1)), 1, []));
std_G_noise = std(reshape(double(image(306:486, 1510:1666, 2)), 1, []));
std_B_noise = std(reshape(double(image(306:486, 1510:1666, 3)), 1, []));

std_noise_mean = mean([std_R_noise, std_G_noise, std_B_noise]);

std_R = std(reshape(double(image(:, :, 1)), 1, []));
std_G = std(reshape(double(image(:, :, 2)), 1, []));
std_B = std(reshape(double(image(:, :, 3)), 1, []));

std_mean = mean([std_R, std_G, std_B]);

NSR = std_noise_mean^2 / std_mean^2;

% imp_char = zeros(477);
% imp_char(180:290,238) = 1;
% imp_char = imp_char / sum(sum(imp_char));

mu = [0 0]; Sigma = [.0025 .0; .0 .3];
[X1,X2] = meshgrid(linspace(-3,3,477)', linspace(-3,3,477)');
X = [X1(:) X2(:)];
p = mvnpdf(X, mu, Sigma);
imp_char = reshape(p, 477, 477);
imp_char = imp_char / sum(sum(imp_char));


figure
imshow(imp_char, [])
title("PSF")

filtered = deconvwnr(image,imp_char, NSR);
figure
imshow(filtered)
title("Reconstructed")
%% Segmentation
figure
imshow(image);
polyg = impoly;
BW1 = createMask(polyg);

%%
kernel_size = 45;
mu = [0 0]; Sigma = [.8 .2; .2 .8];
[X1,X2] = meshgrid(linspace(-3,3,kernel_size)', linspace(-3,3,kernel_size)');
X = [X1(:) X2(:)];
p = mvnpdf(X, mu, Sigma);
Gau = reshape(p, kernel_size, kernel_size);
Gau = Gau/sum(sum(Gau));

BW = conv2(BW1,Gau, 'same');
BW = cat(3, BW, BW, BW);
%% Augumentation

im_blurred = im2double(filtered) .* BW;
im_sharp = im2double(image) .* (1-BW);

final_image = im_blurred + im_sharp;


figure
subplot 221; imshow(image); title('Original image');
subplot 222; imshow(BW); title ('Mask used for motion blur');
subplot 223; imshow(im_blurred); title('Filtered motion blur');
subplot 224; imshow(final_image); title('Final image')

