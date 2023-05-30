function [A_ret,B_ret] = multiLvl_KL1b_GGPT(Graph,maxnodes,ggpTries)
%    Multilevel KL scheme witih:
%           - Initial partition: with graph growing partitoining and 10
%           passes of KL1b 
%           - single KLb pass as refinement       
%   Input:  instance of myGraph, maximum nodes for the coearest graph
%   Output: partition V=(A_ret,B_ret) on the input graph

numnodes = length(Graph.Adjncy);
numcoar = ceil(log2(numnodes/maxnodes));
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
        [Match{i},Map{i}]=rndMatch(Graphs{i});
        Graphs{i+1} = coarse(Graphs{i},Match{i},Map{i});
    end
    
    [A{end},B{end}] = GGP_times(Graphs{end},ggpTries);    
    
    A_min =A{end};
    B_min =B{end};
    cut_min = cutValueBisection(Graph,A_min,B_min);
    for l=1:10
        [A_try,B_try]=  KL1b(Graph,A_min,B_min,50); % Kernighan Lin
        cut_try = cutValueBisection(Graph,A_try,B_try);
        if cut_try<cut_min
            A_min = A_try;
            B_min = B_try;
            cut_min = cut_try;
        end
    end
    
    A{end} =A_min;
    B{end} =B_min;
    
    % uncoarseing
    for j=(numcoar-1):-1:1
        [A_ur{j},B_ur{j}] = projectPartition(A{j+1},B{j+1},Map{j});
        % -----------------------------------------
       
        %------------------------------------------
        [A{j},B{j}] = KL1b(Graphs{j},A_ur{j},B_ur{j},50);  % Kernighan Lin
        
    end
    
    
else
    A = cell(1);
    B = cell(1);
    [A{end},B{end}] = GGP_times(Graph,ggpTries);
end
A_ret = A{1};
B_ret = B{1};

end

