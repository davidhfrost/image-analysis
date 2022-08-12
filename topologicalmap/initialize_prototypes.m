function M = initialize_prototypes(n, K, data)
% function that is used to initialize prototypes for SOM algorithm
% Input: n = dimensionality of data
% Input: K = number of prototypes
% Input: data = data set matrix
% Output: M = initialized prototypes
M = ones(n, K);
% computes the mean of the data vectors in the matrix and adds some uniform
% randomness to generate each data vector. The odds of two vectors being
% identical is astronomically low
for a = 1:100
    meanvalue = (ones(256, 256) - rand(256,256) + rand(256,256)) * 1/size(data, 2) * sum(data, 2);
    M(:, a) = meanvalue;
end
end

