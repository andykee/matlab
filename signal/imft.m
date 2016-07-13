function f = imft(F,m,npix)
% IMFT Inverse two-dimensional discrete Fourier transform via DFT matrix.
%
% IMFT computes the inverse two-dimansional discrete Fourier transform (DFT) of 
% the matrix F. 
%
% Args
% ----
% F : m x n array
%   Input signal
%
% m : float of 1x2 array (optional)
%   Scale factor for setting up output plane sampling. See [1] for additional 
%   details.For imaging simulations, m = detector field of view / angular 
%   resolution of optical system. When simulating a nonsquare detector, m 
%   should be passed in as an array as [m_horiz m_vert]. 
%
% npix : int or 1 x 2 array (optional)
%   Size of output array f. If npix is an array, size(f) = [npix(1) npix(2)].
%   If npix is a scalar, size(f) = [npix npix].
%
% Returns
% -------
% f : npix x npix array
%   Inverse two-dimensional Fourier transform of F
%
% References
% ----------
% [1] Soummer, Pueyo, Sivaramakrishnan, & Vanderbei. "Fast computation of 
%     Lyot-style coronagraph propagation".

% akee - NASA Jet Propulsion Laboratory
% June 2016

% u and v are coordinates in the input plane F
% x and y are coordinates in the output plane f


narginchk(1,3)

[Fv,Fu] = size(F);

if nargin == 1
    m = [Fv Fu];
    npix = [Fv Fu];
elseif nargin == 2
    npix = [Fv Fu];
end

if length(npix) == 1
    fy = npix;
    fx = npix;
elseif length(npix) == 2
    fy = npix(1);
    fx = npix(2);
else
    error('Invalid npix input.')
end

if length(m) == 1
    my = m;
    mx = m;
elseif length(m) == 2
    my = m(1);
    mx = m(2);
else
    error('Invalid m input.')
end


du = 1/Fu;
dv = 1/Fv;
dx = mx/fx;
dy = my/fy;

xs = ((1:fx) - fx/2 - 1)' * dx;
ys = ((1:fy) - fy/2 - 1)' * dy;
us = ((1:Fu) - Fu/2 - 1)' * du;
vs = ((1:Fv) - Fv/2 - 1)' * dv;

E1 = exp(2*pi*1j*vs*ys');
E2 = exp(2*pi*1j*xs*us');
f = E1*F*E2;

norm_coeff = sqrt(my*mx/(fx * fy * Fu * Fv));

f = norm_coeff .* f ;