function [A_ret,B_ret] = multiLvl_KL(Graph,maxnodes)
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
        [Match{i},Map{i}]=rndMatch(Graphs{i});
        Graphs{i+1} = coarse(Graphs{i},Match{i},Map{i});
    end

    
    % initial Partition
    numnodes_ini = length(Graphs{end}.Adjncy);
    A_ini = randi(numnodes_ini,1,ceil(numnodes_ini*0.5)); % random partition
    B_ini = setdiff(1:numnodes_ini,A_ini);
    cut_min = cutValueBisection(Graphs{end},A_ini,B_ini);% inital min cut
    A_min = A_ini;
    B_min = B_ini;
    for l=1:10
        [A_try,B_try]= KL(Graphs{end},A_ini,B_ini,50); % KL

        cut_try = cutValueBisection(Graphs{end},A_try,B_try); % check cut

        if cut_try<cut_min % new minium
            A_min = A_try;  % keep new minimum
            B_min = B_try;
            cut_min = cut_try;
        end
    end
    
    A{end} =A_min;
    B{end} =B_min;

    for j=(numcoar-1):-1:1 % uncoarsening

        [A_ur{j},B_ur{j}] = projectPartition(A{j+1},B{j+1},Map{j}); % projection
        [A{j},B{j}] = KL(Graphs{j},A_ur{j},B_ur{j},numnodes); % KL
        
    end
    

else
    Graphs = {Graph};
    A = cell(1);
    B = cell(1);
    A_ur = cell(1);
    B_ur = cell(1);
    
    
    numnodes_ini = length(Graphs{end}.Adjncy);
    A_ini = randi(numnodes_ini,1,ceil(numnodes_ini*0.5)); % random partition
    B_ini = setdiff(1:numnodes_ini,A_ini);
    cut_min = cutValueBisection(Graphs{end},A_ini,B_ini); % inital min cut
    for l=1:10
        [A_try,B_try]= KL(Graphs{end},A_ini,B_ini,50); % KL

        cut_try = cutValueBisection(Graphs{end},A_try,B_try); % check cut

        if cut_try<cut_min % new minium
            A_min = A_try;  % keep new minimum
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

