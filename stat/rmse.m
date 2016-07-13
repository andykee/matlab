% RMSE - computes root mean square error.
%
% E = RMSE(Y)

% Andy Kee 
% May 2016

function e = rmse(Y)

e = sqrt(Y(:)'*Y(:)/numel(Y));
