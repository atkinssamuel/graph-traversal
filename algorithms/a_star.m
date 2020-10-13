clear all;
hold on;
addpath('multi-dimensional_min_heap')
%% Maze Key
% 0 = unexplored
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

frontier = zeros(10000, 3);
cost = sum(abs(starting_position - goal));
N = 1;
column = 3;
frontier(N, :) = [starting_position, cost];

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
figure(1);
%% Main Loop:
for t = 1:max_iterations
    %% Checking to see if frontier empty
    if (N == 0)
       pause(5);
       return
    end
   
    [frontier, current_node] = min_heap_extract(frontier, column, N);
    N = N - 1;
    current_node = current_node(1:2);
    
    
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
    
    min_distance = inf;
    if t == 1
        min_distance = 0;
    end
    % Updating distance to current node based on other adjacent squares
    for k=1:length(exploration_array)
        if (distance_maze(exploration_array(k, 1), ...
                exploration_array(k, 2)) + 1 < min_distance)
            min_distance = ...
                distance_maze(exploration_array(k, 1),...
                exploration_array(k, 2)) + 1;
        end
    end
    distance_maze(current_node(1), ...
        current_node(2)) = min_distance;

    
    
    % Adding to the frontier:
    for j=1:length(exploration_array)
       % We want to add to the frontier if it is unexplored
       if (maze(exploration_array(j, 1), exploration_array(j, 2)) == 0)
          distance_maze(exploration_array(j, 1), exploration_array(j, 2))...
              = distance_maze(current_node(1), current_node(2)) + 1;
          distance = distance_maze(exploration_array(j, 1), ...
              exploration_array(j, 2));
          manhattan = sum(abs(exploration_array(j, :) - goal));
          euclidean = sqrt(sum((exploration_array(j, :) - goal).^2));
          cost = manhattan + 1.01*distance; 
          % Mark as on the frontier
          if (maze(exploration_array(j, 1), exploration_array(j, 2)) ~= 2)
              maze(exploration_array(j, 1), exploration_array(j, 2)) = 2;
              rectangle('Position',[...
                exploration_array(j, 1)-box_width/2 ...
                exploration_array(j, 2)-box_width/2 ...
                box_width box_width], 'FaceColor', [0 1 1])
          end
          frontier = min_heap_insert(frontier, ...
              [exploration_array(j, :), cost], column, N);
          N = N + 1;
          
       else
           if (maze(exploration_array(j, 1), exploration_array(j, 2)) == 3)
               distance_maze(exploration_array(j, 1), exploration_array(j, 2))...
                  = distance_maze(current_node(1), current_node(2)) + 1;
               fprintf("\nGoal state reached\n")
               finished = 1;
               break;
           end
       end
    end
    maze(current_node(1), current_node(2)) = -1;
    if finished
        break;
    end
    
    figure(1);
end
fprintf("Number of iterations %.0f", t);
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