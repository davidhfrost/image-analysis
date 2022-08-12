function [j_opt,s_opt, min_error] = OptimalSplitRegression(pixels)
%OPTIMALSPLITREGRESSION Summary of this function goes here
%   Detailed explanation goes here
%q = size(x_data, 1);
delta_g = -1;
% Check x-axis
[B, I] = sort([pixels.x]);
pixels_sorted_x = pixels(I);
[B, I] = sort([pixels.y]);
pixels_sorted_y = pixels(I);
x_values = unique([pixels.x]);
y_values = unique([pixels.y]);
min_error = 0;
for i = 1:(length(x_values) - 1)
    left_x = x_values(i);
    right_x = x_values(i + 1);
    middle_x = (left_x + right_x)/2;
    %{
    pixels_left = find([pixels.x] <= middle_x);
    pixels_right = find([pixels.x] > middle_x);
    %}
    pixels_left = pixels([pixels.x] <= middle_x);
    pixels_right = pixels([pixels.x] > middle_x);
    % Left average
    c1 = [0 0 0];
    for j = 1:length(pixels_left)
        c1 = c1 + pixels_left(j).vals;
    end
    c1 = c1/length(pixels_left);
    % Right average
    c2 = [0 0 0];
    for j = 1:length(pixels_right)
        c2 = c2 + pixels_right(j).vals;
    end
    c2 = c2/length(pixels_right);
    % Vectorial mean square error
    left_error = 0;
    right_error = 0;
    for j = 1:length(pixels_left)
        left_error = left_error + norm(c1 - pixels_left(j).vals, 2);
    end
    for j = 1:length(pixels_right)
        right_error = right_error + norm(c2 - pixels_right(j).vals, 2);
    end
    total_error = left_error + right_error;
    if (total_error < min_error) || min_error == 0
        j_opt = 1;
        s_opt = middle_x;
        min_error = total_error;
        j_opt
        s_opt
    end
end
% Check y-axis


for i = 1:(length(y_values) - 1)
    left_y = y_values(i);
    right_y = y_values(i + 1);
    middle_y = (left_y + right_y)/2;
    pixels_left = pixels([pixels.y] <= middle_y);
    pixels_right = pixels([pixels.y] > middle_y);
    % Left average
    c1 = [0 0 0];
    for j = 1:length(pixels_left)
        c1 = c1 + pixels_left(j).vals;
    end
    c1 = c1/length(pixels_left);
    % Right average
    c2 = [0 0 0];
    for j = 1:length(pixels_right)
        c2 = c2 + pixels_right(j).vals;
    end
    c2 = c2/length(pixels_right);
    % Vectorial mean square error
    left_error = 0;
    right_error = 0;
    for j = 1:length(pixels_left)
        left_error = left_error + norm(c1 - pixels_left(j).vals, 2);
    end
    for j = 1:length(pixels_right)
        right_error = right_error + norm(c2 - pixels_right(j).vals, 2);
    end
    total_error = left_error + right_error;
    if (total_error < min_error) || min_error == 0
        j_opt = 2;
        s_opt = middle_y;
        min_error = total_error;
        j_opt
        s_opt
    end
end
end


%{
for a = 1:2
    sigmas = zeros[]
    for b = 1:(q - 1)
        % Calculate vectorial mean square error
        find (x_data)
        c1 = ;
        c2 = ;
    end
end
outputArg1 = inputArg1;
outputArg2 = inputArg2;
end
%}
