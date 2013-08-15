% h_alpha(x) = 2*pi(g(x)-0.5) where g(x) is sigmoid
function h=h_ax(alpha,x)
    h = diag(2*pi*((1./(1+exp(alpha'*x)))-0.5));
end
