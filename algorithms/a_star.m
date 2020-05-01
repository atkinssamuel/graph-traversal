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
    1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
    1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;
    ];
sz = size(maze);
inf = 100000;
distance_maze = ones(sz(1), sz(2)) * inf;
starting_position = [2, 2];
goal = [22, 22];
distance_maze(starting_position(1), starting_position(2)) = 0;
maze(goal(1), goal(2)) = 3;
linear_obstacle_indices = find(maze==1);

[obstacle_row_ind, obstacle_col_ind] = ind2sub(sz, linear_obstacle_indices);
linear_goal_index = find(maze==3);
[goal_row_ind, goal_col_ind] = ind2sub(sz, linear_goal_index);


max_iterations = 10000;
finished = 0;

frontier = zeros(10000, 2);
front = 1;
rear = 1;
frontier(front, :) = starting_position;
frontier_length = rear - front + 1;

%% Plotting grid:
for j = 1:sz(1)
   xline(j-0.5)
   yline(j-0.5)
end

%% Plotting obstacles
num_obstacles = length(obstacle_row_ind);
box_width = 1;
for j = 1:num_obstacles
    rectangle('Position', [...
        obstacle_row_ind(j)-box_width/2 ...
        obstacle_col_ind(j)-box_width/2 ...
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

    for j=1:length(exploration_array)
       if (maze(exploration_array(j, 1), exploration_array(j, 2)) == 0)
          maze(exploration_array(j, 1), exploration_array(j, 2)) = 2;
          if (distance_maze(exploration_array(j, 1), exploration_array(j, 2)) > (distance_maze(current_node(1), current_node(2)) + 1))
              distance_maze(exploration_array(j, 1), exploration_array(j, 2))...
                  = distance_maze(current_node(1), current_node(2)) + 1;
          end
          rear = rear + 1;
          frontier(rear, :) = exploration_array(j, :);
          rectangle('Position',[...
            frontier(rear, 1)-box_width/2 ...
            frontier(rear, 2)-box_width/2 ...
            box_width box_width], 'FaceColor', [0 1 1])
       else
           if (maze(exploration_array(j, 1), exploration_array(j, 2)) == 3)
               distance_maze(exploration_array(j, 1), exploration_array(j, 2))...
                  = distance_maze(current_node(1), current_node(2)) + 1;
               fprintf("\nGoal state reached")
               finished = 1;
               break;
           end
       end
    end
    
    if finished
        break;
    end
    
    figure(1);
end
path_nodes = zeros(1000, 2);
path_nodes(1, :) = goal;
path_node_index = 2;
retrace_node = goal;

%% Retrace loop:
for i = 1:max_iterations
    rectangle('Position', [...
        retrace_node(1)-box_width/2 ...
        retrace_node(2)-box_width/2 ...
        box_width box_width], 'FaceColor', [0 1 0])
    figure(1);
    if distance_maze(retrace_node(1), retrace_node(2)) == 0
       fprintf("\nFound path\n");
       return;
    end
    retrace_array = [
        retrace_node + [1, 0];  
        retrace_node + [0, 1];   
        retrace_node + [-1, 0]; 
        retrace_node + [0, -1]];
    for j=1:length(retrace_array)
        if distance_maze(retrace_array(j, 1), retrace_array(j, 2)) < distance_maze(retrace_node(1), retrace_node(2))
           path_nodes(path_node_index, :) = retrace_array(j, :);
           retrace_node = retrace_array(j, :);
           break;
        end
    end
end