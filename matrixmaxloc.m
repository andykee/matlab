function [r,c] = matrixmaxloc(A)

[maxA,indx] = max(A(:));
[r,c] = ind2sub(size(A),indx);
