function [Fimg] = MRSSF(All_data, pix_pos, Multi_scale_PS_H,scale_index,scale_num)
disp('Generating Feature...')
[row, col] = find(pix_pos ~=0);
pix_pos = reshape(pix_pos, [1, size(pix_pos,1) * size(pix_pos,2)]);

N_data = padarray(All_data,[Multi_scale_PS_H(end),Multi_scale_PS_H(end)],'symmetric','both');

Fimg = zeros([size(All_data,3) * size(Multi_scale_PS_H,2)+size(All_data,3), size(All_data,1) * size(All_data,2)]);


parfor i=1:size(pix_pos,2)
    % take xy coordinates of pixel
    X = row(i);
    Y = col(i);
    
    %extract the region within window
    X_new = X + Multi_scale_PS_H(end);
    Y_new = Y + Multi_scale_PS_H(end);
    X_range = [X_new - Multi_scale_PS_H(end) : X_new + Multi_scale_PS_H(end)];
    Y_range = [Y_new - Multi_scale_PS_H(end) : Y_new + Multi_scale_PS_H(end)];
    tt_dat_temp = N_data(X_range, Y_range,:);
    
    % convert to matrix
    [r,c,b] = size(tt_dat_temp);
    Data_temp = reshape(tt_dat_temp,[r*c, b])';
    cent_data = Data_temp(:,scale_index{1});
    temp_data =[];
    
    % extract SVD feature | scale_num is the number of windows used
    for si=1:scale_num
        
        d = Data_temp(:,scale_index{si});
        F1 = find(sum(d,1)==0);
        d(:,F1) = [];
         
        [U, S, V] = svd(d, 'econ');  % Efficient economy-sized SVD
        U1 = U(:,1);
        S1 = S(1,1);
        V1 = V(:,1);
        Approx_data = U1 * S1 * V1';
        temp_data = [temp_data; Approx_data(:, ceil(size(d,2)/2))];
        
    end
    
    temp_data = [temp_data; cent_data(:,ceil(size(cent_data,2)/2))];
    Fimg(:,i) = temp_data;
    
end

Fimg = reshape(Fimg', [size(All_data,1) , size(All_data,2), size(All_data,3) * size(Multi_scale_PS_H,2)+size(All_data,3)]);