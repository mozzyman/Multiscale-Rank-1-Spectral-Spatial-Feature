function [SM, Tr_Class, Testing_data, T_Class] = Train_Test(Fimg, GT)

% Number of datasets

disp('Splitting Training and Test Set...')
for z=1:1
    
    Testing_data = reshape(Fimg, [size(Fimg,1) * size(Fimg,2), size(Fimg,3)])';
    Testing_data = Testing_data ./ vecnorm(Testing_data);
    All_Class = GT;
    T_Class = reshape(All_Class, [1, size(All_Class,1) * size(All_Class,2)]);
    Class = max(max(T_Class));
    
    index = cell([Class,1]);
    
    SM = [];
    Tr_Class = [];
    
    Class_Size = [];
    for i=1:Class
        Class_Size = [Class_Size size(find(double(All_Class)==i),1)];
    end
    
    Tr_S = [5 143 83 24 48 73 3 48 2 97 246 59 21 127 40 9];% 10% Indian_Pines
%     % Tr_S = [126,126,70,125,125,33,127,125,126,123,124,124,47,43,66]; % 10% houston
%     % Tr_S = [200 200 200 200 200 200 200 200 200]; % Pavia
%     Tr_S = ceil(Class_Size * 0.1);
    
    for i=1:1:Class
        
            index{i}=find(T_Class==i);
            p = randperm(size(index{i},2),Tr_S(i));
            SM = [SM Testing_data(:,index{i}(p))]; 
            T_Class(index{i}(p))= 0;
            Tr_Class = [Tr_Class ones(1,Tr_S(i)) * double(i)];
        
    end
    
    SM = SM ./ vecnorm(SM,2);
    T_Class = reshape(T_Class, [size(All_Class,1) , size(All_Class,2)]);
    
end