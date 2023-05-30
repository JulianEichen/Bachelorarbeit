function [match,M_cut] = maxMatchCut(Graph,A,B)
% Computes maximum matching on the cut induced by partition A and B on Graph
% Derived from:
% https://www.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/19218/versions/1/previews/matgraph/html/matgraph/@graph/bipmatch.html
% Input: instance of myGraph, partition A,B
% Output: match - maximum matching on the bipartite graph induced by the cut
%         M_cut - adjacency matrix of the bip graph of the matching


numnodes = length(Graph.Adjncy);

% create Graph from outgoing edges of the partition

M_out = sparse(numnodes,numnodes);

for i =1:length(A)
    node = A(i);
    adj = Graph.Adjncy{node}(:,1);
    ind_out = sum(adj==B,2);
    adj_p2 = adj(logical(ind_out));
    
    if  M_out(node,adj_p2) == 0
        M_out(node,adj_p2) = 1;
    end
    
end
for i =1:length(B)
    node = B(i);
    adj = Graph.Adjncy{node}(:,1);
    ind_out = sum(adj==A,2);
    adj_p1 = adj(logical(ind_out));
    
    if  M_out(node,adj_p1) == 0
        M_out(node,adj_p1) = 1;
    end
end

M_cut=M_out;

M_out= M_out(A,B);

p = dmperm(M_out);

yidx = find(p);
xidx = p(p>0);

x = A(xidx);
y = B(yidx);

match = [x(:),y(:)];
match = sortrows(match);

end

