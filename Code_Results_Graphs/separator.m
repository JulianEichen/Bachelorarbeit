function [K] = separator(match,A,B,M_cut)
%   Computes a seperator for A,B from a maximum matching on a cut induced by partitions A,B 
%   Find a minimum vertex cover on the matching, by dpeth first search
%   Input:  partitions A,B; matching on the cut of A,B,; 
%            M_cutAdjacency matrix fro the bipartite graph induced by the cut  
%   Output: separator K


cutGraph = myGraph(M_cut);
numnodes = length(M_cut);


% create matched matrix
matched = sparse(numnodes,numnodes);
m1 = match(:,1);
m2 = match(:,2);
for i=1:length(m1) 
    matched(m1(i),m2(i))=1;
    matched(m2(i),m1(i))=1;
end

U = [];
for j = 1:length(A)
    node_A = A(j);
    if ~isempty(cutGraph.Adjncy{node_A}(:,1))
       U(end+1) = node_A; 
    end
end

U = setdiff(U,m1,'stable');
% Create Z the set of vertices either in U, or connected to U by
% alternating paths

reachable = zeros(1,numnodes); 
for k=1:length(U) %check all unmatched Nodes in A
    node = U(k); 
    
    stack = [node]; % push neighborn as starting node
    
    %reachedByM = zeros(numnodes);
    reachedByM = sparse(numnodes,numnodes);
    reachedByM(node,node) = 1;
    
    while ~isempty(stack)
        v = stack(end); % pop v
        stack(end) = [];
        if reachable(v) == 0
            reachable(v) = 1;
            if reachedByM(v,v)== 1 % reached through an edge in M
                adj_v = cutGraph.Adjncy{v}(:,1);
                for m=1:length(adj_v)
                    neighbor_v = adj_v(m);
                    if matched(v,neighbor_v) == 0 % reachable by edge not in M
                        stack(end+1)=neighbor_v; % push
                        reachedByM(neighbor_v,neighbor_v) = 0;
                    end
                end
                
                
            else % reached through an edge not in M
                adj_v = cutGraph.Adjncy{v}(:,1);
                for m=1:length(adj_v)
                    neighbor_v = adj_v(m);
                    if matched(v, neighbor_v) == 1
                        stack(end+1)=neighbor_v; % push
                        reachedByM(neighbor_v,neighbor_v)=1;
                    end
                end
            end
        end
    end
        
        
        
    
end

% according to Koenigs theorem
Z = 1:numnodes;
Z = Z(logical(reachable));
Z = union(Z,U);

X = match(:,1);
Y = match(:,2);
K = union(setdiff(X,Z,'stable'),intersect(Y,Z,'stable'),'stable'); 
K = K(:).';

end

