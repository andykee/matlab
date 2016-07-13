% --------------------------------------------------------------------------
% [zern] = zernike_mode (pupil, modes)
% [zern] = zernike_mode (pupil, modes, rho, theta)  
%
%      Computes the Noll zernike polynomial normalized for the support
% of the specified pupil
%
%          pupil = pupil support functiom (0-1 mask)
%          modes = Zernike mode numbers following Noll's ordering.
%                  Can pass in a vector of modes, ie [1:4]
%          rho   = radial cooridnates system for pupil  (optional)
%          theta = angular coordinate system for pupil  (optional)
%
% NOTE:  If rho and theta are ommitted, they get computed over the pupil
%        with the outscribing circle defining the outer zernike radius.
%
% $Id: zernike_mode.m 23 2007-07-03 21:33:50Z bking $
% $HeadURL: file:///proj/jwst6/OSML/trunk/matlab/zernike/zernike_mode.m $
% --------------------------------------------------------------------------

function [zern_opds, m, n] = zernike_mode (pupil, modes, rho, theta)

     if nargin < 4
        [rho, theta] = zernike_coordinates (pupil, 'CIRCLE');
     end

     % ---------------------------------------------------
     % Compute m and n for the particular zernike mode
     % ---------------------------------------------------

     j = 1;
     zm = [];
     zn = [];
     for n = 0:round(max(modes)/2)
        for m = [[0:2:n]+(mod(n,2)~=0)]
           if m > 0
              zm(j) = m;
              zn(j) = n;
              j = j + 1;
              zm(j) = m;
              zn(j) = n;
              j = j + 1;
           else
              zm(j) = m;
              zn(j) = n;
              j = j + 1;
           end
        end
     end

     % ---------------------------------------------------
     % Compute zernike mode over pupil support
     % ---------------------------------------------------

     iloop = 0;
     
     for imode = modes

	m = zm(imode);
	n = zn(imode);

        R = 0*pupil;
        for s=0:((n-m)/2)
           Rk = (-1)^s*factorial(n-s)/factorial(s)/factorial((n+m)/2-s)/factorial((n-m)/2-s);
           R = R + Rk * rho.^(n-2*s);
        end

        zern = sqrt(n+1) * R;
       
        if m > 0
           if mod(imode,2)==0
              zern = zern .* cos(m*theta) .* sqrt(2);
           else
              zern = zern .* sin(m*theta) .* sqrt(2);
           end
        end

	iloop = iloop + 1;
        zern_opds(:,:,iloop) = zern .* (pupil~=0);

     end
     
return
