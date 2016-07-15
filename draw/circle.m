function [x,y] = circle(r,xc,yc)

if nargin == 1
    xc = 0;
    yc = 0;
end

theta = 0:0.1:2*pi;

x = xc + r*cos(theta);
y = yc + r*cos(theta);

% close the circle
x(end+1) = x(1);
y(end+1) = y(1);
