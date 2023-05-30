classdef myGraph
    
    properties
        % stores information about the vertices
        % Vtxs ={vwgt,nedges,iedges,cewgt,adjwgt};
        % vwgt - the weight of v
        % nedges - the size of the adjacency list of v
        % iedges - the index into Adjncy that is the beginning of the
        %   adjacency list of v
        % cewgt - the weight of the edges that have been contracted to
        %   create v
        % adjwgt -  the sum of the weight of the edges adjacent to v
        Vtxs
        
        % stores the adjacency lists of the vertices
        % 
        Adjncy
        
        % Counter for the 
        coarsening
        
    end
    
    methods
        
        function obj = myGraph(adj_matrix)   
            % Default constructor
            %----+----+----+----+----+----+----+----+----+----+
            % returns empty graph
            if nargin == 0
                return
            end
            %----+----+----+----+----+----+----+----+----+----+
                
            
            % Non-empty graph
            %----+----+----+----+----+----+----+----+----+----+
            % returns graph specified by the adjacency matrix
            
            numnodes = length(adj_matrix); % number of nodes depending on the adjacency matrix
            
            % size of the adjacency list of v
            nedges = zeros(numnodes,1); % vector with number of edges for each node
            for i=1:numnodes % check every node
                edg_list = adj_matrix(i,:);
                edg_list(i) = 0; % filter selfloop
                nedges(i) = nnz(edg_list);
            end
            
            
           
            
            % initalize adjacency list
            % we need an adjacency list for each vertex
            % the lists will consist of touples l(l_1,l_2)
            % where 
            % l_1 = the label of the adjacent vertex 
            % l_2 = the weight of the connecting edge
            Adjncy = cell(numnodes,1); 
            
            for i = 1:1:numnodes % check every node
                adj_list = zeros(nedges(i),2); % create an empty list for each node
                
                adj_vec = adj_matrix(i,:); %% filter selfloop 26.5.2020
                adj_vec(i) = 0;
                %adj_list(:,1) = find(adj_matrix(i,:)); % labels TODO: explain - find(A(i,:)): indices of nonzeros in line i
                %adj_list(:,2) = nonzeros(adj_matrix(i,:)); % weights - nonzeros(A(i,:)): nonzero elements in line i
                adj_list(:,1) = find(adj_vec); 
                adj_list(:,2) = nonzeros(adj_vec);
                
                Adjncy(i) = {adj_list}; % add list to Adjncy
            end
            
            obj.Adjncy = Adjncy; % set Adjncy
            
       
            
            % weight of vertex v
            vwgt = zeros(numnodes,1); % vector for the weight of every vertex 
            
            % the index into Adjncy that is the beginning of the adjacency list of v
            iedges = zeros(numnodes,1);
           cewgt = zeros(numnodes,1);
            
            % the sum of the weight of the edges adjacent to v
            adjwgt = sum(adj_matrix,2);
            
            %Vtxs = cell(1,5);
            Vtxs ={vwgt,nedges,iedges,cewgt,adjwgt};
            obj.Vtxs = Vtxs;
            
             %----+----+----+----+----+----+----+----+----+----+
        end  
      
        

        
    end
    
end

