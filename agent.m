function ret=agent(im, agents, start_p1, start_p2, epsilon, lambda, n, maxN, disp)
%    getXm = memoize1(@getX);
    P = length(agents);

    if (disp)
        imagesc(im); colormap(gray); hold on
    end

    p1 = start_p1*ones(P,1);
    p2 = start_p2*ones(P,1);
    cost = zeros(P,1);
    f = zeros(P,1);

    alpha = zeros(n,P);
    for k=1:P
        alpha(:,k) = agents(k).alpha;
    end

    for i=1:maxN
        tp1 = p1;
        tp2 = p2;

        p2p1 = sub2ind(size(im), p2, min(p1,size(im,2)));
        a = im(p2p1);

        % FIXME: don't bother this calculation if f=1
%        X = zeros(n,P);
%        for k=find(f == 0)'
        X = getX(im, p1.*(1-f), p2.*(1-f), n, epsilon);
%        end
        theta_hat = h_ax(alpha, X);
        p1 = round(p1 + epsilon*cos(theta_hat));
        p2 = round(p2 + epsilon*sin(theta_hat));

        p1 = max(1, p1);
        p2 = max(1, p2);
    %    p1 = min(p1, size(im,2));
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
            plot([tp1 min(p1,size(im,2))], [tp2 p2], 'red-X', 'LineWidth', 3);
        end

        f = p1 > size(im,2);
    end
    % Add a penalty to agents which have still not finished
    cost = cost + (1-f).*3000;

    ret = agents;
    for k=1:P
        ret(k).cost = cost(k); ret(k).f = f(k);
    end
end
