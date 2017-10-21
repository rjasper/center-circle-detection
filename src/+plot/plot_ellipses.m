function plot_ellipses(ellipses, varargin)
%PLOT_ELLIPSES plots multiple ellipses
% 
% arguments:
%   ellipses: the ellipses to be plotted

import model.*
import plot.*

% remember if the figure was currently hold on
washold = ishold;

% plots all ellipses

n = size(ellipses, 2);

for i = 1:n
    [z, a, b, rho] = unpack_ellipse(ellipses(i));
    
    plotellipse(z, a, b, rho, varargin{:});
    
    hold on;
end

% restore the old hold behaviour

if ~washold
    hold off;
end
