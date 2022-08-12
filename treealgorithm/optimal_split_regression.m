function [j_opt,s_opt] = optimal_split_regression(vals, cols, rows)
% This function takes a list of pixels with RGB values and their locations
% within a rectangle and then determines the best way to split this
% rectangle into two rectangles such that the vectorial mean square error
% of the difference between the average RGB value of each rectangle and
% each pixel within that rectangle is minimized


% Input: vals: list of RGB values for pixels in rectangle
% Input: cols: x-axis locations for pixels in rectangle
% Input: rows: y-axis locations for pixels in rectangle
% Output: j_opt: optimal split dimension. An image only has two dimensions,
% so this is either 1 (x-axis) or 2 (y-axis).
% Output: s_opt: optimal split index. This is the exact point along the
% optimal split dimension where we split the rectangle, it will always be a
% midpoint between two pixels along the optimal split dimension.


% Find all possible x and y values and sort them
% for iteration purposes when trying to find optimal splits
x_values = unique(sort(cols));
y_values = unique(sort(rows));
% Dummy value of inf used to make the min_error
% always update correctly on the first split
min_error = Inf;
% Iterate over all x-values midway between two pixels
[s_opt1, min_error1] = min_split_along_dim(cols, vals, min_error, 1);
[s_opt2, min_error2] = min_split_along_dim(rows, vals, min_error, 2);
% Check to see whether the optimal split is along x or y axis
% Update j_opt and s_opt depending on what the optimal split is
if min_error1 <= min_error2
    j_opt = 1;
    s_opt = s_opt1;
    min_error = min_error1;
else
    j_opt = 2;
    s_opt = s_opt2;
    min_error = min_error2;
end
end
