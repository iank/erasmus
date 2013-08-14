im = imread('PerlinNoise2d.png', 'png');
im = double(im(:,:,1));

n = 360;
% rng(1237)  % successful agent
alpha = randn(n,1)*0.1;
epsilon = 20;
lambda = 3;
maxN = 200;

p1 = 250;
p2 = 250;

cost=agent(im, alpha, p1, p2, epsilon, lambda, n, maxN)
cost
