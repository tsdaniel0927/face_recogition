function all_H = read_h_mat()
%Utility function for loading the H matrices
%Writing 3D matrices seems to not work super well, so we've saved it as a
%2D matrix and reshape.

h2 = readmatrix("allHatMatrices.txt");
h_size = readmatrix("allHatSize.txt");
all_H = reshape(h2,h_size);
end

