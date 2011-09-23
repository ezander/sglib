function percent_var_r=kl_percent_variance(l_r, cov_r, pos, G_N)
% KL_PERCENT_VARIANCE Short description of kl_percent_variance.
%   KL_PERCENT_VARIANCE Long description of kl_percent_variance.
%
% Example (<a href="matlab:run_example kl_percent_variance">run</a>)
%
% See also

%   <author>
%   Copyright 2011, <institution>
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

area=full(sum(G_N(:)));

C_r=covariance_matrix( pos, cov_r );
[r_i_r, sigma_r_k]=kl_solve_evp( C_r, G_N, l_r );
var_r=mean(diag(C_r));
percent_var_r=roundat( 100*sum(sigma_r_k(1:l_r).^2)/(area*var_r), 0.1 );
