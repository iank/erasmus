function ret=agent(im, agents, start_p1, start_p2, epsilon, lambda, n, maxN, disp)
    P = length(agents);

    if (disp)
        imagesc(im); colormap(gray); hold on
    end

    p1 = start_p1*ones(P,1);
    p2 = start_p2*ones(P,1);
    cost = zeros(P,1);
    f = zeros(P,1);

    alpha = zeros(n+1,P);
    for k=1:P
        alpha(:,k) = agents(k).alpha;
    end

    % Move this outside of getX b/c previously we spent 44s self time
    % inside linspace (out of 217s spent in getX total, over 390145 calls)
    thetas = linspace(0,2*pi,n+1);
    thetas = thetas(2:end);

    for i=1:maxN
        tp1 = p1;
        tp2 = p2;

        p2p1 = sub2ind(size(im), p2, min(p1,size(im,2)));
        a = im(p2p1);

        X = getX(im, p1.*(1-f), p2.*(1-f), thetas, epsilon);

        %%%% 
        to_goal = repmat([400 400], P, 1) - [tp1 tp2];
        angle_to_goal = atan2(to_goal(:,2), to_goal(:,1))';
        %%%%

        theta_hat = h_ax(alpha, [X;angle_to_goal]);


        p1 = round(p1 + epsilon*cos(theta_hat));
        p2 = round(p2 + epsilon*sin(theta_hat));

        p1 = max(1, p1);
        p1 = min(p1, size(im,1));
        p2 = max(1, p2);
        p2 = min(p2, size(im,1));

        p2p1 = sub2ind(size(im), p2, min(p1, size(im,2)));
        b = im(p2p1);

        cn = (b-a);
        if (cn < 0)
            cn = -.5*cn;
        end
        cn = cn.*cn;

        % Only update costs for agents which have not finished
        cost = cost + (1-f).*cn;     % Add slope cost
        cost = cost + (1-f).*lambda; % Add step cost

        if (disp & ~f)
            plot([tp1 min(p1,size(im,2))], [tp2 p2], 'red-', 'LineWidth', 2);
        end

%        f = p1 > size(im,2);
        f = (p1 == 400 & p2 == 400);
    end
    % Add a penalty to agents which have still not finished
    to_goal = (repmat([400 400], P, 1) - [p1 p2]);
    dist_to_goal = sqrt(to_goal(:,1).^2 + to_goal(:,2).^2);
    cost = cost + (1-f).*3000000.*dist_to_goal;

    ret = agents;
    for k=1:P
        ret(k).cost = cost(k); ret(k).f = f(k);
    end
end
