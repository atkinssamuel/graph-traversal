function [array] = min_heap_insert(array, element, column, N)
    N = N + 1;
    array(N, :) = element;
    parent = floor(N/2);
    current = N;
    if parent < 1
        return
    end
    while array(parent, column) > array(current, column)
        temp = array(parent, :);
        array(parent, :) = array(current, :);
        array(current, :) = temp;
        current = parent;
        parent = floor(current/2);
        if parent < 1
            print_heap(array, column, N);
            return
        end
    end
    print_heap(array, column, N);
end

