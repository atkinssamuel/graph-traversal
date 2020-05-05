function [array] = min_heapify(array, index, column, N)
    left = 2 * index;
    right = 2 * index + 1;
    
    minimum = index;
    
    if left <= N && array(left, column) < array(minimum, column)
       minimum = left; 
    end
    
    if right <= N && array(right, column) < array(minimum, column)
       minimum = right; 
    end
    
    if index ~= minimum
        temp = array(index, :);
        array(index, :) = array(minimum, :);
        array(minimum, :) = temp;
        array = min_heapify(array, minimum, column, N);
    end
end

