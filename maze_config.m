clear all;
maze = [
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;
    1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -1 0 0 1;
    1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;
    ];
x = [2, 2];
linear_obstacle_indices = find(maze==1);
sz = size(maze);
[obstacle_row_ind, obstacle_col_ind] = ind2sub(sz, linear_obstacle_indices);
linear_goal_index = find(maze==-1);
[goal_row_ind, goal_col_ind] = ind2sub(sz, linear_goal_index);


max_iterations = 1000;

frontier = zeros(100, 2);
frontier(1, :) = x;

for t = 1:max_iterations
    
    
    
    
    %% Plotting obstacles
    hold on;
    
    obstacle_length = length(obstacle_row_ind);
    box_width = 1;
    for i = 1:obstacle_length
        rectangle('Position',[...
            obstacle_row_ind(i)-box_width/2 ...
            obstacle_col_ind(i)-box_width/2 ...
            box_width box_width], 'EdgeColor', 'k', 'FaceColor', [0 0 0])
    end
    
    %% Plotting goal
    rectangle('Position',[...
            goal_row_ind-box_width/2 ...
            goal_col_ind-box_width/2 ...
            box_width box_width], 'FaceColor', [0 1 0])
    
    %% Plotting grid:
    for i = 1:sz(1)
       xline(i-0.5)
       yline(i-0.5)
    end
    

    %% Plotting Curpos:
    rectangle('Position', [x(1)-box_width/2 x(2)-box_width/2 ...
        box_width box_width], 'FaceColor', [0 0 1])

    axis([1, sz(1), 1, sz(2)]);
    pbaspect([1 1 1])
    camroll(270);
    figure(1)
    close(1);
end