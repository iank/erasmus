function [cost, f]=agent(im, alpha, p1, p2, epsilon, lambda, n, maxN, disp)
    cost = 0;
    if (disp)
        imagesc(im); colormap(gray); hold on
    end
    for i=1:maxN
        tp1 = p1;
        tp2 = p2;

        a = im(p2,p1);
        X = getX(im, p1, p2, n, epsilon);
        theta_hat = h_ax(alpha, X);
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

        cost = cost + cn;     % Add slope cost
        cost = cost + lambda; % Add step cost

        if (disp)
            plot([tp1 min(p1,size(im,2))], [tp2 p2], 'red-X', 'LineWidth', 3);
        end

        if (p1 > size(im,2))
            f = 1;
%            disp(sprintf('Finished!   %6.3f (%d)', cost, i));
            return;
        end
    end
    % If we made it here, we have not finished. Add a penalty.
    cost = cost + 3000;
    f = 0;
%    disp(sprintf('Unfinished! %6.3f (%d)', cost, i));
end
