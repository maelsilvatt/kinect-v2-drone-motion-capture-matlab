close all; % DEBUG: fecha todas as janelas ativas

%% Carregar a imagem
image = imread('input_image.png');

%% Conversão RGB para HSV
hsv_image = rgb2hsv(image);

%% Definir os valores HSV da cor desejada (vermelho)
h_color = 0.1; % matiz média
s_min = 0.65; % saturação mínima
v_min = 0.7; % valor mínimo
v_max = 0.9; % valor máximo

%% Criar a máscara baseada nos valores HSV definidos
color_threshold = 1;
mask = (hsv_image(:,:,1) >= (h_color - color_threshold)) & ...
          (hsv_image(:,:,1) <= (h_color + color_threshold)) & ...
          (hsv_image(:,:,2) >= s_min) & ...
          (hsv_image(:,:,3) >= v_min) & ...
          (hsv_image(:,:,3) <= v_max);

%% Exibir a máscara
%imshow(mask);

%% Aplicar a máscara à imagem original
color_mask = bsxfun(@times, image, cast(mask, 'like', image));
%imshow(color_mask);

% %% Aplicar erosão à máscara
% se1 = strel('disk', 10); % raio do disco de erosão
% im_erod = imerode(color_mask, se1);
% %imshow(im_erod);
% 
% %% Aplicar dilação à máscara
% se2 = strel('disk', 30); % raio do disco de dilação
% im_dil = imdilate(im_erod, se2);
% %imshow(im_dil);

%% Binarização da imagem
bw_threshold = 0.1; % limiar de binarização
gray_image = rgb2gray(im_dil);
bw_image = imbinarize(gray_image, bw_threshold);
imshow(bw_image);

%% Obtendo o centroide do círculo pela Transformada de Hough
[centroid, radii] = imfindcircles(bw_image, [30, 150]);

% Exiba a imagem com os círculos detectados
%imshow(image);
%viscircles(centroid, radii);

