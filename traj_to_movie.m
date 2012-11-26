% make and play movie of motion given trajectory

function M = traj_to_movie(trajectory, frame_limits)
    num_frames = size(trajectory,3);
    h = figure('visible', 'off');
    foot_pts = extract_pt_from_tr(trajectory, 8);
    for i=1:num_frames
        clf;
        plot_linkage(trajectory(:,:,i), true, h);
        hold on;
        plot(foot_pts(1,:), foot_pts(2,:), '-', 'Color', [1 0 0]);
        hold off;
        if nargin >= 2
            axis(frame_limits);
        end
        axis square;
        M(i) = getframe();
    end
end