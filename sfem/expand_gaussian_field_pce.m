function [g_i_alpha, I_g, C, sigma_g]=expand_gaussian_field_pce( cov_func, pos, G_N, m_gam, varargin )
% 
% See also PLOT_PCE_REALIZATIONS_1D, COVARIANCE_MATRIX, TRANSFORM_COVARIANCE_PCE, PCE_TO_KL

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

% check input parameters
check_condition( cov_func, 'isfunction', false, 'cov_func', mfilename );
check_range( size(pos,1), 1, 3, 'sizeof(pos,1)', mfilename );
check_condition( G_N, 'square', true, 'G_N', mfilename );
check_condition( {pos, G_N}, 'match', true, {'pos', 'G_N'}, mfilename );
check_range( m_gam, 0, 1000, 'm_gam', mfilename );

% get options
options=varargin2options( varargin );
[kl_options,options]=get_option( options, 'kl_options', struct() );
check_unsupported_options( options, mfilename );



C=covariance_matrix( pos, cov_func );

%kl_options.correct_var=true;
kl_options.scale_result = true;
[g_i_alpha, sigma_g]=kl_solve_evp( C, G_N, m_gam, kl_options );
if size(g_i_alpha,2)<m_gam
    warning( 'sglib:expand_gaussian_random_field_pce', 'could not determine enough independent gaussians' );
    g_i_alpha=[g_i_alpha, zeros(size(g_i_alpha,1),m_gam-size(g_i_alpha,2))];
end

I_g=multiindex( m_gam, 1 );
g_i_alpha=[zeros(size(g_i_alpha,1),1), g_i_alpha];

