function [Graph_coarse] = coarse(Graph_org,Match,Map)
% Coarsens a graph in the multilevel scheme
% Input: Graph - instance of myGraph
%        Match - matching on the graph
%        Map - mapping for the coarsening
% Output: Graph_coarse - coarsened myGraph

Graph_coarse = myGraph();
Graph_coarse.coarsening = Graph_org.coarsening+1;

numnodes_coarse = max(Map); % number of nodes in the coarsened graph

% components of Vtxs
vwgt_coarse = zeros(numnodes_coarse,1);
nedges_coarse = zeros(numnodes_coarse,1);
cewgts_coarse = zeros(numnodes_coarse,1);
adjwgt_coarse = zeros(numnodes_coarse,1);
iedges_coarse = zeros(numnodes_coarse,1);

for node = 1:numnodes_coarse % check every node
    
    
    pair = find(Map==node); % labels of matched nodes in the original graph
    
    if length(pair)==1
        
        adj= Map(Graph_org.Adjncy{pair(1)}(:,1)); % adjacency of the first node
    elseif length(pair)==2
        adj1= Map(Graph_org.Adjncy{pair(1)}(:,1));
        adj2= Map(Graph_org.Adjncy{pair(2)}(:,1));
        adj = union(adj1,adj2);
        adj = setdiff(adj,Map(pair(1)));
    end
    
    nedges = length(adj); % size of the adjancency list
    nedges_coarse(node) = nedges;
    adj_list = zeros (nedges,2); % vector for adjacency list and weights
    adj_list(:,1) = adj; % add the adjacency list
    
    % remaining quantities (p. 389)
    % remember Vtxs ={vwgt,nedges,iedges,cewgts,adjwgt};
    % - vwgt of u1 is computed as the sum of the vwgts of v1 and v2
    % - cewgt of u1 is computed as the sum of the cewgts of v1 and v2, plus the weight
    %   of the edge connecting these vertices.
    % - adjwgt of u1 is a computed sum of
    %   the adjwgts of v1 and v2, minus the weight of the edge connecting them
    for i = 1:1:length(pair)
        vwgt_coarse(node) = vwgt_coarse(node) + Graph_org.Vtxs{1}(pair(i));
        
        cewgts_coarse(node) = cewgts_coarse(node)+ Graph_org.Vtxs{4}(pair(i));
        
        adjwgt_coarse(node) = adjwgt_coarse(node) + Graph_org.Vtxs{5}(pair(i));
        
        if length(pair)==2
            ind_rq = Graph_org.Adjncy{pair(1)}(:,1)==pair(2);
            weight_rq = sum(Graph_org.Adjncy{pair(1)}(ind_rq,2));
            
            cewgts_coarse(node) = cewgts_coarse(node) + weight_rq;
            adjwgt_coarse(node) = adjwgt_coarse(node) - weight_rq;
        end
        
    end
    
    
    
    
    
    
    % weights as described in KaKu
    %--------------------------------------------------
    for j = 1:nedges % check all edges (node,neighbor)
        
        neighbor = adj(j); % neighbor
        x = find(Map==neighbor); % indices of neighbor in Map -> labels of nodes in org Graph that make up u2 (u2 might not be a pair in Map)
        
        
        if length(x)>1 % u_j is a pair of nodes in the original graph
            
            weight=0;
            for k = 1:1:length(pair)
                ind1 = Graph_org.Adjncy{pair(k)}(:,1)==x(1); % label of x(1), if it is adjacent to uk
                ind2 = Graph_org.Adjncy{pair(k)}(:,1)==x(2); % label of x(2), if it is adjacent to uk
                inda = ind1|ind2; % joint index vector
                
                weight = weight + sum(Graph_org.Adjncy{pair(k)}(inda,2)); % weight of edges (u1,x(1)) and (u1,x(2))
                
            end
            
        else %length(u2)=length(x)=1
            
            weight = 0;
            for k = 1:1:length(pair)
                ind_k_1 = Graph_org.Adjncy{pair(k)}(:,1)==x; % label of x, if it is adjacent to uk
                %weight_k_1 = sum(Graph_org.Adjncy{pair(k)}(ind_k_1,2)); % weight of edges (uk,x)
                
                
                weight = weight + sum(Graph_org.Adjncy{pair(k)}(ind_k_1,2));
                
            end
            
        end
        adj_list(j,2) = weight;
        
    end
    %--------------------------------------------------
    
    Graph_coarse.Adjncy{node}= adj_list;
    
    
end

% remember Vtxs ={vwgt,nedges,iedges,cewgts,adjwgt};

Graph_coarse.Vtxs = {vwgt_coarse,nedges_coarse,iedges_coarse,cewgts_coarse, adjwgt_coarse};



end

