% WFE - computes wavefront error (RMSE over nonzero elements).
%
% E = RMSE(Y)

% Andy Kee 5/4/2016

function e = wfe(W)

e = std(nonzeros(W));
