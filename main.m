clc;
clear;
close all;

addpath('Dataset');
% addpath('D:\Tezpur University\PhD\Sparse Classification\Feature_Multi');

load Indian_pines_corrected;
load Indian_pines_gt;

ori_data = indian_pines_corrected;
GT= indian_pines_gt;
[M,N,K]=size(ori_data);

% Number of principal component
Nu = 15;
Data = zeros([M,N,Nu]);
pca_data = reshape(ori_data,[M*N,K]);
[coeff,~] = pca(pca_data);
coeff = coeff(:,1:Nu);
pca_data = pca_data * coeff;

for i=1:Nu
    Data(:,:,i) = reshape(pca_data(:,i),[M, N]);
    Data(:,:,i) = (Data(:,:,i) - min(min(Data(:,:,i))))/(max(max(Data(:,:,i)))-min(min(Data(:,:,i))));
    Data(:,:,i) = ceil(Data(:,:,i) * 1000);
end


% All_data = double(Data(:,:,1:15));
All_data = Data;
pix_pos = ones([size(All_data,1),size(All_data,2)]);

Multi_scale_Patchsize = [5 7 9 11 13 15 17 19 21 23 25 27]; 

scale_num = length(Multi_scale_Patchsize);   
Multi_scale_PS_H = [];
for i = 1:scale_num
 Multi_scale_PS_H(i) = floor(Multi_scale_Patchsize(i)/2);  
end

multiscalemap = 1: Multi_scale_Patchsize(end)*Multi_scale_Patchsize(end);
multiscalemap = reshape(multiscalemap,[Multi_scale_Patchsize(end) Multi_scale_Patchsize(end) ]);

xx = Multi_scale_PS_H(end)+1;
yy = Multi_scale_PS_H(end)+1;
%Gerate the neighbors for each scale
scale_index = {};
for ss = 1:scale_num
  index_temp = multiscalemap((xx-Multi_scale_PS_H(ss)):(xx+Multi_scale_PS_H(ss)),(yy-Multi_scale_PS_H(ss)):(yy+Multi_scale_PS_H(ss)));
  index_vec = index_temp(:)'; 
  scale_index{ss} = index_vec;
end

%clear temp variables
clear index_temp
clear index_vec xx yy

Fimg = MRSSF(All_data, pix_pos, Multi_scale_PS_H,scale_index,scale_num);

%%%% Train and Testing
[SM, Tr_Class, Testing_data, T_Class] = Train_Test(Fimg, GT);

[accr1, accr2, kappa] = KJSRC_Classifier(Fimg, GT, SM, Tr_Class, T_Class);