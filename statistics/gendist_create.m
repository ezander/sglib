function dist=gendist_create(distname, params, varargin)
% GENDIST_CREATE Create a structure that describes a statistical distribution.
%   DIST=GENDIST_CREATE(DISTNAME, PARAMS, VARARGIN) creates a structure (in
%   fact, a cell array currently) that describes a statistical distribution
%   for use with the GENDIST_* functions. The currently possible values for
%   DISTNAME are: NORMAL, LOGNORMAL, BETA, UNIFORM, EXPONENTIAL. The PARAMS
%   field contains the parameters for the chosen distribution as a cell
%   array. 
%
%   The ArcSine and Wigner Semicircle can now also be generated. The call
%   to GENDIST_CREATE will return a scaled and shifted Beta distribution
%   with special values for the parameters in these cases.
%
% Options
%   'shift': 0
%      Shift the distribution SHIFT units to the right.
%   'scale': 1
%      Scale the whole distribution by the factor SCALE. Note that scaling
%      is done around the mean of the distribution and thus the mean is not
%      affected by scaling.
%   'check': {true}, false
%      If set to true, which is the default, GENDIST_CREATE will check that
%      functions with the name DISTNAME+"_pdf", "_cdf" and "_moments" and
%      "_invcdf" are on the path, and this distribution can be used as a
%      valid distribution.
%
% Example (<a href="matlab:run_example gendist_create">run</a>)
%   dist = gendist_create('normal', {2, 3}, 'shift', 4, 'scale', 5);
%   [mu, var] = gendist_moments(dist);
%   fprintf( 'moments:  mu=%g, var=%g\n', mu, var);
%   fprintf( 'expected: mu=%g, var=%g\n', (2+4), (3*5)^2);
%
% See also GENDIST_PDF, GENDIST_CDF, GENDIST_INVCDF, GENDIST_MOMENTS

%   Elmar Zander
%   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options(varargin);
[shift,options]=get_option(options,'shift',0);
[scale,options]=get_option(options,'scale',1);
[check,options]=get_option(options,'check',true);
check_unsupported_options(options,mfilename);

if nargin==1
    params={};
end

% Some special treatment for distributions that don't have their "own"
% functions, but are special cases of other distributions
switch(distname)
    case 'arcsine'
        % Arcsine distribution, which is the same as the Beta(1/2,1/2)
        % distribution.
        distname = 'beta';
        params = {1/2, 1/2};
    case 'semicircle'
        % Wigner semicircle distribution, which is the same as the
        % Beta(3/2,3/2) distribution shifted from [0,1] to [-1,1].
        distname = 'beta';
        params = {3/2, 3/2};
        shift = shift - 1/2;
        scale = scale * 2;
    otherwise
        % do nothing
end

% Test whether the relevant functions are there
if check
    exts = {'pdf', 'cdf', 'moments', 'invcdf'};
    for ext=exts
        funcname = [distname, '_', ext{1}];
        if ~exist(funcname)
            error('sglib:gendist', 'Cannot create distribution %s. Function "%s" needed for distribution "%s" does not exist. Maybe you misspelled the name?', ...
                distname, funcname, distname );
        end
    end
end

% Generate the structure (rather: cell array) using the getargs function
warn_state = warning('off', 'sglib:statistics:gendist');
dist=gendist_get_args(distname, {params, shift, scale});
warning(warn_state);

