function [A_ret,B_ret] = multiLvl_KL_GGPT(Graph,maxnodes,initialTries)
%    Multilevel KL scheme witih:
%           - Initial partition: Random partition + KL
%           - KL works unrestrictd on initial part and refinement        
%   Input:  instance of myGraph, maximum nodes for the coearest graph
%   Output: partition V=(A_ret,B_ret) on the input graph


numnodes = length(Graph.Adjncy);
numcoar = ceil(log2(numnodes/maxnodes)); % check how many coarseings we need to do
if numcoar>1
    size_vec = 1:numcoar;
    sz = size(size_vec);
    Graphs = cell(sz);
    Graphs{1} = Graph;
    Match = cell(sz);
    Map = cell(sz);
    A_ur = cell(sz);
    B_ur = cell(sz);
    A = cell(sz);
    B = cell(sz);
    

    
     % coarsening
    for i=1:numcoar-1
        [Match{i},Map{i}]=rndHeavyMatch_KaKu2(Graphs{i});
        Graphs{i+1} = coarse_KaKu3(Graphs{i},Match{i},Map{i});
    end

    
    % initial Partition
    %
    [A{end},B{end}] = GGP_times(Graphs{end},1);
    A_min =A{end};
    B_min =B{end};

    cut_min = cutValue_bisection(Graphs{end},A_min,B_min);
    for l=1:initialTries
        [A_try,B_try] = GGP_times(Graphs{end},10);
        [A_try,B_try]= KL_full(Graphs{end},A_try,B_try);

        cut_try = cutValue_bisection(Graphs{end},A_try,B_try);

        if cut_try<cut_min
            A_min = A_try;
            B_min = B_try;
            cut_min = cut_try;
        end
    end
    
    A{end} =A_min;
    B{end} =B_min;

    for j=(numcoar-1):-1:1

        [A_ur{j},B_ur{j}] = project_partition_KaKu(A{j+1},B{j+1},Map{j});
        [A{j},B{j}] = KL_full(Graphs{j},A_ur{j},B_ur{j});
        
    end
    

else
    Graphs = {Graph};
    A = cell(1);
    B = cell(1);
    A_ur = cell(1);
    B_ur = cell(1);
    
    [A{end},B{end}] = GGP_times(Graphs{end},1);
    A_min =A{end};
    B_min =B{end};
 
    cut_min = cutValue_bisection(Graphs{end},A_min,B_min);
    
    for l=1:initialTries
        
        [A_try,B_try] = GGP_times(Graphs{end},10);
        [A_try,B_try]=  KL_full(Graphs{end},A_try,B_try);
        
        cut_try = cutValue_bisection(Graphs{end},A_try,B_try);
        if cut_try<cut_min
            
            A_min = A_try;
            B_min = B_try;
            cut_min = cut_try;
        end
    end
    
    A{end} = A_min;
    B{end} = B_min;

end

A_ret = A{1};
B_ret = B{1};

end

