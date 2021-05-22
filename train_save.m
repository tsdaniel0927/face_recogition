%Script to generating Hat matrices from training data and save them to
%files.

%Expects the source images to be in a folder, with all the photos for a
%class in a folder together.

%Will make directories for train and test instances. On re-run will delete
%everything in these folders.

%Training instances are picked randomly, seed value needs to supplied
%however.

%Dim can either be the a single double signifying the scaling factor for
%the images, or a pair of integers indicating the target resolution for
%each image.

%Location for utility functions
addpath("train_src");

%Required parameters
dir_src = "source_imgs";
dir_train = "train";
dir_test =  "test";

%Changeable parameters
tr_prop = 0.5;
seed = 226852;
dim = 0.1;

%Clear out test and train folders
rmdir(dir_train,'s');
rmdir(dir_test,'s');
mkdir(dir_train);
mkdir(dir_test);

%Generating all the matrices required for prediction
all_H = gen_all_mats(dir_src,dir_train,dir_test,dim,tr_prop,seed);

%Flattening so the matrices can be saved and load at a later stage
%Saving as a 3D matrix seems to not work well
size_H = size(all_H);
h2 = reshape(all_H,[],size(all_H,2),1);

%Saving the matrices and shape so can be reconstructed
writematrix(h2,"allHatMatrices");
writematrix(size_H,"allHatSize");