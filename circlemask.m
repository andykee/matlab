function mask = circlemask(r)

if nargin > 1
    help circlemask
end

r = round(r);
m = 2*r+2;
n = m;

[M,N] = meshgrid(1:m,1:n);
mask = sqrt((M - m/2).^2 + (N - n/2).^2) < r;
mask = mask(1:m-1,1:n-1);
