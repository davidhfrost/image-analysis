load HandwrittenDigits.mat X I;
% number of iterations for SOM
T_max = 100000;
% number of prototypes. Should be perfect square since we're using
% a 2D lattice.
K = 100;
% finding the digits we want
I1 = find(I == 2);
I2 = find(I == 4);
I3 = find(I == 7);
% filtering the data to only include those digits
data = X(:, [I1 I2 I3]);
% dimensions of data. useful to prevent usage of magic numbers later
n = size(data, 1);
p = size(data, 2);
% run SOM
[M, Q] = my_som(K, T_max, data, @initialize_prototypes);
% for each prototype we run this loop
for a = 1:K
    % closest data vector to prototype
    cdv = [];
    % distance from cdv to prototype
    cdv_distance = Inf;
    % find the closest data vector to this prototype
    for ell = 1:p
        if norm(M(:,a) - data(:,ell)) < cdv_distance
            cdv_distance = norm(M(:,a) - data(:,ell));
            cdv = ell;
        end
    end
    % find coordinates on lattice of prototype
    j = Q(1, a);
    k = Q(2, a);
    % plot the closest data vector onto the prototype's place in the
    % lattice
    V((j - 1)*16 + 1: j * 16, (k - 1) * 16 + 1: k * 16) = reshape(data(:, cdv), 16, 16)';

end
% show the 100 prototypes
%colormap();
imagesc(V);
axis("off");
