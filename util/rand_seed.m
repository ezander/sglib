function rand_seed(seed, varargin)
% RAND_SEED Short description of rand_seed.
%   RAND_SEED Long description of rand_seed.
%
% Options
%
% References
%
% Notes
%
% Example (<a href="matlab:run_example rand_seed">run</a>)
%
% See also

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

options=varargin2options(varargin, mfilename);
[skip_rand]=get_option(options, 'skip_rand', false);
[skip_randn]=get_option(options, 'skip_randn', false);
check_unsupported_options(options);

if ~skip_rand
    rand('seed', seed); %#ok<RAND>
end
if ~skip_randn
    randn('seed', seed); %#ok<RAND>
end
