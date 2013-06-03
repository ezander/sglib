function [version, msg]=sglib_version(varargin)
% SGLIB_VERSION Returns version information for sglib.
%   SGLIB_VERSION Returns version information for sglib either as array or
%   in string format (if the option 'as_string' is specified). 
%
%   The code of SGLIB_VERSION will also contain a log of the major
%   improvements of sglib (some kind of 'whats_new' file.
%
% Example (<a href="matlab:run_example sglib_version">run</a>)
%   fprintf('Version as array:  ');
%   disp(sglib_version())
%   fprintf('Version as string: ');
%   disp(sglib_version('as_string', true))
%
% See also

%   Elmar Zander
%   Copyright 2013, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options = varargin2options(varargin);
[as_string, options] = get_option(options, 'as_string', false);
check_unsupported_options(options, mfilename);

% Version information follows:
% If the change is minor add to the last digit, large changes the middle
% digit, and if the change is large and may be incompatible to previous
% versions increase the first digit.

% Version 0.9.1
% Up to here no version information existed

% Version 0.9.2
% * Added version information

% Version 0.9.3
% * Added option for computing squared gpc norm
% * Added option to make ordering of multiindices compatible with UQToolkit
% * Incompatible change to 'multiindex' interface when used with more than
%   two arguments (removed optional 'combine' parameter)
msg = 'Attention: incompatible change in ''multiindex'' when called with more than two parameters (see help).';

% Version 0.9.4
% * Extended SQRSPACE to cope with negative values and different exponents.
% * Added Matern and rational quadratic covariance function models

% Version 0.9.5
% * Added gpc_partial_eval for partial evaluation of GPCs
% * Added gpc_integrate for integration over GPC spaces
% * Added gpc_basis_eval for quick evaluation of the GPC basis functions
% * Added monomial evaluation to gpc_evaluate
version = [0, 9, 5];
%msg = '';

% Version 0.9.6 (upcoming)
% * Cleanup of linalg


% If Version information is requested as string, convert the arrary
% to string inserting some dots between the numbers.
if as_string
    version = sprintf('%d.', version);
    version = version(1:end-1);
end
