% -----------------------------------------------------------
% [result, zk] = zernike_remove(opd, modes, rho, theta)
% -----------------------------------------------------------
% 
% Remove a set of zernikes, specified in the vector 'modes'
% from the passed opd.  The modes passed are in the order of
% Noll.  The returned 'result' is simply the difference of 
% the passed opd and the zernike fit to that opd.
%
% -----------------------------------------------------------

function [result,zk] = zernike_remove(opd, modes, rho, theta)

   niter = 1;

   if length(modes) == 0
      result = opd
      zk = [];
      return
   end

   [rows cols] = size(opd);
   mask = opd~=0;

   if nargin == 4
       [zfit, zk] = zernike_fit(opd, mask, modes, rho, theta);
   else
       [zfit, zk] = zernike_fit(opd, mask, modes);
   end

   result = opd - zfit;


return

