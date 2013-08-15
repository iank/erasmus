%im = imread('PerlinNoise2d.png', 'png');
im = imread('test.png', 'png');
im = double(im(:,:,1));

n = 4;
% rng(1237)  % successful agent
epsilon = 4;
lambda = 0.001;
maxN = 500;

%p1 = 17;
%p2 = 219;
p1 = 32; p2 = 68;

P = 200; % population size
gens = 100;

% Initial population
for i=1:P
    agents(i).alpha = trnd(2,n,1)*0.1;
end

mc = zeros(gens,1);
best = Inf;
for generation=1:gens
    %tic
    agents=agent(im, agents, p1, p2, epsilon, lambda, n, maxN, 0);
    cost = [agents.cost];
    f = [agents.f];
    best_idx = find(cost == min(cost),1);
    best_f = f(best_idx);
    best_cost = min(cost);
    f_rat = sum(f)/numel(f);
    mc(generation) = best_cost;

    if (best_cost < best)
        best = best_cost;
        bestAgent = agents(best_idx);

%        figure;
%        agent(im, bestAgent, p1, p2, epsilon, lambda, n, maxN, 1);
%        title({'Generation:', generation, 'Cost:', best_cost});
    end
    disp(sprintf('Generation %03d/%03d: %011.3f (finished: %d %2.3f)',...
        generation, gens, best_cost, best_f, f_rat));
    
    %toc

    %%%% New population
    % Keep best individual (Elitism)
    np(1) = agents(best_idx);

    % Create rest of population via crossover
    weights = 1 ./ ([agents.cost] ./ sum([agents.cost]));
    for j=2:(P-15)
        % Select parents
        idx = randweightedpick(weights, 2);
        parents = agents(idx);

        % 2-point Crossover
        pivots = sort(floor(rand(2,1)*n)+1);
        child = parents(1);
        child.alpha(pivots(1):pivots(2)) = parents(2).alpha(pivots(1):pivots(2));

        % Mutate
        mb = rand(size(child.alpha)) < 0.02;
        nb = 0.1*trnd(2,sum(mb),1);

        child.alpha(mb) = nb;
        np(j) = child;
    end

    % Entirely new agents
    for j=(P-14):P
        np(j).alpha = 0.1*trnd(2,n,1);
    end
    agents = np;
end

bestAgent = agents(best_idx);
agent(im, bestAgent, p1, p2, epsilon, lambda, n, maxN, 1);
