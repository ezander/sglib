function [rat,flag,iter]=simple_iteration_contractivity( K, Pinv, varargin )
% SIMPLE_ITERATION_CONTRACTIVITY Estimate norm for preconditioned simple iteration.
%   [RAT,FLAG]=SIMPLE_ITERATION_CONTRACTIVITY( K, PINV, OPTIONS ) computes the norm
%   associated with the simple iteration X=X-Pinv*(B-K*X), i.e. the norm of
%   I-P\K, which has to be smaller 1 for the iteration to converge (ok, its
%   really the spectral radius, but if we take the 2 norm and K and P are
%   symmetric, that's the same).
%
% Example (<a href="matlab:run_example simple_iteration_contractivity">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options(varargin);
[abstol,options]=get_option(options,'abstol',1e-4);
[maxiter,options]=get_option(options,'maxiter',100);
[verbosity,options]=get_option(options,'verbosity',0);
check_unsupported_options(options,mfilename);

MN=operator_size( K, 'domain', false, 'contract', true );
x0=rand(MN,1);

rat=0;
flag=1;
iter=0;
r=tensor_norm( x0 );
if r==0; return; end


for iter=1:maxiter
    x0=tensor_scale(x0,1/r);
    ttt=tic;
    tmp=operator_apply( K, x0 );
    tmp=operator_apply( Pinv, tmp );
    ttt=toc(ttt);
    x0=tensor_add( x0, tmp, -1 );
    
    r=tensor_norm( x0 );
    ratn=r;

    if verbosity>0
        fprintf( 'iter: %d, rho: %g delta: %g (time: %g)\n', iter, ratn, abs(ratn-rat), ttt );
    end
    if abs(ratn-rat)<abstol 
        rat=ratn;
        flag=0;
        break;
    end
    rat=ratn;
end
    
if nargout<2 && flag
    disp( 'simple_iteration_contractivity did not converge' );
end
