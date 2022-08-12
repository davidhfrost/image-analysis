function [M,Q] = my_som(K,T_max, data, init_func)
% function my_som uses self-organizing maps to reduce
% dimensionality in data while still preserving topology and order.
% Input: K = number of prototypes. Should be a perfect square
% since the lattice should be a square
% Input: T_max: Number of iterations
% Input: data: the data matrix
% Input: init_func: the initialization function
% Output: M: the prototypes. Size is p x K
% Output: Q: the 2D lattice. Size is 2 x K

% n = number of elements in each data vector
n = size(data, 1);
% p = number of data vectors
p = size(data, 2);
% Parameters for learning for SOM
alpha_zero = 0.9;
alpha_one = 0.01;
gamma_zero = K/3;
gamma_one = 0.01;
% initial counter
t = 0;
% length of learning phase
T_zero = 10000;
% Q is a 2 x K matrix. Theoretically it should be N x N where N = sqrt(K),
% but it's more convenient to represent the 2D lattice as a 1 x K vector
% but where we store i and j values for each position in the first and
% second rows.
Q = ones(2, K);
% row for i coordinates
Q_top = [];
for i = 1:sqrt(K)
    Q_top = [Q_top, i*ones(1,sqrt(K))];
end
% row for j coordinates
Q_bottom = [];
for i = 1:sqrt(K)
    for j = 1:sqrt(K)
        Q_bottom = [Q_bottom, j];
    end
end

% Create lattice by combining 
Q = [Q_top; Q_bottom];

% Initialize the prototypes
% We use init_func to make this program
% more modular so we can use whatever initialization
% is given as an input.
M = init_func(n, K, data);
% iteration
while t < T_max
    %find best matching unit from current prototypes
    % initialize distance from BMU to vector as Inf and index as 1
    vector_to_BMU_distance = Inf;
    j = 1;
    % pick a random data vector
    data_vector = data(:,randi(p));
    % check every prototype's distance to vector to find BMU
    for a = 1:K
        vector_and_prototype_distance = norm(M(:,a) - data_vector);
        % we have found a better matching unit
        if vector_and_prototype_distance < vector_to_BMU_distance
            vector_to_BMU_distance = vector_and_prototype_distance;
            % index of BMU
            j = a;
        end
    end
    % update every prototype now that we found a new BMU for that data
    % vector
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
        % distance between particular prototype and BMU
        d_ell_j = norm(Q(:, ell) - Q(:, j));
        neighborhood = exp(( (-1/2) * (1/(gamma_of_t) * (1/gamma_of_t) )) * d_ell_j * d_ell_j);
        % updating prototype vectors
        M(:,ell) = M(:,ell) + alpha_of_t*neighborhood*(data_vector - M(:,ell));
    end
    % update counter
    t = t + 1;
end

