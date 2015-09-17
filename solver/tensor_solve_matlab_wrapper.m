function U=tensor_solve_matlab_wrapper(matlab_solver, A, F, varargin)
% TENSOR_SOLVE_MATLAB_WRAPPER Short description of tensor_solve_matlab_wrapper.
%   TENSOR_SOLVE_MATLAB_WRAPPER Long description of tensor_solve_matlab_wrapper.
%
% Options
%
% References
%
% Notes
%
% Example (<a href="matlab:run_example tensor_solve_matlab_wrapper">run</a>)
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

options=varargin2options( varargin );
[Minv,options]=get_option( options, 'Minv', [] );
[abstol,options]=get_option( options, 'abstol', 1e-6 );
[reltol,options]=get_option( options, 'reltol', 1e-6 );
[maxiter,options]=get_option( options, 'maxiter', 100 );
check_unsupported_options( options, mfilename );

tol = reltol;

sz = size(F);
operator_ops = A;
precond_ops = Minv;
b=F(:);
x=funcall(matlab_solver, @apply, b, tol, maxiter, @prec, [], [], {operator_ops, precond_ops});
U=reshape(x, sz);

function x=prec(x, ops)
Minv=ops{2};
x = operator_apply(Minv, x );

function x=apply(x, ops)
A=ops{1};
x = operator_apply(A, x );


