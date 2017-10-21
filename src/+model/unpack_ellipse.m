function [z, a, b, rho] = unpack_ellipse(ellipse)
%UNPACK_ELLIPSE   unpacks the parameters of the given ellipse(s)
%
% arguments:
%   model:  the ellipse model
% returns:
%   z:   the center of the ellipse
%   a:   the major axis
%   b:   the minor axis
%   rho: the orientation

z   = [ellipse.z];
a   = [ellipse.a];
b   = [ellipse.b];
rho = [ellipse.rho];
