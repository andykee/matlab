% RMSE - computes root mean square error.
%
% E = RMSE(Y)

% Andy Kee 5/4/2016

function e = rmse(Y)

e = sqrt(Y(:)'*Y(:)/numel(Y(:)));
