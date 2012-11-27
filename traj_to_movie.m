% make and play movie of motion given trajectory

function M = traj_to_movie(trajectory, frame_limits)
    num_frames = size(trajectory,3);
    h = figure('visible', 'off');
    foot_pts = extract_pt_from_tr(trajectory, 8);
    if nargin < 2
        xmin = min(min(trajectory(:,1,:)));
        xmax = max(max(trajectory(:,1,:)));
        ymin = min(min(trajectory(:,2,:)));
        ymax = max(max(trajectory(:,2,:)));
        if (xmax-xmin) > (ymax-ymin)
            ymax = ymin + (xmax-xmin);
        else
            xmax = xmin + (ymax-ymin);
        end
        frame_limits = [floor(xmin) ceil(xmax) floor(ymin) ceil(ymax)];
    end
    for i=1:num_frames
        clf;
        plot_linkage(trajectory(:,:,i), true, h);
        hold on;
        plot(foot_pts(1,:), foot_pts(2,:), '-', 'Color', [1 0 0]);
        hold off;
    	axis(frame_limits);
        axis square;
        M(i) = getframe();
    end
end