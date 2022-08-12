load HandwrittenDigits.mat X I
T_max = 100000;
K = 100;
I1 = find(I == 2);
I2 = find(I == 7);
I3 = find(I == 9);
data = X(:, [I1 I2 I3]);
M = my_som(K, T_max, data);
for a = 1:K
    closest_data_point = [];
    closest_data_point_distance = Inf;
    for ell = 1:n
        if norm(M(:,a) - data(:,ell)) < closest_data_point_distance
            closest_data_point_distance = norm(M(:,a) - data(:,ell));
            closest_data_point = ell;
        end
    end
    j = Q(1, a);
    k = Q(2, a);
    V((j - 1)*16 + 1: j * 16, (k - 1) * 16 + 1: k * 16) = reshape(data(:, closest_data_point), 16, 16)';

end
colormap("gray");
imagesc(V);
