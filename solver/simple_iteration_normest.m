function [rat,flag,iter]=simple_iteration_normest( K, Pinv, x0 )
% SIMPLE_ITERATION_NORMEST Estimate norm for preconditioned simple iteration.
%   [RAT,FLAG]=SIMPLE_ITERATION_NORMEST( K, PINV, X0 ) computes the norm
%   associated with the simple iteration X=X-Pinv*(B-K*X), i.e. the norm of
%   I-P\K, which has to be smaller 1 for the iteration to converge (ok, its
%   really the spectral radius, but if we take the 2 norm and K and P are
%   symmetric, that's the same).
%
% Example (<a href="matlab:run_example simple_iteration_normest">run</a>)
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


abstol=1e-4;
rat=-1;
maxiter=100;
r=gvector_norm( x0 );
flag=1;
for iter=1:maxiter
    x0=gvector_scale(x0,1/r);
    tmp=operator_apply( K, x0 );
    tmp=operator_apply( Pinv, tmp );
    x0=gvector_add( x0, tmp, -1 );
    
    r=gvector_norm( x0 );
    ratn=r;

    if abs(ratn-rat)<abstol 
        rat=ratn;
        flag=0;
        break;
    end
    rat=ratn;
end
    
