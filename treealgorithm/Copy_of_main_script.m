% In this script, we use tree regression to recreate an image
% from just a small uniformly sampled subset of its pixels
load MysteryImage.mat
text_size = 20;
% Decide what the max number of splits is, maximal tree 
% is probably too costly
max_splits = Inf;
% The only mixed leaf at the beginning is the root node
mixed_leaves = [1];
% Root node covers entire image
min_x = min(cols);
max_x = max(cols);
min_y = min(rows);
max_y = max(rows);
% Initialize the leaf of the tree
% The split index
R(1).s = [];
% The split dimension
R(1).j = [];
% The left child node index
R(1).left = [];
% The right child node index
R(1).right = [];
% The node index
R(1).I = 1;
% The x dimensions that this node has for the image
R(1).x = [min_x; max_x];
% The y dimensions that this node has for the image
R(1).y = [min_y; max_y];
% The y-axis values for the pixels in this node
R(1).rows = rows;
% The x-axis values for the pixels in this node
R(1).cols = cols;
% The RGB values for the pixels in this node
R(1).vals = vals;
% The average RGB value for the pixels in this node
R(1).val = mean(vals);
% Counter for keeping track of figure numbers
counter = 1;
% Index for the next leaf that is created
leaf_index = 2;
% List of indices of pure leaves
pure_leaves = [];
% List of indices of impure (mixed) leaves
impure_leaves = [1];
m = max(cols);
n = max(rows);
num_splits = 0;
% While loop that creates the tree. Will stop running when we either have
% the maximal tree or we have done the maximum number of splits
while ~isempty(impure_leaves) && (num_splits < max_splits)
    % Calculate number of leaves to determine whether to show intermediate
    % progress
    num_leaves = length(impure_leaves) + length(pure_leaves);
    % Show image at various stages
    % c1, c2, etc. = condition 1, condition 2
    c1 = num_leaves == 1;
    c2 = num_leaves == 2;
    c3 = num_leaves == 10;
    c4 = num_leaves == 100;
    c5 = num_leaves == 500;
    c6 = num_leaves == 1000;
    c7 = num_leaves == 2500;
    c8 = num_leaves == 7500;
    % If we are at a certain number of leaves, show progress
    if c1 || c2 || c3 || c4 || c5 || c6 || c7 || c8
        figure(counter);
        title("")
        title(strcat("Image Using ", num2str(num_leaves), " Leaves"), 'FontSize', text_size);
        hold on;
        % y_offset needed to prevent image from being upside down
        y_offset = n + 1;
        
        for i = [pure_leaves impure_leaves]
            x_1 = R(i).x(1);
        x_2 = R(i).x(2);
        y_1 = y_offset - R(i).y(1);
        y_2 = y_offset - R(i).y(2);
        fill([x_1, x_2, x_2, x_1], [y_1, y_1, y_2, y_2], R(i).val, 'LineStyle', 'none');
        end
        % Fit image properly and remove axis information
        axis([min(cols) max(cols) min(rows) max(rows)]);
        axis off;
        counter = counter + 1;
    end 
    % Get the oldest leaf since this is FIFO queue with level-order
    % traversal
    leaf = R(impure_leaves(:,1));
    % Store the index of the oldest leaf
    current_index = leaf.I;
    % Find the dimensions and location of the rectangle for this leaf
    min_x = leaf.x(1);
    max_x = leaf.x(2);
    min_y = leaf.y(1);
    max_y = leaf.y(2);
    % Find the optimal splitting of the rectangle for this leaf
    [j_opt, s_opt] = optimal_split_regression(leaf.vals, leaf.cols, leaf.rows);
    % j_opt == 1 means x_axis is the split axis
    if j_opt == 1
        % Partition the pixels into those with x-values smaller than or
        % equal to j_opt split index, and those with x-values greater than
        one = (leaf.cols <= s_opt);
        two = (leaf.cols > s_opt);
        c1_vals = leaf.vals(one,:);
        c2_vals = leaf.vals(two,:);
    % else, if j_opt == 2, y_axis is the split axis
    else
        % Partition the pixels similar to with x-values
        one = (leaf.rows <= s_opt);
        two = (leaf.rows > s_opt);
        c1_vals = leaf.vals(one,:);
        c2_vals = leaf.vals(two,:);
    end
    % Left child
    % No split yet for this so initiailize s and j to be empty
    R(leaf_index).s = [];
    R(leaf_index).j = [];
    % No children yet so initialize left and right to be empty
    R(leaf_index).left = [];
    R(leaf_index).right = [];
    % Placeholder values for rectangle to be updated
    R(leaf_index).x = [min_x; max_x];
    R(leaf_index).y = [min_y; max_y];
    % Index for leaf
    R(leaf_index).I = leaf_index;
    % Pixels and values of pixels for this leaf
    R(leaf_index).rows = leaf.rows(one);
    R(leaf_index).cols = leaf.cols(one);
    R(leaf_index).vals = leaf.vals(one,:);
    % Average RGB value of pixels in this leaf
    R(leaf_index).val = sum(R(leaf_index).vals, 1)/size(R(leaf_index).vals, 1);
    % Set the x-dimensions or y-dimensions to be the left/lower
    % part depending on j_opt
    if j_opt == 1
        R(leaf_index).x = [min_x; s_opt];
    else
        R(leaf_index).y = [min_y; s_opt];
    end
    % Classify it as pure or impure leaf
    if length(R(leaf_index).rows) == 1
        pure_leaves = [pure_leaves leaf_index];
    else
        impure_leaves = [impure_leaves leaf_index];
    end
    % Set its index
    R(current_index).left = leaf_index;
    % Update index
    leaf_index = leaf_index + 1;
    % Right child
    % No split yet for this so initiailize s and j to be empty
    R(leaf_index).s = [];
    R(leaf_index).j = [];
    % No children yet so initialize left and right to be empty
    R(leaf_index).left = [];
    R(leaf_index).right = [];
    % Placeholder values for rectangle to be updated
    R(leaf_index).x = [min_x; max_x];
    R(leaf_index).y = [min_y; max_y];
    % Index for leaf
    R(leaf_index).I = leaf_index;
    % Pixels and values of pixels for this leaf
    R(leaf_index).rows = leaf.rows(two);
    R(leaf_index).cols = leaf.cols(two);
    R(leaf_index).vals = leaf.vals(two,:);
    % Average RGB value of pixels in this leaf
    R(leaf_index).val = sum(R(leaf_index).vals, 1)/size(R(leaf_index).vals, 1);
    % Set the x-dimensions or y-dimensions to be the right/upper
    % part depending on j_opt
    if j_opt == 1
        R(leaf_index).x = [s_opt; max_x];
    else
        R(leaf_index).y = [s_opt; max_y];
    end
    % Classify it as pure or impure leaf
    if length(R(leaf_index).rows) == 1
        pure_leaves = [pure_leaves leaf_index];
    else
        impure_leaves = [impure_leaves leaf_index];
    end
    % Set its index
    R(current_index).right = leaf_index;
    % Update index
    leaf_index = leaf_index + 1;
    % Set s and j for parent of the two children to be s_opt and j_opt
    R(current_index).s = s_opt;
    R(current_index).j = j_opt;
    % Remove parent from list of impure leaves since it is no longer a leaf
    impure_leaves(:,1)= [];
    % Increment number of splits
    num_splits = num_splits + 1;
end
m = max(cols);
n = max(rows);
% Plot maximal tree image
figure(counter);
title("Image Using Maximal Tree", 'FontSize', text_size);
hold on;
y_offset = n + 1;
for i = pure_leaves
    x_1 = R(i).x(1);
    x_2 = R(i).x(2);
    y_1 = y_offset - R(i).y(1);
    y_2 = y_offset - R(i).y(2);
    fill([x_1, x_2, x_2, x_1], [y_1, y_1, y_2, y_2], R(i).val, 'LineStyle', 'none');
end
axis([min(cols) max(cols) min(rows) max(rows)]);
axis off;