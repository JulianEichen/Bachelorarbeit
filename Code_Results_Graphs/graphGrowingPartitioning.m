function [A,B] = graphGrowingPartitioning(Graph)
%   Graph growing partitoning with randum intial node        
%   Input:  instance of myGraph, 
%   Output: partition V=(A,B) on the input graph


numnodes = length(Graph.Adjncy);
limit = ceil(numnodes/2); 
startnode = randi(numnodes);

% BFS

A = zeros(1,limit);
ind_A = 1;
queue = [startnode];
visited = zeros(1,numnodes);
visited(startnode) = 1;



% mark node
while true
    
    %pop
    node=queue(1);
    queue = queue(2:end);
        
    A(ind_A)=node; % add to A
    ind_A = ind_A+1;
    if ind_A>limit 
        break
    end
   
    neighbors = Graph.Adjncy{node}(:,1);
    for i = 1:length(neighbors)
        child = neighbors(i);
        if visited(child) == 0
            queue(end+1) = child; % push
            visited(child)=1;
            change = true;
        end
    end
    
    % if the graph is not connected, we might run into empty queue, which
    % might lead to an imbalanced Partition
    if isempty(queue)
        %ind_vis = 1:length(visited);
        unvisited = 1:length(visited);
        unvisited = unvisited(visited==0);
        
        %push ?
        node = unvisited(1) ;
        queue(end+1) = node;
        visited(node) = 1;
    end
end

A(A==0) = [];
B = 1:numnodes;
B(A) = [];

end

