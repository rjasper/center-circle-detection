function pts = sample_points(segs, mode)
%SAMPLE_POINTS   samples points of the given line segments
%
% arguments:
%   segs: the line segments to be sampled
%   mode: the mode used for sampling
%         'interval' uses a predefined interval between sampling points
%                    the total points sampled per line segment depend on
%                    the length of the segment
%         'fix'      uses a predefined number of sampling points
% returns:
%   pts: the sampled points

%% constants

cfg = config;

% interval between to sample points
interval = cfg.SAMPLE_INTERVAL;

%% convenience variables

x1 = segs(1, :);
y1 = segs(2, :);
x2 = segs(3, :);
y2 = segs(4, :);

%% processing

switch mode
    case 'interval'
        n = size(segs, 2);
        
        delta_x = x2 - x1;
        delta_y = y2 - y1;

        % calculate the number of points to be sampled
        l = line_lengths(segs);
        n_pts = ceil(l / interval);
        
        % the coverage of the sample points, will be used to center them
        coverage = (n_pts - 1)*interval ./ l;

        % cell array containing the sample points per segment
        pp = cell(1, n);

        % for each segment
        for i = 1:n
            % center the sample points
            margin = (1 - coverage(i)) / 2;
            a = linspace(margin, 1-margin, n_pts(i));

            pp{i} = [ ...
                x1(i) + a*delta_x(i); ...
                y1(i) + a*delta_y(i)  ...
            ];
        end

        pts = merge(pp);
    case 'fix'
        % samples three points: at the ends and in the middle
        
        pts_m = [(x1+x2)/2; (y1+y2)/2]; % middle of lines
        pts_e = [x1 x2; y1 y2];         % end points

        pts   = [pts_m pts_e];
    otherwise
        error('mode must either be ''interval'' or ''fix''');
end
