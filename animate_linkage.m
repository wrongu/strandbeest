function [] = animate_linkage(L)
    [v tr] = simulate_rotation(L);
    if v
        m = traj_to_movie(tr);
        movie(m, 50, 15);
    else
        disp('invalid dimensions');
    end
end