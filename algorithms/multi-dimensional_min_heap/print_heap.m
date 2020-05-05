function print_heap(array, column, N)
    fprintf("\nHeap:\n")
    
    for i = 0:floor(N/2)
        start = pow2(i);
        finish = pow2(i) + pow2(i) - 1;
        for j = start:finish
           fprintf('%.0f ', array(j, column));

           if j == N
               fprintf('\n')
               return
           end
        end
        fprintf('\n')
    end
end