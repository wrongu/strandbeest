% evolve 'em

N = 100; % num link. per generation
G = 100; % num generations
r = .02; % chance of mutation
C = 15; % number to select each generation for reproduction
n = 128;

L = zeros(N, 13);
fitness = zeros(N,1);

max_fits = zeros(G,1);
min_fits = zeros(G,1);
p_dead = ones(G,1); % percent died

linkage0 = [.5 0 .3 1.5 1.5 1.5 1.5 .5 1.5 1.25 .75 1 1.5];

for l=1:N
    L(l,:) = rand(1,13) + 0.5; % all positive, from 0.5 to 1.5
    L(l,2) = 0;
    L(l,:) = L(l,:) / L(l,3); % normalized to a radius of 1
end

L(end,:) = linkage0;

f = figure();

for g=1:G
    fprintf('generation %d\n', g);
    % simulate and score
%     m = 0;
%     mi = 0;
    parfor l=1:N
        [v, tr] = simulate_rotation(L(l,:), 0, 2*pi, n);
        fitness(l) = score_trajectory(tr, n);
%         if fitness(l) > m
%             m = fitness(l);
%             mi = l;
%         elseif fitness(l) == 0
%             p_dead(g) = p_dead(g)+1;
%         end
    end
    
    % sort by fitness
    [fitness, i] = sort(fitness);
    L = L(i,:);
    max_fits(g) = fitness(end);
    min_fits(g) = fitness(1);
    
    % plot best
    if mi > 0
        [v, tr] = simulate_rotation(L(end,:), 0, 2*pi, n);
        clf;
        plot_linkage(tr, true, f);
        hold on;
        ft = extract_pt_from_tr(tr, 8);
        plot(ft(1,:), ft(2,:), 'Color', [0.8 0 0]);
        b = extract_pt_from_tr(tr, 5);
        plot(b(1,:), b(2,:), 'Color', [0.1 0.7 0.7]);
        d = extract_pt_from_tr(tr, 7);
        plot(d(1,:), d(2,:), 'Color', [0.7 0.1 0.7]);
        hold off;
        drawnow;
    else
        fprintf('\tno survivors\n');
    end
    
    % reproduce with the C best versions
    pool = L(end-C+1:end,:);
    fpool = fitness(end-C+1:end);
    csums = cumsum(fpool);
    max_rand = csums(end);
    
    % create next generation
    parfor l=C+1:N
        % weighted select of 2 linkages (could be the same one)
        thresh1 = rand * max_rand;
        thresh2 = rand * max_rand;
        i1 = find(csums > thresh1, 1);
        i2 = find(csums > thresh2, 1);
        
        if isempty(i1)
            i1 = N;
        end
        if isempty(i2)
            i2 = N;
        end
        
        % weighted selection of them
        L1 = rand(1,13)*(fitness(i1) + fitness(i2)) < fitness(i1);
        L2 = ~L1;
        linkage = zeros(1,13);
        linkage(L1) = pool(i1,L1);
        linkage(L2) = pool(i2,L2);
        
        for j=1:length(linkage)
            if rand < r
                linkage(j) = linkage(j) + rand*.5 - .25;
            end
        end
        linkage = linkage / linkage(3); % normalize to radius of 1
        % rotate so point y is on x-axis:
        linkage(1) = norm(linkage(1:2));
        linkage(2) = 0;
        % reassign it
        L(l,:) = linkage;
    end
end

if(exists('savefile', 'var'))
    save(savefile);
end

%%
figure();
subplot(1,2,1);
plot(max_fits);
hold on;
plot(min_fits, 'Color', [0.8 0 0]);
hold off;
legend('max fit', 'min fit');
xlabel('generation');

subplot(1,2,2);
plot(p_dead);
xlabel('generation');
ylabel('percent dead');