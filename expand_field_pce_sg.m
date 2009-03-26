function [r_j_alpha, I_r, C_r]=expand_field_pce_sg( rho_stdnor_func, cov_r_func, cov_gam_func, pos, M_N, p, m_gam, varargin )
% EXPAND_FIELD_PCE_SG Compute the PC expansion of a random field according to a paper of Sakamoto and Ghanem.
%  [R_J_ALPHA, I_R]=EXPAND_FIELD_PCE_SG( RHO_STDNOR_FUNC, COV_R_FUNC,
%  COV_GAM_FUNC, POS, M_N, P, M_GAM ) computes the PCE specified by the
%  arguments (to be explained later) and returns the coefficients of the
%  multivariate Hermite polynomials in RHO_J_ALPHA (indices returned in
%  I_R). RHO_STDNOR_FUNC describes the marginal distribution function of
%  the random field as a transform from a standard normal random variable
%  (i.e. RHO_STDNOR_FUNC must be such, that if G is N(0,1), then
%  RHO_STDNOR_FUNC(G) is distributed according to the desired marginal
%  density); Currently, only stationary fields are supported. COV_R
%  contains the covariance function of the field. COV_GAM, which may be
%  empty, contains the covariance of the underlying Gaussian field. If it
%  is not specified the covariance of the Gaussian field will be determined
%  from COV_R. POS contains the points on which the field is expanded. M_N
%  is the mass matrix. P is the order of the PC expansion. M_GAM is the
%  order of the KL expansion of the Gaussian base field.

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

check_condition( rho_stdnor_func, 'isfunction', false, 'rho_stdnor_func', mfilename );
check_condition( cov_r_func, 'isfunction', false, 'cov_r_func', mfilename );
check_condition( cov_gam_func, 'isfunction', true, 'cov_gam_func', mfilename );
check_range( size(pos,2), 1, 3, 'sizeof(pos,2)', mfilename );
check_condition( M_N, 'square', true, 'M_N', mfilename );
check_condition( {M_N, pos}, 'match', true, {'M_N', 'pos'}, mfilename );
check_range( p, 1, 10, 'p', mfilename );
check_range( m_gam, 1, 1000, 'm_gam', mfilename );

% check_condition( isfunction(rho_stdnor_func), 'rho_stdnor_func must be a function type', mfilename );
% check_condition( isfunction(cov_r_func), 'cov_r_func must be a function type', mfilename );
% check_condition( isempty(cov_gam_func) || isfunction(cov_gam_func), 'cov_gam_stdnor_func must be a function type or empty', mfilename );
% check_range( size(pos,2), 1, 3, 'sizeof(pos,2)', mfilename );
% check_condition( size(M_N,1)==size(M_N,2), 'M_N must be a square matrix', mfilename );
% check_condition( size(M_N,1)==size(pos,1), 'M_N and pos don''t match', mfilename );
% check_range( p, 1, 10, 'p', mfilename );
% check_range( m_gam, 1, 1000, 'm_gam', mfilename );

options=varargin2options( varargin{:} );
[transform_options,options]=get_option( options, 'transform', {} );
check_unsupported_options( options, mfilename );

% Step 1: calculate the rho_k(pos) numerically 
rho_k=pce_expand_1d(rho_stdnor_func,p);

% Step 2: calculate <gam_i gam_j> from <u_i u_j>
C_r=covariance_matrix( pos, cov_r_func );
if ~isempty( cov_gam_func )
    C_gam=covariance_matrix( pos, cov_gam_func );
else
    C_gam=transform_covariance_pce( C_r, rho_k, transform_options );
end

% Step 3: Calculate lamda_i and r_i (i.e. do KL expansion)
% g contains the product sqrt(lambda_i)*g_i of the KL of gamma
options.correct_var=true;
g_j_i=kl_expand( C_gam, M_N, m_gam, options );

% Step 4: generate gam(pos)
% this was implicit in step 3

% Step 5: transform gam(pos) into u
[r_j_alpha,I_r]=pce_transform_multi( g_j_i, rho_k );
