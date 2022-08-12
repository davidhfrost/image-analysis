load MysteryImage
% Decide what the max number of splits is, maximal tree 
% is probably too costly
max_splits = 15000;
n_data = 15000;
leaves = [1];
pixels = [];
% Initialize struct template
pixel.x = [];
pixel.y = [];
pixel.vals = [];
for i = 1:15000
    pixel_i = struct(pixel);
    pixel_i.x = cols(i,:);
    pixel_i.y = rows(i,:);
    pixel_i.vals = vals(i,:);
    % Need a deep copy to prevent overriding on next iteration
    pixels = [pixels struct(pixel_i)];
    %pixels(:,i) = struct(pixel_i);
end
min_x = min(cols);
max_x = max(cols);
min_y = min(rows);
max_y = max(rows);
% Initialize the leaf of the tree
R(1).s = [];
R(1).j = [];
R(1).left = [];
R(1).right = [];
R(1).x = [min_x; max_x];
R(1).y = [min_y; max_y];
R(1).pixels = pixels;
R(1).I = 1;
%{
R(1).I = (1:n_data);
R(1).x = [0;1];
R(1).y = [0;m/n];
R(1).val = 1/n_data;
%}

counter = 1;
leaf_index = 2;
pure_leaves = [];
% While loop that creates the tree
while length(leaves) < 15000
    % Get the oldest leaf
    leaf = R(leaves(:,1));
    % Delete the leaf from the FIFO queue
    if length(leaf.pixels) < 2
        pure_leaves = [pure_leaves leaf.I];
        continue;
    end
    current_index = leaf.I;
    min_x = min([leaf.pixels.x]);
    max_x = max([leaf.pixels.x]);
    min_y = min([leaf.pixels.y]);
    max_y = max([leaf.pixels.y]);
    [j_opt, s_opt, min_error] = OptimalSplitRegression(leaf.pixels);
    % j_opt == 1 means x_axis is the split axis
    if j_opt == 1
        c1_pixels = pixels([pixels.x] <= s_opt);
        c2_pixels = pixels([pixels.x] > s_opt);
    % else, if j_opt == 2, y_axis is the split axis
    else
        c1_pixels = pixels([pixels.y] <= s_opt);
        c2_pixels = pixels([pixels.y] > s_opt);
    end
    R(leaf_index).s = [];
    R(leaf_index).j = [];
    R(leaf_index).left = [];
    R(leaf_index).right = [];
    R(leaf_index).x = [min_x; max_x];
    R(leaf_index).y = [min_y; max_y];
    R(leaf_index).pixels = c1_pixels;
    R(leaf_index).I = leaf_index;
    if j_opt == 1
        R(leaf_index).x = [min_x; s_opt];
    else
        R(leaf_index).y = [min_y; s_opt];
    end
    leaves = [leaves leaf_index];
    R(current_index).left = leaf_index;
    leaf_index = leaf_index + 1;
    R(leaf_index).s = [];
    R(leaf_index).j = [];
    R(leaf_index).left = [];
    R(leaf_index).right = [];
    R(leaf_index).x = [min_x; max_x];
    R(leaf_index).y = [min_y; max_y];
    R(leaf_index).pixels = c2_pixels;
    R(leaf_index).I = leaf_index;
    if j_opt == 1
        R(leaf_index).x = [s_opt; max_x];
    else
        R(leaf_index).y = [s_opt; max_y];
    end
    leaves = [leaves leaf_index];
    R(current_index).right = leaf_index;
    leaf_index = leaf_index + 1;
    R(current_index).s = s_opt;
    R(current_index).j = j_opt;
    R(current_index).pixels = [];
    % Create left and right children
    leaves = [leaves leaf_index];
    leaves(:,1)= [];
    counter = counter + 1;
end

% Binary search tree traversal to find leaf node

%}