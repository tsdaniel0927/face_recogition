function H = gen_h_matrix(X)
%Function to generate the "hat" matrix for computing the yhat values.

%The X matrix, output from gen_x_matrix

%Steps split up for testing purposes
x = double(X); %Matlab doesn't like integers
xt = transpose(x);
mid = double(xt)*x;
right = mid\xt; %Matlab prefers A\B to inv(A)*B
H = x*right;
end

