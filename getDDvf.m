% Approximate (w/ epsilon) the directional derivative of f at (x,y)
% along a unit vector defined by theta.

function g=getDDvf(im, x, y, theta, epsilon)
    x2 = x + epsilon*cos(theta);
    y2 = y + epsilon*sin(theta);

    x = max(x,1);
    y = max(y,1);

    x2 = max(x2, 1);
    y2 = max(y2, 1);

    x2 = min(x2, size(im, 2));
    y2 = min(y2, size(im, 1));

    x2 = round(x2);
    y2 = round(y2);

    yx = sub2ind(size(im), y, x);
    p1 = im(yx);
    y2x2 = sub2ind(size(im), y2, x2);
    p2 = im(y2x2);
    g = (p2-p1)/epsilon;
end
