function C=covariance_matrix( pos, covar_func, varargin )
% COVARIANCE_MATRIX Calculate point covariance matrix.
%   C=COVARIANCE_MATRIX( POS, COVAR_FUNC, VARARGIN ) computes the
%   covariance matrix for all combinations of points given in POS using the
%   specified covariance function given in COVAR_FUNC. COVAR_FUNC has to
%   comply to the interface covar_func( x1, x2 ) (see also
%   PARAMETERIZED_FUNCTIONS)
%
% Options:
%   VECTORIZED (default: true) specifies whether the covariance functions
%   is vectorized with respect to the position arguments.
% 
% Example (<a href="matlab:run_example covariance_matrix">run</a>)
%   x=linspace(0,1,10)';
%   C=covariance_matrix( x, {@gaussian_covariance, {0.3, 2}} );
%
% See also GAUSSIAN_COVARIANCE, EXPONENTIAL_COVARIANCE

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options( varargin{:} );
[vectorized,options]=get_option( options, 'vectorized', true );
[max_dist,options]=get_option( options, 'max_dist', inf );
check_unsupported_options( options, mfilename );

n=size(pos,1);
if isinf(max_dist)
    C=zeros(n,n);
else
    C=sparse(n,n);
end

if ~vectorized
    % maybe this will be needed later for non-vectorized covariance
    % functions, but it's awfully slow
    for i=1:n
        C(i,i)=funcall( covar_func, pos(i,:), pos(i,:) );
        for j=(i+1):n
            C(i,j)=funcall( covar_func, pos(i,:), pos(j,:) );
            C(j,i)=C(i,j);
        end
    end
else
    % TODO: maybe this should be vectorized even further
    for i=1:n
        if isinf(max_dist)
            C(i:end,i)=funcall( covar_func, repmat(pos(i,:),n-i+1,1), ...
                pos(i:end,:) );
            C(i,i:end)=C(i:end,i)';
        else
            d=sum(abs(repmat(pos(i,:),n-i+1,1)-pos(i:end,:)),2);
            ind=i-1+find(d<max_dist);
            C(ind,i)=funcall( covar_func, repmat(pos(i,:),length(ind),1), ...
                pos(ind,:) );
            C(i,ind)=C(ind,i)';
        end
    end
end

