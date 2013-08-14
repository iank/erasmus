function cost=agent(im, alpha, p1, p2, epsilon, lambda, n, maxN)
    cost = 0;
    for i=1:maxN
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

        cost = cost + cn;

        if (p1 > size(im,2))
            cost = cost + lambda*i;
            break;
        end
    end
end
