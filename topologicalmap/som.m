function [M, Q] = som(K, T_max, data)
n = size(data, 1);
p = size(data, 2);
alpha_zero = 0.9;
alpha_one = 0.01;
gamma_zero = K/3;
gamma_one = 0.01;
t = 1;
T_zero = 5000;
n = size(data, 1);
%SOM Self-organizing map
%
% rectangular lattice of size N x N
K = N*N;
% change to N later
Q = ones(2, K);
% initialize lattice
%{
for a = 1: n
    for b = 1:2
        Q(b, a) = 
    end
end
%}

% top row
for i = 1:100
    for j = 1:10
        Q(1, i + j - 1) = i;
    end
end

Q_top = [];
for i = 1:10
    Q_top = [Q_top, i*ones(1,10)];
end
Q_bottom = [];
for i = 1:10
    for j = 1:10
        Q_bottom = [Q_bottom, j];
    end
end

Q = [Q_top; Q_bottom];
V = zeros(160, 160);
%prototypes
% K prototypes and each one is 
%M = ones(n, k);
M = [];
% iteration

while t < T_max
    %find best matching unit from current prototypes
    minimum = Inf;
    j = 1;
    data_vector = data(:,randi(p));
    for a = 1:K
        vector_and_BMU_distance = norm(M(:,K) - data_vector);
        if (vector_and_BMU_distance < minimum)
            minimum = vector_and_BMU_distance;
            j = a;
        end
    end
    for ell = 1:K
        % calculating alpha(t) (learning rate)
        alpha_of_t = alpha_one;
        if alpha_zero*(1 - (t/T_zero)) > alpha_of_t
            alpha_of_t = alpha_zero*(1 - (t/T_zero));
        end
        % calculating gamma(t)
        gamma_of_t = gamma_one;
        if gamma_zero*(1 - (t/T_zero)) > gamma_of_t
            gamma_of_t =  gamma_zero*(1 - (t/T_zero));
        end
        d_ell_j = norm(Q(:, ell) - Q(:, j));
        neighborhood = exp(( (-1/2) * (1/(gamma_of_t) * (1/gamma_of_t) )) * d_ell_j * d_ell_j);
        M(:,ell) = M(:,ell) + alpha_of_t*neighborhood*(data_vector - M(:,ell));
        
        t = t + 1;
    end
end

for a = 1:K
    closest_data_point;
    closest_data_point_distance = Inf;
    for ell = 1:n
        if norm(M(:,a) - data(:,ell)) < closest_data_point_distance
            closest_data_point_distance = norm(M(:,a) - data(:,b));
            closest_data_point = ell;
        end
    end
    j = Q(1, a);
    k = Q(2, a);
    V((j - 1)*16 + 1: j * 16, (k - 1) * 16 + 1: k * 16) = reshape(data(:, ell), 16, 16)';

end
imagesc(V);
