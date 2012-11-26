% test each function

%% TEST INIT
% [1,2] - y coordinate
% 3 - r = (x,p)
% 4 - (p,a)
% 5 - (p,b)
% 6 - (a,y)
% 7 - (a,c)
% 8 - (y,c)
% 9 - (y,b)
% 10 - (c,d)
% 11 - (b,d)
% 12 - (b,e)
% 13 - (d,e)

% a = 38, b = 41.5, c = 39.3, d = 40.1, e = 55.8, f = 39.4, g = 36.7, h = 65.7, i = 49, j = 50, k = 61.9, l=7.8, m=15

linkage = [.5, ... 1
           0, ... 2
           .3, ... 3
           1.5, ... 4
           1.5, ... 5
           1.5, ... 6
           1.5, ... 7
           .5, ... 8
           1.5, ... 9
           1.25, ... 10
           .75, ... 11
           1, ... 12
           1.5]; % 13
start_a = 0;
pts = init_pts(linkage, start_a);
plot_linkage(pts, true);
fprintf('valid = %d\n', verify_linkage(linkage,pts));

%% TEST SIMULATION

% use linkage from above
t0 = tic;
[v, tr] = simulate_rotation(linkage);
te = toc(t0);
fprintf('finished simulation in %g seconds\n', te);
m = traj_to_movie(tr, [-2.5 2.5 -3 2]);
close all;
movie(m, 2, 15);