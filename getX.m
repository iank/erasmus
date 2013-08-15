% Get gradient for n evenly-spaced radial directions around [x,y]
function X = getX(im, x, y, n, epsilon)
%    thetas = linspace(0,2*pi,n+1);
%    thetas = thetas(2:end);

    % HACK, but linspace took 44s self time over 390145 calls previously
    thetas = [1.5708    3.1416    4.7124    6.2832];

    P = size(x,1);

    X = zeros(n,P);
    for i=1:length(thetas)
        theta = thetas(i);
        X(i,:) = getDDvf(im, x, y, theta, epsilon);
    end
end
