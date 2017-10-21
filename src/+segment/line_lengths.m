function lengths = line_lengths(segs)
%LINE_LENGTHS   calculates the lengths of the given line segments
%
% arguments:
%   segs: the line segments
% returns:
%   lengths: the lengths of the line segments
%% convenience variables

x1 = segs(1, :);
y1 = segs(2, :);
x2 = segs(3, :);
y2 = segs(4, :);

%% processing

lengths = sqrt( (x1-x2).^2 + (y1-y2).^2 );
