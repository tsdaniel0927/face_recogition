function class = predict(all_H,new_img,dim)
%PREDICT Summary of this function goes here
%   Detailed explanation goes here

img_ds = imresize(new_img,dim);
im_flat = double(reshape(img_ds,[],1));
im_flat = im_flat - min(im_flat);
norm_img = im_flat ./ max(im_flat);

euc_dis = Inf;
class = 0;
for c_class = 1:size(all_H,3)
    c_H = all_H(:,:,c_class);
    yhat = c_H * norm_img;
    c_dis = norm(norm_img - yhat);
    if c_dis < euc_dis
        euc_dis = c_dis;
        class = c_class;
    end
end
end

