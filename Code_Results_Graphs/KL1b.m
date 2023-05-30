function [A,B,Cuts] = KL1b(Graph,A,B,maxStreak)
%   One pass of the KL algorithm, onle nodes in the cut get moved     
%   Input:  instance of myGraph, inital partition A,B, maximum size of
%   streak of failures for inner loop
%   Output: partition V=(A,B) on the input graph

A = A(:).';
B = B(:).';

numnodes = length(Graph.Adjncy);

x = maxStreak;

% gain
ID = zeros(numnodes,1);
ED = zeros(numnodes,1);
Dif = zeros(numnodes,1);

% 0 -> part1, 1->part2
% this also means that length(A)=nnz(part),
% length(B)=length(part)-nnz(part)
part = zeros(numnodes,1);
visited = zeros(numnodes,1);


lenA = length(A);
for i=1:lenA
    % compute values
    node = A(i);
    adj = Graph.Adjncy{node}(:,1); % neighbors of node
    ind_in = sum(adj==A,2);  % indices of neighbors in A
    ind_out = sum(adj==B,2); % indices of neighbors in B
    wgt = Graph.Adjncy{node}(:,2); % weights of the neighbors
    
    ID(node)= sum(wgt(logical(ind_in))); % sum of inner weights
    ED(node) = sum(wgt(logical(ind_out))); % sum of outer weights
    Dif(node) = ED(node)-ID(node);
    
    % fill part
    part(node) = 0;
end

lenB = length(B);
for j=1:lenB
    node = B(j);
    adj = Graph.Adjncy{node}(:,1); % neighbors of node
    ind_in = sum(adj==B,2);  % indices of neighbors in B
    ind_out = sum(adj==A,2); % indices of neighbors in A
    wgt = Graph.Adjncy{node}(:,2); % weights of the neighbors
    
    ID(node)= sum(wgt(logical(ind_in))); % sum of inner weights
    ED(node) = sum(wgt(logical(ind_out))); % sum of outer weights
    Dif(node) = ED(node)-ID(node);
    
    % fill part
    part(node) = 1;
end

Dif = ID-ED;


cut_min = 0.5*sum(ED);

A_try = A;
B_try = B;

count = 0;


Cuts = sparse(1,numnodes+1);
Cuts(1) = cut_min;

for k=1:numnodes
    % Move
    % -----------
    if length(A_try)>=length(B_try)
        
        % get node with biggest gain
        
        max_dif = max(Dif(visited==0 & part==0 & ED>0)); % maximum unvisited value in Dif, that belongs to the border of A
        if ~isempty(max_dif)
            ind_max = find(Dif==max_dif & part==0 & ED>0); % indices in Dif of max value
            max_node=ind_max(1);
            
            
            % move to B
            B_try(end+1) = max_node; % add to B
            A_try(A_try==max_node)=[]; % delete from A
            part(max_node) = 1; % set partition of max_node
            visited(max_node)=1; % mark max_node as visited
            
            %Update
            %-----*-----*-----
            % we need to update the neighbors and the moved node itself
            nodesToUp = Graph.Adjncy{max_node}(:,1); % neighbors of max_node
            nodesToUp(end+1) = max_node;
            
            for i = 1:length(nodesToUp)
                node_tu = nodesToUp(i);
                
                
                if part(node_tu)==0 % node to update belongs to A
                    adj = Graph.Adjncy{node_tu}(:,1); % neighbors of node
                    
                    ind_in = sum(adj==A_try,2);  % indices of neighbors in A_try
                    ind_out = sum(adj==B_try,2); % indices of neighbors in B_try
                    wgt = Graph.Adjncy{node_tu}(:,2); % weights of the neighbors
                    
                    ID(node_tu)= sum(wgt(logical(ind_in))); % sum of inner weights
                    ED(node_tu) = sum(wgt(logical(ind_out))); % sum of outer weights
                    Dif(node_tu) = ED(node_tu)-ID(node_tu);
                else % node to update belongs to B
                    adj = Graph.Adjncy{node_tu}(:,1); % neighbors of node
                    
                    ind_in = sum(adj==B_try,2);  % indices of neighbors in B_try
                    ind_out = sum(adj==A_try,2); % indices of neighbors in A_try
                    wgt = Graph.Adjncy{node_tu}(:,2);
                    
                    
                    ID(node_tu)= sum(wgt(logical(ind_in))); % sum of inner weights
                    ED(node_tu) = sum(wgt(logical(ind_out))); % sum of outer weights
                    Dif(node_tu) = ED(node_tu)-ID(node_tu);
                end
                
            end
            
            
            
        end
        
    else
        
        max_dif =max(Dif(visited==0 & part==1 & ED>0)); % maximum invisited value in Dif, that belongs to the border of B
        
        
        if ~isempty(max_dif)
            ind_max = find(Dif==max_dif & part==1 & ED>0);% indices in Dif of max value
            max_node=ind_max(1);
            
            % move to A
            A_try(end+1) = max_node; % add to A
            B_try(B_try==max_node)=[]; % delete from B
            part(max_node) = 0; % set partition of max_node
            visited(max_node)=1; % mark max_node as visited
            
            %Update
            %-----*-----*-----
            % We only need to update the neighbors of the moved node
            % we need to update the neighbors and the moved node itself
            nodesToUp = Graph.Adjncy{max_node}(:,1); % neighbors of max_node
            nodesToUp(end+1) = max_node;
            
            for i = 1:length(nodesToUp)
                node_tu = nodesToUp(i);
                
                
                if part(node_tu)==0 % node to update belongs to A
                    adj = Graph.Adjncy{node_tu}(:,1); % neighbors of node
                    
                    ind_in = sum(adj==A_try,2);  % indices of neighbors in A_try
                    ind_out = sum(adj==B_try,2); % indices of neighbors in B_try
                    wgt = Graph.Adjncy{node_tu}(:,2); % weights of the neighbors
                    
                    ID(node_tu)= sum(wgt(logical(ind_in))); % sum of inner weights
                    ED(node_tu) = sum(wgt(logical(ind_out))); % sum of outer weights
                    Dif(node_tu) = ED(node_tu)-ID(node_tu);
                else % node to update belongs to B
                    adj = Graph.Adjncy{node_tu}(:,1); % neighbors of node
                    
                    ind_in = sum(adj==B_try,2);  % indices of neighbors in B_try
                    ind_out = sum(adj==A_try,2); % indices of neighbors in A_try
                    wgt = Graph.Adjncy{node_tu}(:,2);
                    
                    
                    ID(node_tu)= sum(wgt(logical(ind_in))); % sum of inner weights
                    ED(node_tu) = sum(wgt(logical(ind_out))); % sum of outer weights
                    Dif(node_tu) = ED(node_tu)-ID(node_tu);
                end
                
            end
            
        end
    end
    
    
    % Check new cut
    % -----------
    
    cut_new = 0.5*sum(ED);
    
    if cut_new<cut_min % found a new minium
        count = 0; % reset streak
        A = A_try; % keep minmimal partition
        B = B_try;
        cut_min = cut_new; % keep minimum
    else
        count = count+1;
    end
    
    
    
    % if we reach a streak of non-improvements of length x, we want to stop
    if count > x
        break
    end
    
    
end




end

