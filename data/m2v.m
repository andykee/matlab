function [vec,jndx] = m2v(mat,indx)
% M2V Vectorize matrix data.
%
%   Parameters
%   ----------
%   mat : NxN array
%       explanation of mat
%
%   indx : index structure, optional
%       expl of indx
%
%   Returns
%   -------
%   vec : N x 1 array
%       descr
%
%   jndx : index structure
%       descr
%
%   Examples
%   --------
%   To vectorize a matrix for the first time while creating a new index 
%   structure,
%
%   >> [vec,indx] = m2v(mat);
%
%   Subsequent vectorization operations on the same matrix (or different
%   matrices with the same index structure) are achieved by
%
%   >> [vec] = m2v(mat,indx)
%
%   See Also
%   --------
%   V2M

if nargin==1
    [i,j,vec] = find(mat);  % Vectorize mat
	jndx.i=i;
	jndx.j=j;
	jndx.size=size(mat);
elseif nargin==2
	jndx=indx;
	k=sub2ind(indx.size,indx.i,indx.j);
	vec=mat(k);
end