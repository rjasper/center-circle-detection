function segs = lsd_read(file)
%LSD_READ   reads a lsd file
% 
% arguments:
%   file: a string containing the path to the file to be read
% returns:
%   segs: a 7xN matrix containing the lsd line segment description

% Import the file
segs = importdata(file)';

if isempty(segs)
    return
end

% take weird matlab indexing into account :P
segs(1:4, :) = segs(1:4, :) + 1;
