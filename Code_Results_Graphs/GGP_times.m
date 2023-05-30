function [A_min,B_min] = GGP_times(Graph,tries)
%   Repeated graph growing partitioning on graph      
%   Input:  instance of myGraph, maximum number of tries for the ggp
%   Output: partition V=(A_min,B_ret) on the input graph



[A_min,B_min] = graphGrowingPartitioning(Graph);
cut_min = cutValueBisection(Graph,A_min,B_min); %cut value

for i=1:tries-1
    [A_try,B_try]=  graphGrowingPartitioning(Graph);
    
    
    cut_try = cutValueBisection(Graph,A_try,B_try);
    if cut_try<cut_min
        A_min = A_try;
        B_min = B_try;
        cut_min = cut_try;
    end
    
end


end

