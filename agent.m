function ret=agent(im, agents, start_p1, start_p2, epsilon, lambda, n, maxN, disp)
    getXm = memoize1(@getX);
    for k=1:length(agents)
        agents(k).cost = 0; agents(k).f = 0;
        if (disp)
            imagesc(im); colormap(gray); hold on
        end
        p1 = start_p1;
        p2 = start_p2;
        for i=1:maxN
            tp1 = p1;
            tp2 = p2;

            a = im(p2,p1);
            X = getXm(im, p1, p2, n, epsilon);
            theta_hat = h_ax(agents(k).alpha, X);
            p1 = round(p1 + epsilon*cos(theta_hat));
            p2 = round(p2 + epsilon*sin(theta_hat));

            p1 = max(1, p1);
            p2 = max(1, p2);
        %    p1 = min(p1, size(im,2));
            p2 = min(p2, size(im,1));

            b = im(p2,min(p1,size(im,2)));

            cn = (b-a);
            if (cn < 0)
                cn = -.5*cn;
            end
            cn = cn*cn;

            agents(k).cost = agents(k).cost + cn;     % Add slope cost
            agents(k).cost = agents(k).cost + lambda; % Add step cost

            if (disp)
                plot([tp1 min(p1,size(im,2))], [tp2 p2], 'red-X', 'LineWidth', 3);
            end

            if (p1 > size(im,2))
                agents(k).f = 1;
                break;
            end
        end
        if (agents(k).f == 0)
            % we have not finished. Add a penalty.
            agents(k).cost = agents(k).cost + 3000;
        end
    end

    ret = agents;
end
