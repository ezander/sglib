function err=ctensor_error(TA, TE, varargin)
% CTENSOR_ERROR Compute the difference between two canonical tensors.
%   ERR=CTENSOR_ERROR(TA, TE, OPTIONS) computes the difference between the
%   tensors TA and TE, which is the error when TE signifies the exact
%   tensor and TA its approximation. With the option 'relerr' set to true
%   the relative error with respect to TE is computed. With the option 'G'
%   Gramian matrices for modified scalar products can be specified.
%
% Example (<a href="matlab:run_example ctensor_error">run</a>)
%   TE={rand(80,12), rand(70,12)};
%   TA=ctensor_truncate(TE, 'k_max', 10);
%   fprintf('Absolute error: %g\n', ctensor_error(TA, TE));
%   fprintf('Relative error: %g\n', ctensor_error(TA, TE, 'relerr', true));
%
% See also CTENSOR_TRUNCATE, CTENSOR_ADD, CTENSOR_MODES

%   Elmar Zander
%   Copyright 2010-2014, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options( varargin );
[G,options]=get_option(options,'G',[]);
[relerr,options]=get_option(options,'relerr',false);
check_unsupported_options(options);

DT=ctensor_add(TA,TE,-1);
err=ctensor_norm(DT,G);

if relerr
    norm_TE=ctensor_norm(TE,G);
    err=err/norm_TE;
end
