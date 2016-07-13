% function [rho, theta] = zernike_coordinates (pupil, method, center)
% ---------------------------------------------------------------
%
% Generates the zernike coordinate system appropriately normalized
% for the specified method
%
% Inputs:
%
%    pupil  =  zero-one mask showing support of pupil
%    method =  coordinate normalization method
%               'CIRCLE'  - outscribing circle radius =  1
%                           center coordinates = 0
%               'AXIS'    - largest X departure = 1
%                           largest Y departure = 1
%                           center coordinates = 0
%               'GENERAL' - Exterior perimeter = 1
%                           interior perimeter = 0;
%    center =  [x_center y_center] in pixels (x=col, y=row)
%               if omitted the center is the centroid of the pupil
%
% Outputs:
% 
%    rho    =  radial coordinates 
%    theta  =  angular coordinates 
% 
% $Id: zernike_coordinates.m 23 2007-07-03 21:33:50Z bking $
%
% $HeadURL: file:///proj/jwst6/OSML/trunk/matlab/zernike/zernike_coordinates.m $
% ---------------------------------------------------------------

function [rho, theta] = zernike_coordinates (pupil, method, center)

   [rows, cols] = size(pupil~=0);  npix= max(rows,cols);

   mask = (pupil~=0);

   if nargin < 2
     method = 'CIRCLE'
   end

   % Determine the Central Ordinate of the Pupil

   if nargin < 3
      xc = floor(cols/2) + 1;
      yc = floor(rows/2) + 1;
      m  = sum(sum(mask));
      if m ~= 0,
         mx = sum(mask)  * [1:cols]';
         my = sum(mask') * [1:rows]';
         xc = mx / m;
         yc = my / m;
      end
   else
      xc = center(1);
      yc = center(2);
   end

   % Define Initial Pixel Coordiate System

   xs = [1:cols]-xc;
   ys = [1:rows]-yc;
   [x y] = meshgrid (xs,ys);

   cmask = mask;
   cmask = 1;

   r = abs(x + j*y) .* cmask;
   a = angle(x + j*y) .* cmask;

   rmin = 0;
   rmax = max(r(:).*mask(:));
   rho   = cmask .* r ./ rmax;
   theta = cmask .* a; 

   if strcmp (upper(method),'CIRCLE')
     return;
   end

   if strcmp (upper(method),'AXIS')
      dx = max(abs(x(:).*mask(:)));
      dy = max(abs(y(:).*mask(:)));
      rho   = cmask .* abs(x./dx + j*y./dy);
      theta = cmask .* angle(x./dx + j*y./dy);
      return;
   end

   if strcmp (upper(method),'GENERAL')

       rmax = 0*r;
       rmin = 0*r;

       % Determine The rough boundaries of the pupil

       probe = [-pi:pi/rows*4:pi-pi/rows*4];
       pmin = []; 
       pmax = []; 
       mm = 0;
       for n=1:length(probe)
          amask = abs((a+probe(n)).*r)<1;
          rlist = find (amask.*mask);
          pmin(n) = min(r(rlist));
          pmax(n) = max(r(rlist));
          mm = mm + (amask.*mask);
       end

       probe = [(probe-2*pi) probe (probe+2*pi)];
       pmax  = [pmax pmax pmax];
       pmin  = [pmin pmin pmin];

       list = find(mask);
       for n=1:length(list)
          ai = a(list(n));
          ri = r(list(n));

          rmax(list(n)) = interp1(probe,pmax,ai);
          rmin(list(n)) = interp1(probe,pmin,ai);
       end

       rho   = cmask .* (r-rmin) ./ (rmax-rmin);
       rho(find(isnan(rho)))=0;
       %rho = rho.* (rho<=1) + (rho>1);
       theta = cmask .* a; 

       return;
    end

    fprintf(['zernike_coordinates: Method = %s not recognized. ' ...
             'Using cicular basis.\n'], method);
    
