function res = bindown(img,factor)
% BINDOWN Rebins an image while preserving radiometry.
%
% Parameters
% ----------
% img : m x n matrix
%
% factor: int
%
%
% Returns
% -------
% res : 
%

% Andy Kee, Jet Propulsion Lab
% Feb 2016


[r,c] = size(img);
res = sum(reshape(img,factor,[]),1);
res = reshape(res,r/factor,[]).';

res = sum(reshape(res,factor,[]),1);
res = reshape(res,c/factor,[]).';