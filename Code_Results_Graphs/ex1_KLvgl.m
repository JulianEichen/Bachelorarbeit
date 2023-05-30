clc
clear 
close all

seed = 2020250
rng(seed);

% Vergleich unmod. Kernighan-Lin mit zufaelliger initialer Partition und 
% Multilevelpartitionierung mit unmod. Kernighan-Lin zur initialen 
% Partitionierung und Verfeinerung

Graphs = cell(1,15);

% spd Matrizen mit weniger als 10002 Knoten
Graphs{1}= open('Graphen\spd\bcsstk24.mat'); % 3562

Graphs{2} = open('Graphen\spd\sts4098.mat'); % 4098

Graphs{3} = open('Graphen\spd\bcsstk38.mat'); % 8032

Graphs{4} = open('Graphen\spd\fv3.mat'); % 9801

Graphs{5} = open('Graphen\spd\bloweybq.mat'); % 10001


% spd Matrizen mit ca 20000 Knoten
Graphs{6} = open('Graphen\spd\crystm02.mat'); % 13965

Graphs{7} = open('Graphen\spd\Dubcova1.mat'); % 16129

Graphs{8} = open('Graphen\spd\raefsky4.mat'); % 19799

% ----------


KL_cut = zeros(1,5);
ML_cut = zeros(1,5);
KL_time = zeros(1,5);
ML_time= zeros(1,5);
for i=1:2
    
    M_G = Graphs{i}.Problem.A;
    M_G(find(M_G)) = 1;
    graph = myGraph(M_G);
    numnodes = length(graph.Adjncy);
    A_ini = randi(numnodes,1,ceil(numnodes*0.5));
    B_ini = setdiff(1:numnodes,A_ini);
    
    tic
    [A_ml,B_ml] = multiLvl_KL(graph,100);
    ML_time(i) = toc;
    ML_cut(i) = cutValueBisection(graph,A_ml,B_ml);
  
     tic
     [A_fl, B_fl] = KL(graph,A_ini,B_ini,numnodes);
     KL_time(i) = toc;
     KL_cut(i) = cutValueBisection(graph,A_fl,B_fl);
end

fprintf('--------------------finished--------------------')