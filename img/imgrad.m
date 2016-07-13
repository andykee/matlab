function [Gmag,Gdir] = imgrad(I,varargin)

if nargin == 1
    method='sobel';
elseif nargin == 2
    method = varargin{1};
else
    help imgrad
end

if strcmp(method,'sobel')
    kx = [-1 0 1; -2 0 2; -1 0 1];
    ky = kx';
elseif strcmp(method,'prewitt')
    kx = [-1 0 1; -1 0 1; -1 0 1];
    ky = kx';
else
    help imgrad
end

Gx = conv2(I,kx,'same');
Gy = conv2(I,ky,'same');

Gmag = sqrt(Gx.^2 + Gy.^2);
Gdir = atan2(Gy,Gx);
