% Get gradient for n evenly-spaced radial directions around [x,y]
function X = getX(im, x, y, thetas, epsilon)
    n = numel(thetas);
    P = size(x,1);

    X = zeros(n,P);
    for i=1:length(thetas)
        theta = thetas(i);
        X(i,:) = getDDvf(im, x, y, theta, epsilon);
    end
end
