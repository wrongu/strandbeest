% optimize incrementally as opposed to genetically
%
% each of 11 rods can be shortened, unchanged, or lengthened, so that would
%   be 3^11 simulations per generation if all permutations are checked.
%
% Instead, this script will do only 1 rod at a time, update, then do the
%   next rod

G = 1000; % num generations
s = .05; % increment length
n = 128; % num steps in simulation

max_fits = zeros(G,1);
L_best = zeros(G,13);

savefile = input('enter save-file name: ', 's');
seedfile = input('enter seed-file name (starting point): ', 's');
if exist(seedfile, 'file')
    load(seedfile);
    linkage0 = L_best(end,:);
elseif exist([seedfile '.mat'], 'file')
    load(seedfile);
    linkage0 = L_best(end,:);
else
    linkage0 = [.5 0 .3 1.5 1.5 1.5 1.5 .5 1.5 1.25 .75 1 1.5];
end

L = linkage0;
[~, tr] = simulate_rotation(L,0,2*pi,n);
f = score_trajectory(tr,n);

grow_factor = eye(13)*s;
shrink_factor = -grow_factor;

t_per_g = 0.5;

for g=1:G
    t0 = tic;
    fprintf('generation %d\n', g);
    dL = zeros(1,13);
    parfor j=1:13
        % what happens if shrunk
        L_shrink = L + shrink_factor(j,:);
        [~, tr_s] = simulate_rotation(L_shrink,0,2*pi,n);
        f_s = score_trajectory(tr_s,n);
        % what happens if grow
        L_grow = L + grow_factor(j,:);
        [~, tr_g] = simulate_rotation(L_grow,0,2*pi,n);
        f_g = score_trajectory(tr_g,n);
        
        if f_s > f_g && f_s > f
            dL(j) = -s;
        elseif f_g > f_s && f_g > f
            dL(j) = s;
        end
    end
    
    L = L + dL;
    [~, tr] = simulate_rotation(L,0,2*pi,n);
    f = score_trajectory(tr,n);
    max_fits(g) = f;
    
    if all(dL==0)
        break;
    end
    
    te = toc(t0);
    
    if g > 20
        t_per_g = t_per_g + (te - t_per_g) / 20;
        n_remain = G - g;
        t_sec = n_remain * t_per_g;
        t_min = floor(t_sec / 60);
        t_sec = floor(t_sec - t_min * 60);
        fprintf('\t ETR: %d min', t_min);
        if t_sec > 0
            fprintf(' %d sec\n', t_sec);
        else
            fprintf('\n');
        end
    end
end

if(~strcmp(savefile,''))
    save(savefile, 'L_best', 'max_fits');
end