%% MPA-AB2 Lecture2_23_TASK2 Main Script
%  Radek Chmela, David Sidlo, Jakub Muller
% 
% % 
clear all
close all
clc
%%
load("GTencr.mat")
load("maskedImage.mat")
image= imread("image_blurred.png");
spektrum_rozmazaneho= fft2(maskedImage);
spektrum_obrazu=fft2(image);
figure
imshow(spektrum_rozmazaneho)
figure
imshow(spektrum_obrazu)
%%
spektrum= spektrum_obrazu-spektrum_rozmazaneho.*2;
figure
imshow(spektrum)
%%
figure
imshow(image)
rekon= real(ifft2(spektrum))/255;figure
imshow(rekon)
%%