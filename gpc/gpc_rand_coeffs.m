function x_i_alpha = gpc_rand_coeffs(V_x, Nx, varargin)
% GPC_RAND_COEFFS Create some random coefficients for a GPC for testing purposes.
%   X_I_ALPHA = GPC_RAND_COEFFS(V_X, NX) creates GPC coefficients for
%   testing purposes. X_I_ALPHA will contain NX time "size of V_X"
%   coefficients. The coefficients will be computed randomly but with some
%   exponentially decaying factor.
%
% Example (<a href="matlab:run_example gpc_rand_coeffs">run</a>)
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

options=varargin2options(varargin,mfilename);
[zero_mean,options]=get_option(options, 'zero_mean', false);
[order_decay,options]=get_option(options, 'order_decay', 0.1);
[min_order,options]=get_option(options, 'min_order', 0);
[max_order,options]=get_option(options, 'max_order', inf);
check_unsupported_options(options);

I_x=V_x{2};

Mx = gpcbasis_size(V_x, 1);
x_i_alpha = zeros(Nx, Mx);
if zero_mean && min_order<1
    min_order = 1;
end
order = multiindex_order(I_x);
ind = (min_order<=order) & (order<=max_order);
Mi = sum(ind);

x_i_alpha(:,ind) = rand(Nx, Mi)+0.2;
x_i_alpha = binfun(@times, x_i_alpha, order_decay.^(multiindex_order(I_x)'));
