function [A_new,B_new] = projectPartition(A,B,Map)
% projects a partition in the multilevel scheme from a coarser graph the
% uncoarser one
% Input: partition in coarser graph A,B; Mapping from the coarsening
% Output: partiton in the uncoarser graph A_new, B_new

A_new = find(sum(Map==A(:)))';
B_new = find(sum(Map==B(:)))';
end

