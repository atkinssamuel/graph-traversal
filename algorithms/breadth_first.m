clear all;
hold on;

%% Maze Key
% 1 = obstacle
% 2 = on frontier
% -1 = dead node
% 3 = goal node
maze = [
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;
    1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 1 0 1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 1 0 1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 0 0 1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 0 0 1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 0 0 1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 0 0 1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 0 0 1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 0 0 1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 1;
    1 1 1 1 1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 1;
    1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1;
    1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 1;
    1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;
    ];
starting_position = [2, 2];
linear_obstacle_indices = find(maze==1);
sz = size(maze);
[obstacle_row_ind, obstacle_col_ind] = ind2sub(sz, linear_obstacle_indices);
linear_goal_index = find(maze==3);
[goal_row_ind, goal_col_ind] = ind2sub(sz, linear_goal_index);


max_iterations = 1000;

frontier = zeros(10000, 2);
front = 1;
rear = 1;
frontier(front, :) = starting_position;
frontier_length = rear - front + 1;

%% Plotting grid:
for i = 1:sz(1)
   xline(i-0.5)
   yline(i-0.5)
end

%% Plotting obstacles
num_obstacles = length(obstacle_row_ind);
box_width = 1;
for i = 1:num_obstacles
    rectangle('Position', [...
        obstacle_row_ind(i)-box_width/2 ...
        obstacle_col_ind(i)-box_width/2 ...
        box_width box_width], 'EdgeColor', 'k', 'FaceColor', [0 0 0])
end

%% Plotting goal
rectangle('Position', [...
        goal_row_ind-box_width/2 ...
        goal_col_ind-box_width/2 ...
        box_width box_width], 'FaceColor', [0 1 0])
    
%% Plotting starting position:
rectangle('Position', [starting_position(1)-box_width/2 starting_position(2)-box_width/2 ...
    box_width box_width], 'FaceColor', [1 1 0])

axis([1, sz(1), 1, sz(2)]);
pbaspect([1 1 1]);

camroll(270);
figure(1);
pause(5);
%% Main Loop:
for t = 1:max_iterations
    %% Checking to see if frontier empty or if at goal state
    frontier_length = rear - front + 1;
    if (frontier_length == 0)
       pause(5);
       return
    end
   
    
    current_node = frontier(front, :);
    front = front + 1;
    maze(current_node(1), current_node(2)) = -1;
    
    %% Plotting dead nodes
    rectangle('Position',[...
            current_node(1)-box_width/2 ...
            current_node(2)-box_width/2 ...
            box_width box_width], 'FaceColor', [1 0 1])
        
        
    % Frontier priority:
    % North, East, South, West
    exploration_array = [
        current_node + [1, 0];   % North
        current_node + [0, 1];   % East
        current_node + [-1, 0];  % South
        current_node + [0, -1]]; % West

    for i=1:length(exploration_array)
       if (maze(exploration_array(i, 1), exploration_array(i, 2)) == 0)
          maze(exploration_array(i, 1), exploration_array(i, 2)) = 2;
          rear = rear + 1;
          frontier(rear, :) = exploration_array(i, :);
          rectangle('Position',[...
            frontier(rear, 1)-box_width/2 ...
            frontier(rear, 2)-box_width/2 ...
            box_width box_width], 'FaceColor', [0 1 1])
       else
           if (maze(exploration_array(i, 1), exploration_array(i, 2)) == 3)
               fprintf("Goal state reached")
               return;
           end
       end
    end
    
    figure(1);
    

end