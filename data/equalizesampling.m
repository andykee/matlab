function [newlist1,newlist2] = equalizesampling(list1,list2,sampling,method)

if nargin==2
   sampling   = [];
   method = 'linear';
elseif nargin==3
   method = 'linear';
elseif nargin==4
   % no default
else
   error('Invalid number of input arguments')
end

minval = max([min(list1(:,1)), min(list2(:,1))]);
maxval = min([max(list1(:,1)), max(list2(:,1))]);

if isempty(sampling)
   rate = min([diff(list1(:,1)); diff(list2(:,1))]);
   sampvec = (minval:rate:maxval)';
else
   if length(sampling)==1
      sampvec = (minval:sampling:maxval)';
   else
      sampvec = sampling;
   end
end

newlist1 = [sampvec interp1(list1(:,1), list1(:,2), sampvec, method)];
newlist2 = [sampvec interp1(list2(:,1), list2(:,2), sampvec, meplotthod)];