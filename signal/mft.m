function F = mft(f,m,npix)
% MFT Two-dimensional discrete Fourier transform via DFT matrix.
%
% MFT computes the two-dimansional discrete Fourier transform (DFT) of the 
% matrix f. The DFT is computed using the matrix Fourier transform algorithm 
% described in [1].
%
% Args
% ----
% f : m x n array
%   Input signal
%
% m : float of 1x2 array (optional)
%   Scale factor for setting up output plane sampling. See [1] for additional 
%   details.For imaging simulations, m = detector field of view / angular 
%   resolution of optical system. When simulating a nonsquare detector, m 
%   should be passed in as an array as [m_horiz m_vert]. 
%
% npix : int or 1 x 2 array (optional)
%   Size of output array F. If npix is an array, size(F) = [npix(1) npix(2)].
%   If npix is a scalar, size(F) = [npix npix].
%
% Returns
% -------
% F : npix x npix array
%   Two-dimensional Fourier transform of f
%
% References
% ----------
% [1] Soummer, Pueyo, Sivaramakrishnan, & Vanderbei. "Fast computation of 
%     Lyot-style coronagraph propagation".

% akee - NASA Jet Propulsion Laboratory
% June 2016



% x and y are coordinates in the input plane f
% u and v are coordinates in the output plane F

narginchk(1,4)

[fy,fx] = size(f);

if nargin == 1
    m = [fy fx];
    npix = [fy fx];
    tilt = [0 0];
elseif nargin == 2
    npix = [fy fx];
    tilt = [0 0];
elseif nargin == 3
    tilt = [0 0];
end
    

if length(npix) == 1
    Fv = npix;
    Fu = npix;
elseif length(npix) == 2
    Fv = npix(1);
    Fu = npix(2);
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

tilty = tilt(1);
tiltx = tilt(2);

dx = 1/fx;
dy = 1/fy;
du = mx/Fu;
dv = my/Fv;

xs = ((1:fx) - fx/2 - tiltx - 1)' * dx;
ys = ((1:fy) - fy/2 - tilty - 1)' * dy;
us = ((1:Fu) - Fu/2 - tiltx - 1)' * du;
vs = ((1:Fv) - Fv/2 - tilty - 1)' * dv;

E1 = exp(-2*pi*1j*vs*ys');
E2 = exp(-2*pi*1j*xs*us');
F = E1*f*E2;

norm_coeff = sqrt(my*mx/(fx * fy * Fu * Fv));

F = norm_coeff .* F ;