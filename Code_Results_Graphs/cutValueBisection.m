function [cut] = cutValueBisection(Graph,A,B)
%   returns the value of a cut, induced by the partition A,B
%   Input:  instance of myGraph, partition A,B
%   Output: value of the induced cut
A = A(:).';
B = B(:).';

numnodes = length(Graph.Adjncy);

ED = zeros(numnodes,1);

lenA = length(A);
for i=1:lenA
    % compute values
    node = A(i);
    adj = Graph.Adjncy{node}(:,1); % neighbors of node
   
    ind_out = sum(adj==B,2); % indices of neighbors in P2
    wgt = Graph.Adjncy{node}(:,2); % weights of the neighbors
    
     % sum of inner weights
    ED(node) = sum(wgt(logical(ind_out))); % sum of outer weights
   
    
   
end

lenB = length(B);
for j=1:lenB
    node = B(j);
    adj = Graph.Adjncy{node}(:,1); % neighbors of node
   
    ind_out = sum(adj==A,2); % indices of neighbors in P1
    wgt = Graph.Adjncy{node}(:,2); % weights of the neighbors 
    
     % sum of inner weights
    ED(node) = sum(wgt(logical(ind_out))); % sum of outer weights
    
    
    
end

cut = 0.5*sum(ED);


end

