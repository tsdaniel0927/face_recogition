%Function to perform training - Essentially the same as train_save.m
%however this is to be used in-line if necessary. Requires dim as input for
%scaling and that the necessary folder setup done.

function all_H = train_func(dim,seed,tr_prop)
addpath("train_src");

%Required parameters
dir_src = "source_imgs";
dir_train = "train";
dir_test =  "test";

%Clear out test and train folders
rmdir(dir_train,'s');
rmdir(dir_test,'s');
mkdir(dir_train);
mkdir(dir_test);

%Generating all the matrices required for prediction
all_H = gen_all_mats(dir_src,dir_train,dir_test,dim,tr_prop,seed);
end

