function [array] = create_min_heap(array, column, N)
    mid = floor(length(array)/2);
    
    for i = mid:-1:1
       array = min_heapify(array, i, column, N);
    end
end

