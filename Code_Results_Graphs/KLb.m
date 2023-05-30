function [A,B,nIt] = KLb(Graph,A,B,maxStreak)
%   Kernighan-Lin with restricted inner loop and only nodes in the cut get moved     
%   Input:  instance of myGraph, inital partition A,B, maximum size of
%   streak of failures for inner loop
%   Output: partition V=(A,B) on the input graph, number outer KL loop passes


nIt = 1;
[A,B,~] = BKL_once(Graph,A,B,maxStreak);
cut = cutValue_bisection(Graph,A,B);
cut_new = cut-1;
dif = cut-cut_new;
while dif>0 % cut gets smaller
    [A_new,B_new,~] = BKL_once(Graph,A,B,maxStreak);
    cut_new = cutValue_bisection(Graph,A_new,B_new);
   
    dif = cut-cut_new;
    cut = cut_new;
    if dif>0
        A = A_new;
        B = B_new;
    end
    nIt = nIt+1;
end

end


