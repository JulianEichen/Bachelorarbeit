function [Match,Map] = rndMatch(G)
%   Computes a random matching on G and a mapping for coarsening induced by
%   the matching
%   Input: instance of myGraph
%   Output:
%       Match - for each vertex v, Match(v) stores the vertex with which v has
%               been matched with
%       Map - stores the label of v in the coarser graph


numnodes = length(G.Adjncy); %  number of nodes
unmatched_nodes = randperm(numnodes);% vector with randomized unmatched nodes
Match = zeros(numnodes,1); % declare Match
Map = zeros(1,numnodes); % declare Map
label = 1; %delcare label


for i = 1:1:numnodes % we need to check every node
    
    node = unmatched_nodes(i); % select random unmatched node
    neighbors = G.Adjncy{node}(:,1);
    numneighbors = length(neighbors);
    neighbors = neighbors(randperm(numneighbors)); % randomize the neighbors

    
    if ~isempty(neighbors) && Match(node) == 0 % if the node has neighbors and is umatched, we look for an unmatched neighbor
        
        for j = 1:1:numneighbors % check all neighbors
            neighbor = neighbors(j); % select neighbor
            
            
            if Match(neighbor) == 0 % check if it's unmatched
                
                % add the nodes to the matching
                Match(node) = neighbor;
                Match(neighbor) = node;
                
                % add the nodes to the map
                Map(node) = label;
                Map(neighbor) = label;
                
                % increment label
                label = label+1;
                
                break
            end
        end
        
        % if we haven't found a proper neighbor, we 'match' the node with
        % itself
        if Match(node) == 0
            Match(node) = node;
            Map(node) = label;
            label = label+1;
        end
        
    else
        
        if Match(node) == 0
            
            Match(node) = node;
            Map(node) = label;
            label = label+1;
            
        end
        
    end
    
end

end