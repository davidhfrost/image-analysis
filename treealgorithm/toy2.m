rows = [25; 10; 80];
cols = [25; 80; 60];
vals = [0.1 0.5 0.2; 0.4 0.1 0.3; 0.9 0.2 0.0];

% load MysteryImage
% Decide what the max number of splits is, maximal tree 
% is probably too costly
% Initialize struct template
min_x = min(cols);
max_x = max(cols);
min_y = min(rows);
max_y = max(rows);
% Initialize the leaf of the tree
R(1).s = [];
R(1).j = [];
R(1).left = [];
R(1).right = [];
R(1).I = 1;
R(1).x = [min_x; max_x];
R(1).y = [min_y; max_y];
R(1).rows = rows;
R(1).cols = cols;
R(1).vals = vals;
R(1).val = mean(vals);
%{
R(1).I = (1:n_data);
R(1).x = [0;1];
R(1).y = [0;m/n];
R(1).val = 1/n_data;
%}

counter = 1;
leaf_index = 2;
pure_leaves = [];
impure_leaves = [1];
% While loop that creates the tree
% Alternate while condition: while length(pure_leaves) < 15000
while ~isempty(impure_leaves)% && isempty(pure_leaves)
    % Get the oldest leaf
    leaf = R(impure_leaves(:,1));
    % Delete the leaf from the FIFO queue
    %{
    if length(leaf.pixels) < 2
        pure_leaves = [pure_leaves leaf.I];
        continue;
    end
    %}
    current_index = leaf.I;
    %{
    min_x = min(leaf.cols);
    max_x = max(leaf.cols);
    min_y = min(leaf.rows);
    max_y = max(leaf.rows);
    %}
    min_x = leaf.x(1);
    max_x = leaf.x(2);
    min_y = leaf.y(1);
    max_y = leaf.y(2);
    [j_opt, s_opt] = OptimalSplitRegression_I(leaf.vals, leaf.cols, leaf.rows);
    % j_opt == 1 means x_axis is the split axis
    if j_opt == 1
        one = (leaf.cols <= s_opt);
        two = (leaf.cols > s_opt);
        c1_vals = leaf.vals(one,:);
        c2_vals = leaf.vals(two,:);
    % else, if j_opt == 2, y_axis is the split axis
    else
        one = (leaf.rows <= s_opt);
        two = (leaf.rows > s_opt);
        c1_vals = leaf.vals(one,:);
        c2_vals = leaf.vals(two,:);
    end
    % Left child
    R(leaf_index).s = [];
    R(leaf_index).j = [];
    R(leaf_index).left = [];
    R(leaf_index).right = [];
    R(leaf_index).x = [min_x; max_x];
    R(leaf_index).y = [min_y; max_y];
    R(leaf_index).I = leaf_index;
    R(leaf_index).rows = leaf.rows(one);
    R(leaf_index).cols = leaf.cols(one);
    R(leaf_index).vals = leaf.vals(one,:);
    R(leaf_index).val = mean(R(leaf_index).vals);
    if length(R(leaf_index).rows) == 1
        R(leaf_index).val = R(leaf_index).vals;
    end
    if j_opt == 1
        R(leaf_index).x = [min_x; s_opt];
    else
        R(leaf_index).y = [min_y; s_opt];
    end
    if length(R(leaf_index).rows) == 1
        pure_leaves = [pure_leaves leaf_index];
    else
        impure_leaves = [impure_leaves leaf_index];
    end
    R(current_index).left = leaf_index;
    leaf_index = leaf_index + 1;
    R(leaf_index).s = [];
    R(leaf_index).j = [];
    R(leaf_index).left = [];
    R(leaf_index).right = [];
    R(leaf_index).x = [min_x; max_x];
    R(leaf_index).y = [min_y; max_y];
    R(leaf_index).I = leaf_index;
    R(leaf_index).rows = leaf.rows(two);
    R(leaf_index).cols = leaf.cols(two);
    R(leaf_index).vals = leaf.vals(two,:);
    R(leaf_index).val = mean(R(leaf_index).vals);
    if length(R(leaf_index).rows) == 1
        R(leaf_index).val = R(leaf_index).vals;
    end
    if j_opt == 1
        R(leaf_index).x = [s_opt; max_x];
    else
        R(leaf_index).y = [s_opt; max_y];
    end
    if length(R(leaf_index).rows) == 1
        pure_leaves = [pure_leaves leaf_index];
    else
        impure_leaves = [impure_leaves leaf_index];
    end
    R(current_index).right = leaf_index;
    leaf_index = leaf_index + 1;
    R(current_index).s = s_opt;
    R(current_index).j = j_opt;
    % Create left and right children
    impure_leaves(:,1)= [];
end

% CHANGE THIS LATER (YOU KNOW WHY)