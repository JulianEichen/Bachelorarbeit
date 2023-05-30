clear
clc
close all

seed = 111598
rng(seed)
graphdata = open('graphen\spd\bcsstk38.mat');

M = graphdata.Problem.A;

M_G = graphdata.Problem.A;
M_G(find(M_G)) = 1;
anzKnoten = length(M_G);
graph = myGraph(M_G);


numnodes = length(graph.Adjncy)

%------------------------------
A_ini = randi(numnodes,1,ceil(numnodes*0.5));
B_ini = setdiff(1:numnodes,A_ini);
[A_KL, B_KL] = KL(graph,A_ini,B_ini,numnodes);
cut_KL = cutValueBisection(graph,A_KL,B_KL);

%------------------------------
[A_mlKL,B_mlKL] = multiLvl_KL(graph,100);
cut_mlKL = cutValueBisection(graph,A_mlKL,B_mlKL);

%------------------------------
[A_mlKL1,B_mlKL1] = multiLvl_KL1_GGPT(graph,100,10);
cut_mlKL1 = cutValueBisection(graph,A_mlKL1,B_mlKL1);

%------------------------------
[A_mlKL1b,B_mlKL1b] = multiLvl_KL1b_GGPT(graph,100,10);
cut_mlKL1b = cutValueBisection(graph,A_mlKL1b,B_mlKL1b);

fprintf('-------------------- \n')
fprintf('Separators \n')
[match_KL,Acut_KL] = maxMatchCut(graph,A_KL,B_KL);
S_KL = separator(match_KL,A_KL,B_KL,Acut_KL);

re_a_KL = setdiff(A_KL,S_KL);
re_b_KL = setdiff(B_KL,S_KL);

reord2_KL = [re_b_KL re_a_KL S_KL];

M_2_KL = M(reord2_KL,reord2_KL);
%------------------------------

%------------------------------
[match_mlKL,Acut_mlKL] = maxMatchCut(graph,A_mlKL,B_mlKL);
S_mlKL = separator(match_mlKL,A_mlKL,B_mlKL,Acut_mlKL);

re_a_mlKL = setdiff(A_mlKL,S_mlKL);
re_b_mlKL = setdiff(B_mlKL,S_mlKL);

reord2_mlKL = [re_b_mlKL re_a_mlKL S_mlKL];

M_2_mlKL = M(reord2_mlKL,reord2_mlKL);
%------------------------------

%------------------------------
[match_mlKL1,Acut_mlKL1] = maxMatchCut(graph,A_mlKL1,B_mlKL1);
S_mlKL1 = separator(match_mlKL1,A_mlKL1,B_mlKL1,Acut_mlKL1);

re_a_mlKL1 = setdiff(A_mlKL1,S_mlKL1);
re_b_mlKL1 = setdiff(B_mlKL1,S_mlKL1);

reord2_mlKL1 = [re_b_mlKL1 re_a_mlKL1 S_mlKL1];

M_2_mlKL1 = M(reord2_mlKL1,reord2_mlKL1);
%------------------------------

%------------------------------
[match_mlKL1b,Acut_mlKL1b] = maxMatchCut(graph,A_mlKL1b,B_mlKL1b);
S_mlKL1b = separator(match_mlKL1b,A_mlKL1b,B_mlKL1b,Acut_mlKL1b);

re_a_mlKL1b = setdiff(A_mlKL1b,S_mlKL1b);
re_b_mlKL1b = setdiff(B_mlKL1b,S_mlKL1b);

reord2_mlKL1b = [re_b_mlKL1b re_a_mlKL1b S_mlKL1b];

M_2_mlKL1b = M(reord2_mlKL1b,reord2_mlKL1b);
%------------------------------


fprintf('-------------------- \n')
fprintf('Chol \n')


L_2_KL = chol(M_2_KL,'lower');
N_2_KL = nnz(L_2_KL)

L_2_mlKL = chol(M_2_mlKL,'lower');
N_2_mlKL = nnz(L_2_mlKL)

L_2_mlKL1 = chol(M_2_mlKL1,'lower');
N_2_mlKL1 = nnz(L_2_mlKL1)

L_2_mlKL1b = chol(M_2_mlKL1b,'lower');
N_2_mlKL1b = nnz(L_2_mlKL1b)

L = chol(M,'lower');
N = nnz(L);