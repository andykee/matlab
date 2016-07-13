% function opd = zernike_compose (opd_mask, zern_coef, rho, theta)
%
% Creates an OPD based on Zernike coefficients. Coefficients less
% than 1e-12 are ignored in the composition. rho and theta are
% optional arguments, and if excluded the points of the OPD will
% be chosen according to a grid defined by opd_mask.
%
% $Id: zernike_compose.m 23 2007-07-03 21:33:50Z bking $
%
% $HeadURL: file:///home/svn/repos/unity/trunk/matlab/zernike/zernike_compose.m $
% -------------------------------------------------------------

function opd = zernike_compose (opd_mask, zern_coef, rho, theta)

  opd = zeros(size(opd_mask));
  zi = find(abs(zern_coef) > 1e-12);

  if isempty(zi)
    return
  end

  for n=1:length(zi)
    if nargin < 3
      opd = opd + zern_coef(zi(n)) * zernike_mode(opd_mask, zi(n));
    else
      opd = opd + zern_coef(zi(n)) * zernike_mode(opd_mask, zi(n), rho, theta);
    end
  end
