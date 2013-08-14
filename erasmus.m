im = imread('PerlinNoise2d.png', 'png');
im = double(im(:,:,1));

n = 60;
% rng(1237)  % successful agent
epsilon = 5;
lambda = 3;
maxN = 200;

p1 = 250;
p2 = 250;

P = 200; % population size
gens = 400;

% Initial population
agents = zeros(n, P);
for i=1:P
    agents(:,i) = randn(n,1)*0.1;
end

cost = zeros(1,P);
for generation=1:gens
    tic
    for i=1:P
        cost(i)=agent(im, agents(:,i), p1, p2, epsilon, lambda, n, maxN);
    end
    disp(sprintf('Generation %d/%d: %6.3f', generation, gens, min(cost)));
    toc

    % New population
    np = zeros(n,P);

    % Keep best individual (Elitism)
    np(:,1) = agents(:,find(cost == min(cost),1));

    % Create rest of population via crossover
    weights = 1 ./ (cost ./ sum(cost));
    for j=2:P
        % Select parents
        idx = randweightedpick(weights, 2);
        parents = agents(:,idx);

        % 2-point Crossover
        pivots = sort(floor(rand(2,1)*n)+1);
        child = parents(:,1);
        child(pivots(1):pivots(2)) = parents(pivots(1):pivots(2),2);

        % Mutate
        mb = rand(size(child)) < 0.01;
        nb = 0.1*randn(sum(mb),1);

        child(mb) = nb;
        np(:,j) = child;
    end
    agents = np;
end
