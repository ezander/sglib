function err=tensor_error(TA, TE, varargin )
% TENSOR_ERROR Computes the difference/error between to tensors.
%   ERR=CTENSOR_ERROR(TA, TE, OPTIONS) computes the difference between the
%   tensors TA and TE, which is the error when TE represents the exact
%   tensor and TA its approximation. With the option 'relerr' set to true
%   the relative error with respect to TE is computed. With the option 'G'
%   Gramian matrices for modified scalar products can be specified.
%
% Options
%   G: []
%      Specify Gramian matrices for error computation. If empty the normal
%      Euclidean scalar product is used.
%   relerr: {false}, true
%      When set to true the relative error, instead of the absolute error
%      is comuted.
%
% Example (<a href="matlab:run_example tensor_error">run</a>)
%   TE={rand(80,12), rand(70,12)};
%   TA=ctensor_truncate(TE, 'k_max', 10);
%   fprintf('Absolute error (CP):  %g\n', tensor_error(TA, TE));
%   Amat = tensor_to_array(TA);
%   Emat = tensor_to_array(T);
%   fprintf('Absolute error (mat): %g\n', tensor_error(Amat, Emat));
%
% See also TENSOR_TRUNCATE, TENSOR_ADD, TENSOR_NORM, TENSOR_SCALAR_PRODUCT

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

if ~is_ctensor(TE) && is_ctensor(TA)
    if isvector(TE)
        TA=ctensor_to_vector(TA);
    else
        TA=ctensor_to_array(TA);
    end
end

norm_TE=tensor_norm(TE,G);
DT=tensor_add(TA,TE,-1);
err=tensor_norm(DT,G);

if relerr
    err=err/norm_TE;
end
