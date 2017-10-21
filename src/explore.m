function files = explore(path, pattern)
%EXPLORE   searches files matching a given pattern in the given path including subdirectories
%
% arguments:
%   path: the path to be searched in
%   pattern: the pattern of the files to match
% returns:
%   files: matching files

% all items in the path
items = dir(path)';
% all files in the path
files = dir([path '/' pattern])';

% save path of the files
for i = 1:size(files, 2)
    files(i).path = path;
end

% collect subdirectories
% all directories but '.' and '..'
children = arrayfun(@(it) ...
   it.isdir & ~strcmp(it.name, '.') & ~strcmp(it.name, '..'), ...
   items);

% for each subdirectory
for child = items(children)
    % get files from the current child
    successors = explore([path '/' child.name], pattern);
    
    % append files to the collected ones
    if size(files, 2) == 0
        files = successors;
    elseif size(successors, 2) > 0
        files = horzcat(files, successors);
    end
end
