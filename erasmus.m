im = imread('PerlinNoise2d.png', 'png');
im = double(im(:,:,1));

n = 360;
alpha = randn(n,1)*0.1;
epsilon = 30;

p1 = 250;
p2 = 250;

imagesc(im);
colormap(gray);
hold on;

for i=1:200
    scatter(p1,p2,'redX');
    X = getX(im, p1, p2, n, epsilon);
    theta_hat = h_ax(alpha, X);
    p1 = round(p1 + epsilon*cos(theta_hat));
    p2 = round(p2 + epsilon*sin(theta_hat));

    pause(0.1);
end
