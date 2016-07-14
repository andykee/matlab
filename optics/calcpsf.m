function psf = calcpsf(amp,opd,pm_diameter,focal_length,npix,px_size,bandpass,oversample,tilt)
% CALCPSF Compute point spread function.
%
% CALCPSF computes the point spread function for the supplied OPD using the
% discrete matrix Fourier transform to evaluate the Fraunhofer diffraction 
% equation.
%
% Args
% ----
% amp : m x n array
%   Exit pupil amplitude (0 <= amp <= 1)
%
% opd : m x n array
%   Exit pupil OPD
%
% pm_diameter : float
%   Entrance pupil (primary mirror) diameter.
%
% focal_length : float
%   Telescope focal length to detector.
%
% npix : int or 1 x 2 array
%   Dimension of output psf. If npix is an array, size(psf) = [npix(1) npix(2)].
%   If npix is a scalar, size(psf) = [npix npix].
%
% px_size : float
%   Physical pixel size. Currently only square pixel support is provided. This 
%   may change in the future. 
%
% bandpass : k x 2 array
%   Spectral range and relative intensity transmission
%   (e.g.)       Wavelength           Intensity Xmission
%           ----------------------------------------------
%           bandpass (1,1) = 631e-9    bandpass(1,2) = 0.5
%           bandpass (2,1) = 633e-9    bandpass(2,2) = 1.0
%           bandpass (3,1) = 635e-9    bandpass(3,2) = 0.5
%
% oversample : int (optional)
%   Factor to increase pixel grid spacing. Oversample = 1 is the native
%   detector scale. Oversample = 2 redefines each pixel as a 2 x 2 array of
%   smaller pixels. 
%
% tilt : 1 x 2 array (optional)
%   Tilt coefficient used to include wavelength-dependent tilt in OPD prior
%   to PSF calculation. Primarily used to simulate fringes produced by a grism.
%
% Returns
% -------
% psf : npix array
%   Resulting point spread function


% Andy Kee
% June 2016

narginchk(7,9)

if nargin < 9
    tilt = [0 0];
end

if nargin < 8
    oversample = 1;
end

if length(npix) == 1
    npix = [npix npix];
elseif length(npix) > 2
    error('Invalid npix input.')
end

lambda = bandpass(:,1);
trans = bandpass(:,2);

detsize_r = npix(2)*px_size;
detsize_c = npix(1)*px_size;

hfov = 2*atan(detsize_c/(2*focal_length)); % horiz. detector field of view [rad]
vfov = 2*atan(detsize_r/(2*focal_length)); % vert. detector field of view [rad]
npix_psf = npix * oversample;

% tilt
tiltx = tilt(1) * (1-lambda./mean(lambda));
tilty = tilt(2) * (1-lambda./mean(lambda));

if tilt
    z2 = zernike_mode(~~amp,2);
    z3 = zernike_mode(~~amp,3);
else
    z2 = 0;
    z3 = 0;
end

psf = zeros(npix_psf);

for k = 1:length(lambda)
    r = lambda(k)/pm_diameter;  % telescope angular resolution [rad]
    mh = hfov/r;  % horiz. image plane (detector) size in relation to telescope angular resolution
    mv = vfov/r;  % vert. image plane (detector) size in relation to telescope angular resolution
    p = amp .* exp(1j*(2*pi/lambda(k)) * (opd + z2*tiltx(k) + z3*tilty(k)));
    P = mft(p,[mh mv],npix_psf);
    P = abs(P).^2;
    psf = psf + trans(k).*P;
end