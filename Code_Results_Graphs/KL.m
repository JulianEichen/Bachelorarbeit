function [A,B,nIt] = KL(Graph,A,B,maxStreak)
%   Kernighan-Lin with restricted inner loop     
%   Input:  instance of myGraph, inital partition A,B, maximum size of
%   streak of failures for inner loop
%   Output: partition V=(A,B) on the input graph, number outer KL loop passes

nIt = 1;
cut = cutValueBisection(Graph,A,B);
[A,B] = KL_iteration(Graph,A,B,maxStreak);
cut_new = cutValueBisection(Graph,A,B);
dif = cut-cut_new;

while dif>0 % cut gets smaller
  
    cut = cut_new; % keep minium
    [A,B] = KL_iteration(Graph,A,B,maxStreak); % try new refinement
    cut_new = cutValueBisection(Graph,A,B); % check new cut
    dif = cut-cut_new ;
   
    nIt = nIt+1;
end


end


