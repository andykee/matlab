% -------------------------------------------------------------
% [opd_fit, zern_coef] = zernike_fit (opd, pupil, order, rho, theta)
% -------------------------------------------------------------
%
% Computes Noll ordered, Zernike coefficients of an opd. These
% coefficients are normailized with respect to the pupil extent
% represented in the 'pupil' mask passed to the function.
%
% The coefficents are then used to generated an opd fitted over 
% the points specficied in the pupil mask.
%
%   opd       = function to be fitted with Zernike polynomials
%   pupil     = mask over which the zernike basis is defined
%   order     = Either a vector of mode numbers that used in the fit
%                or a stack of pre-generated normalized functions
%   rho,theta = radial and angular coordinate system
%
% -------------------------------------------------------------

function [opd_fit, zern_coef] = zernike_fit (opd, pupil, order, rho, theta)

     [rows cols] = size(opd);

     [y x ovec] = find(opd(:));

     zflag = (size(order,1) > 1) & (size(order,2) > 1);

     nmodes = length(order);
     if zflag
        nmodes = size(order,3);
     end

     Cz = [];
     for n = 1:nmodes

         if ~zflag
             if nargin == 5
                zn = zernike_mode(pupil, order(n), rho, theta);
             else
                zn = zernike_mode(pupil, order(n));
             end
         else
             zn = order(:,:,n);
         end

         zvec = zn(y);

         Cz = [Cz zvec];
     end

     zern_coef = (inv(Cz'*Cz)*Cz'*ovec);

     opd_fit = 0*opd;

     for n = 1:nmodes

         if ~zflag
             if nargin == 5
                zn = zernike_mode(pupil, order(n), rho, theta);
             else
                zn = zernike_mode(pupil, order(n));
             end
         else
             zn = order(:,:,n);
         end

         opd_fit = opd_fit + zern_coef(n) .* zn;
     end

     opd_fit = opd_fit .* (pupil~=0);

return
