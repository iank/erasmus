im = imread('PerlinNoise2d.png', 'png');
im = double(im(:,:,1));

n = 4;
% rng(1237)  % successful agent
epsilon = 10;
lambda = 0.001;
maxN = 300;

p1 = 30;
p2 = 250;

P = 200; % population size
gens = 50;

% Initial population
agents = zeros(n, P);
for i=1:P
    agents(:,i) = trnd(2,n,1)*0.1;
end

getXm = memoize1(@getX);

cost = zeros(1,P);
mc = zeros(gens,1);
for generation=1:gens
    tic
    for i=1:P
        [cost(i) f(i)]=agent(im, agents(:,i), p1, p2, epsilon, lambda, n, maxN, 0, getXm);
    end
    disp(sprintf('Generation %d/%d: %6.3f (finished: %d %2.3f)', generation, gens, min(cost), f(find(cost == min(cost), 1)), sum(f)/numel(f)));
    mc(generation) = min(cost);
    toc

    % New population
    np = zeros(n,P);

    % Keep best individual (Elitism)
    np(:,1) = agents(:,find(cost == min(cost),1));

    % Create rest of population via crossover
    weights = 1 ./ (cost ./ sum(cost));
    for j=2:(P-15)
        % Select parents
        idx = randweightedpick(weights, 2);
        parents = agents(:,idx);

        % 2-point Crossover
        pivots = sort(floor(rand(2,1)*n)+1);
        child = parents(:,1);
        child(pivots(1):pivots(2)) = parents(pivots(1):pivots(2),2);

        % Mutate
        mb = rand(size(child)) < 0.02;
        nb = 0.1*trnd(2,sum(mb),1);

        child(mb) = nb;
        np(:,j) = child;
    end

    % Entirely new agents
    for j=(P-14):P
        np(:,j) = 0.1*trnd(2,n,1);
    end
    agents = np;
end

idx = find(cost == min(cost), 1);
bestAgent = agents(:,idx);
agent(im, bestAgent, p1, p2, epsilon, lambda, n, maxN, 1, getXm);
