photo = imread('buntingsmall.jpg');
num_pixels = 2000;
% X dimensions
m = size(photo, 2);
% Y dimensions
n = size(photo, 1);
vals = zeros(num_pixels, 3);
rand_x = randi(m, num_pixels*1.1, 1);
rand_y = randi(n, num_pixels*1.1, 1);
concat_xy = [rand_x rand_y];
unique_pairs = unique(concat_xy, 'rows');
rand_x = unique_pairs(1:num_pixels, 1);
rand_y = unique_pairs(1:num_pixels, 2);
counter = 1;
while counter <= num_pixels
    vals(counter,:) = photo(rand_y(counter), rand_x(counter), :);
    counter = counter + 1;
end
vals = vals/255;
cols = rand_x;
rows = rand_y;
save('bunting4.mat', 'vals', 'cols', 'rows');