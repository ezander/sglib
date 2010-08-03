function [Minv,M,info]=stochastic_precond_mean_based( A, varargin)
% STOCHASTIC_PRECOND_MEAN_BASED Create the mean based preconditioner from a stochastic operator.
%   MINV=STOCHASTIC_PRECOND_MEAN_BASED( A, USE_LU ) creates the mean based
%   preconditioner MINV from the stochastic operator A in that MINV
%   approximates the inverse of A, or rather
%      OPERATOR_APPLY(MINV,OPERATOR_APPLY(A{1,:},X)==X 
%   for any vector or tensor X. If USE_LU the LU decompositions of the
%   matrices are precomputed and result in faster solve times later on.
%   Otherwise application of MINV result in solving with A{1,:} (of course
%   no inversion of the matrices is done here!). 
%
% Example (<a href="matlab:run_example stochastic_precond_mean_based">run</a>)
%   
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Comuting
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options(varargin);
[decomp_type,options]=get_option(options,'decomp_type','lu');
[decomp_options,options]=get_option(options,'decomp_type',{});
check_unsupported_options(options,mfilename);

R=tensor_operator_order( A );
Minv=cell( 1, R );
M=cell( 1, R );
info=cell( 1, R );
for i=1:R
    if ~isnumeric( A{1,i} )
        error( 'sglib:preconditioner', 'Elements of stochastic operator must be matrices for this function' );
    end
    [Minv{i},M{i},info{i}]=operator_from_matrix_solve( A{1,i}, decomp_type, decomp_options{:} );
end
