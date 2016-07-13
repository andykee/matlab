% PV - Computes peak to valley measurement  
%
% M = PV(A)

% Andy Kee
% May 2016

function m = pv(A)

m = max(A(:)) - min(A(:));
