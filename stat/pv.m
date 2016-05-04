% PV - Computes peak to valley measurement  
%
% M = PV(A)

% Andy Kee 5/4/2016

function m = pv(A)

m = max(A(:)) - min(A(:));
