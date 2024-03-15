% MATLAB code to shuffle rows of a matrix randomly
% % Create a sample matrix
% Mat = [10, 20, 2; 42, 51, 67; 57, 85, 19; 1, 15, 2];
% 
% % Determine the number of rows in the matrix
% n = size(Mat, 1);	% dim = 1 to specify rows
% 
% % Generate a random permutation of indices of rows of the matrix
% R = randperm(n);
% 
% % Shuffle the rows of the matrix using random permutation
% Shuffled_Mat = Mat(R, :);
% 
% % Display the input and shuffled matrices
% disp('The input matrix is:');
% disp(Mat);
% disp('The shuffled matrix is:');
% disp(Shuffled_Mat);

z = 0.11
z_adj = floor(z./0.05).*0.05  % rounds to nearest 0.05
layer = (z_adj/0.05) + 1