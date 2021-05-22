function X = gen_x_matrix(dir_v,dim,tr_prop,seed,train_loc,test_loc,class)
%This function is used to generate the X matrix from the given directory.

%Dir_v is the directory to which to load all the images from
%Dim is a 2 element vector with the target dimension to reduce to.
%tr_prop is the proportion to train on
%Seed is the seed for RNG

dir_struct = dir(dir_v); %Getting all files in directory

s = RandStream('mt19937ar','Seed',seed);
num_items = length(dir_struct)-2;
num_train = round(tr_prop*num_items);
num_train = max(num_train,1); %Ensuring at least 1 element
sample = randsample(s,num_items,num_train,false);

X = [];
for a = 3:length(dir_struct) %Ignoring . and ..
    c_name = dir_struct(a).name;
    c_loc = strcat(dir_v,"/",c_name); %Full path from wd
    c_img_in = imread(c_loc);
    c_img = double(c_img_in);
    if ismember((a-2),sample)
        %Is train image
        ds_img = imresize(c_img,dim);
        flat_img = reshape(ds_img,[],1);
        flat_img = flat_img - min(flat_img);
        norm_img = flat_img ./ max(flat_img);
        X = [X,norm_img];
        w_name = strcat("c",class,"_",c_name);
        w_loc = strcat(train_loc,"/",w_name);
        imwrite(c_img_in,w_loc);
    else
        %Is test image
        w_name = strcat("c",class,"_",c_name);
        w_loc = strcat(test_loc,"/",w_name);
        imwrite(c_img_in,w_loc);
    end   
end
end

