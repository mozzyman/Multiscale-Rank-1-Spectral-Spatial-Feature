function [accr1, accr2, kappa] = KJSRC_Classifier(Fimg, GT, SM, Tr_Class, T_Class)

disp('Classifying...')

[M,N,~] = size(Fimg);

Suc = [];

ClassesNumber = length(unique(GT))-1;

%%% Sparsity level
K = 30;

%%% Scale can be change depending on the dataset
Scale = 3;
scale_PS_H = floor(Scale/2);

% Range between [2^4 - 2^7]
gamma = 2^7;  
% padding the image
N_Fimg = padarray(Fimg,[scale_PS_H, scale_PS_H],'symmetric','both');

ROI = zeros([size(Fimg,1) * size(Fimg,2),1]);

%%
for z=1:1
    
    tic
    
    Tr_S = [];
    for i=1:ClassesNumber
        Tr_S = [Tr_S size(find(Tr_Class==i),2)];
    end
    
    TT_index = find(T_Class ~=0);
    [row, col] = ind2sub([M, N], TT_index');
%     Testing_data = reshape(Testing_data, [size(Testing_data,1) * size(Testing_data,2), size(Testing_data,3)])';
%     Testing_data = Testing_data(:,TT_index);
    roi=zeros(size(TT_index));
    
    mappedTrains = fxkernel(gamma, SM, SM);
    parfor i=1:size(TT_index,1)
        
      % disp(i)
        X = row(i);
        Y = col(i);
        
        X_new = X+scale_PS_H;
        Y_new = Y+scale_PS_H;
        X_range = (X_new-scale_PS_H : X_new+scale_PS_H);
        Y_range = (Y_new-scale_PS_H : Y_new+scale_PS_H);
          
        tt_dat_temp = N_Fimg(X_range, Y_range,:);
        [r,c,b]=size(tt_dat_temp);
        Data = reshape(tt_dat_temp,[r*c, b])';
        F1 = find(sum(Data,1)==0);
        Data(:,F1) = [];
        Data = Data ./ vecnorm(Data,2);
        Data(:,~any(~isnan(Data)))=[];
        S = size(Data,2);
        
        mappedAY = fxkernel(gamma, SM, Data);
        X = Skomp(mappedTrains, mappedAY, S, K);
        
        Residue = [];
        l1=1; l2 = Tr_S(1);
        Alpha = zeros(size(SM,2),S);
        K_A = zeros(size(mappedTrains));
        for k=1:1:ClassesNumber
            k_ax = mappedAY(l1:l2,:);
            K_A = mappedTrains(l1:l2,l1:l2);
            Alpha = X(l1:l2,:);
            T = 1 - 2 * Alpha' * k_ax + Alpha' * (K_A * Alpha);
            Residue = [Residue sum(vecnorm(T))];
            
            if(k < ClassesNumber)
                l1 = l2 + 1;
                l2 = l2 + Tr_S(k+1);
            end
        end
        minimum = min(Residue);
        
        roi(i) = find(Residue==minimum);
        
    end
    
    %%
    ROI(TT_index) = roi;
    ROI = reshape(ROI, [size(GT,1), size(GT,2)]);
    success_rate = zeros(ClassesNumber,1);
    for i=1:size(ROI,1)
        for j=1:size(ROI,2)
            if(T_Class(i,j) == ROI(i,j) && T_Class(i,j)~=0)
                success_rate(T_Class(i,j))= success_rate(T_Class(i,j))+1;
            end
        end
    end
    
    for lb=1:1:ClassesNumber
        success_rate(lb)=success_rate(lb)*100/(size(find(T_Class==lb),1));
    end
    
    Suc = [Suc success_rate];
    
    index2 = find(T_Class~=0);
    ROI_accr = ROI(index2);
    Class_accr = T_Class(index2);
    
    accr1 = (size(find(Class_accr==ROI_accr),1)*100)/size(index2,1);
    accr2 = sum(success_rate)/ClassesNumber;
    
    confmat=zeros(max(ClassesNumber),max(ClassesNumber));
    for i=1:1:size(Class_accr,1)
        confmat(Class_accr(i),ROI_accr(i))=confmat(Class_accr(i),ROI_accr(i))+1;
    end
    
    r=sum(confmat,2);   %sum the rows of the confusion matrix
    c=sum(confmat,1);   %sum the columns of the confusion matrix
    a=sum(diag(confmat));
    b=c*r;
    n=sum(r);
    a1=a/n;
    b1=b/n^2;
    kappa=(a1-b1)/(1-b1);

end