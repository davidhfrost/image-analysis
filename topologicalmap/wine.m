load WineData
% dimensions of data
n = size(X, 1);
p = size(X, 2);
tau = 10^(-10);
Xbar = 1/p * sum(X, 2);
X_c = X - Xbar;
% there are three clusters in the data
% the three matrices, one for each cluster
X1 = X(:, find(I == 1));
X2 = X(:, find(I == 2));
X3 = X(:, find(I == 3));
% the centroids of each cluster
C1 = 1/size(X1, 2) * sum(X1, 2);
C2 = 1/size(X2, 2) * sum(X2, 2);
C3 = 1/size(X3, 3) * sum(X3, 2);
% global centroid
C = 1/size(X, 2) * sum(X, 2);
% center the clusters
X1 = X1 - C1*ones(1, size(X1, 2));
X2 = X2 - C2*ones(1, size(X2, 2));
X3 = X3 - C3*ones(1, size(X3, 2));
% within-cluster centered matrix
X_w = [X1 X2 X3];
% within-cluster scatter matrix
S_w = X_w * X_w';
% initialize matrices
X1_bar = [];
X2_bar = [];
X3_bar = [];
% 3 for loops
for a = 1:size(X1, 2)
    X1_bar = [X1_bar, C1];
end
for a = 1:size(X2, 2)
    X2_bar = [X2_bar, C2];
end
for a = 1:size(X3, 2)
    X3_bar = [X3_bar, C3];
end

X_bar = [X1_bar X2_bar X3_bar];
X_bar_centered = X_bar - C*ones(1,p);

S_b = X_bar_centered * X_bar_centered';
% largest eigenvalue of within-cluster scatter matrix
largest_eigenvalue = eigs(S_w, 1);
epsilon = tau * largest_eigenvalue;
% cholesky
K = chol(S_w + (epsilon * eye(n)));
K_inverse = inv(K);
K_inverse_transpose = K_inverse';
A = K_inverse_transpose * S_b * K_inverse;
two_eigs_of_A = eigs(A, 2);
[W, two_eigenvalues] = eigs(A, 2);
Q = K \ W;
for a = 1:2
    Q(:,a) = Q(:,a)/norm(Q(:,a));
end
Z_1 = Q' * X1;
Z_2 = Q' * X2;
Z_3 = Q' * X3;
% Plot the two 
Z = Q' * X;
colormap("lines");
figure(1);
scatter(Z(1,:),Z(2,:),10,I,'filled');


