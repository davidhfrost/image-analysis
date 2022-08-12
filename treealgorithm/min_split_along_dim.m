function [s_opt, min_error] = min_split_along_dim(coords, vals, min_error, dim)
% In this function, we're checking splits instead of splitting checks...
% Iterate over all possible splits along one dimension of the data

% Input: coords: the coordinates of the pixels along this dimension
% Input: vals: the RGB values of the pixels along this dimension
% Input: min_error: Usually set to Inf, this is the threshold that an
% optimal split must be less than
% Input: dim: which dimension we are testing splits on, 1 for x or 2 for y
% Output: s_opt: the optimal split index
% Output: min_error: the error from the optimal split

% Initial value of Inf for s_opt is just a dummy value
s_opt = Inf;
% Sort the coords and eliminate duplicates to find all possible split
% indices
unique_sorted_coords = unique(sort(coords));
% Iterate over all midpoints between two different coordinates along this
% dimension
for i = 1:(length(unique_sorted_coords) - 1)
    midpoint = [unique_sorted_coords(i) + unique_sorted_coords(i + 1)]/2;
    % Left (or lower) and right (or upper) partitioning
    indices_1 = [coords <= midpoint];
    indices_2 = [coords > midpoint];
    % Partition the pixels
    vals_1 = vals(indices_1,:);
    vals_2 = vals(indices_2,:);
    % Left average
    c1 = sum(vals_1, 1)/size(vals_1, 1);
    % Right average
    c2 = sum(vals_2, 1)/size(vals_2, 1);
    % Subtract the average RGB value of each rectangle from the RGB values
    % of the pixels in that rectangle
    vals_1_normal = vals_1 - c1;
    vals_2_normal = vals_2 - c2;
    % Left and right error are both mean square errors of the RGB values
    % from the average in their respective rectangle
    left_error = sum(sqrt(sum(vals_1_normal.^2, 2)).^2);
    right_error = sum(sqrt(sum(vals_2_normal.^2, 2)).^2);
    % Total error is sum of left anf right error
    total_error = left_error + right_error;
    % If this split has a lower error than other previously seen splits,
    % then it is the most optimal so far.
    if (total_error < min_error) || (min_error == Inf)
        j_opt = dim;
        s_opt = midpoint;
        min_error = total_error;
    end
end
end

