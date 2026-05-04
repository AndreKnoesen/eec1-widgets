rng(42);
for fname = ["walk", "run", "jump"]
    n = 500 + randi(200);
    t = (0:n-1)' / 100;
    if strcmp(fname, "walk"),  scale = 1.5;
    elseif strcmp(fname, "run"), scale = 4.0;
    else, scale = 8.0; end
    Ax = randn(n,1)*scale; Ay = randn(n,1)*scale;
    Az = 9.81 + randn(n,1)*scale*0.5;
    data = [Ax, Ay, Az, t];
    save(fname + ".mat", 'data');
end
% Short file for Task 4 demo
n = 30; t = (0:n-1)'/100;
data = [randn(n,1), randn(n,1), 9.81*ones(n,1), t];
save('short.mat', 'data');