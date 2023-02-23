mu = [0 0]; Sigma = [.9 .0; .0 .1];
[X1,X2] = meshgrid(linspace(-3,3,477)', linspace(-3,3,477)');
X = [X1(:) X2(:)];
p = mvnpdf(X, mu, Sigma);
surf(X1,X2,reshape(p,477,477));

[h, w, ~] = size(image);

distortion_map = zeros(h, w);
rad = 10;
for r = 1+rad:h-rad
    for c = 1:w
        distortion_map(r, c) = std(double(image(r-rad:r+rad, c)));
    end
end

figure
imshow(distortion_map(rad+1:h-rad-1, :), [])