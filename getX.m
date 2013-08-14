% Get gradient for n evenly-spaced radial directions around [x,y]
function X = getX(im, x, y, n, epsilon)
    thetas = linspace(0,2*pi,n+1);
    thetas = thetas(2:end);

    X = zeros(n,1);
    for i=1:length(thetas)
        theta = thetas(i);
        X(i) = getDDvf(im, x, y, theta, epsilon);
    end
end
