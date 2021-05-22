function allH = gen_all_mats(dir_src,dir_train,dir_test,dim,tr_prop,seed)
%GEN_ALL_MATS Summary of this function goes here
%   Detailed explanation goes here
allH = [];
dir_struct = dir(dir_src);

for a = 3:length(dir_struct) %Ignoring . and ..
    c_name = dir_struct(a).name;
    class = num2str(a-2);
    c_loc = strcat(dir_src,"/",c_name); %Full path from wd
    c_X = gen_x_matrix(c_loc,dim,tr_prop,seed,dir_train,dir_test,class);
    c_H = gen_h_matrix(c_X);
    allH = cat(3,allH,c_H);
end
end

