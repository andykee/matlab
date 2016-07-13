function mat = v2m(vec,indx)
% V2M Convert vectorized matrix data bac to matrix form.
%
%   Parameters
%   ----------
%   vec : 1xN array
%       explanation of mat
%
%   indx : index structure
%       expl of indx
%
%   Returns
%   -------
%   mat : N x N array
%       descr
%
%   See Also
%   --------
%   M2V

m=indx.size(1);
n=indx.size(2);
mat = full(sparse(indx.i,indx.j,vec,m,n));
