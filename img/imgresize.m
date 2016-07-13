function res = imgresize(img,target_size,method)
% IMGRESIZE Resize an image.
%
% Parameters
% ----------
% img : m x n array
%
% target_size : int or 2 x 1 array
%
% method : str
% 
% 
% Returns
% -------
% res : p x q array
% 

% Andy Kee, Jet Propulsion Lab
% May 2016

narginchk(2,3)

if nargin == 2
    method = 'nearest';
end

source_size = size(img);

if length(target_size) == 1
    target_size = [target_size target_size];
elseif length(target_size) == 2
    % do nothing
else
    error('Invalid target size')
end


[x,y] = meshgrid(linspace(1,source_size(2),target_size(2)), linspace(1,source_size(1),target_size(1)));
res = interp2(img,x,y,method);