function [r_j_alpha, I_r, C_r]=expand_field_pce_sg( rho_stdnor_func, cov_r_func, cov_gam_func, pos, G_N, p, m_gam, varargin )
% EXPAND_FIELD_PCE_SG Compute the PC expansion of a random field according to a paper of Sakamoto and Ghanem.
%   [R_J_ALPHA, I_R]=EXPAND_FIELD_PCE_SG( RHO_STDNOR_FUNC, COV_R_FUNC,
%   COV_GAM_FUNC, POS, G_N, P, M_GAM ) computes the PCE specified by the
%   arguments (to be explained later) and returns the coefficients of the
%   multivariate Hermite polynomials in RHO_J_ALPHA (indices returned in
%   I_R). RHO_STDNOR_FUNC describes the marginal distribution function of
%   the random field as a transform from a standard normal random variable
%   (i.e. RHO_STDNOR_FUNC must be such, that if G is N(0,1), then
%   RHO_STDNOR_FUNC(G) is distributed according to the desired marginal
%   density); Currently, only stationary fields are supported. COV_R
%   contains the covariance function of the field. COV_GAM, which may be
%   empty, contains the covariance of the underlying Gaussian field. If it
%   is not specified the covariance of the Gaussian field will be determined
%   from COV_R. POS contains the points on which the field is expanded. G_N
%   is the spatial Gramian. P is the order of the PC expansion. G_GAM is the
%   order of the KL expansion of the Gaussian base field.
%
% Options
%   transform_options: {'correct_var', true}
%      If C_GAM_FUNC is not specified the covariance of the underlying
%      field is computed by TRANSFORM_COVARIANCE_PCE and this option is
%      passed through to this function. Usually the default is what you
%      want (i.e. don't worry about the absolute magnitude of the
%      covariance, but rather about its shape/relative magnitude).
%
% Example (<a href="matlab:run_example expand_field_pce_sg">run</a>)
%   N=51;
%   p_k=4;
%   m_k=4;
%   stdnor_k={@lognormal_stdnor,{0.5,1}};
%   stdnor_k={@beta_stdnor,{4,2}};
%   [pos,els,bnd]=create_mesh_1d( 0, 1, N );
%   G_N=mass_matrix( pos, els );
%   for i=1:4
%     lc_k=0.5^(i-1);
%     fprintf('conv. length: %g\n', lc_k);
%     cov_k={@gaussian_covariance,{lc_k,1}};
%     [k_i_alpha, I_k]=expand_field_pce_sg( stdnor_k, cov_k, [], pos, G_N, p_k, m_k );
%     subplot(2,2,i); plot_pce_realizations_1d( pos, k_i_alpha, I_k );
%   end
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
check_condition( rho_stdnor_func, 'isfunction', false, 'rho_stdnor_func', mfilename );
check_condition( cov_r_func, 'isfunction', false, 'cov_r_func', mfilename );
check_condition( cov_gam_func, 'isfunction', true, 'cov_gam_func', mfilename );
check_range( size(pos,1), 1, 3, 'sizeof(pos,1)', mfilename );
check_condition( G_N, 'square', true, 'G_N', mfilename );
check_condition( {pos, G_N}, 'match', true, {'pos', 'G_N'}, mfilename );
check_range( p, 1, 10, 'p', mfilename );
check_range( m_gam, 0, 1000, 'm_gam', mfilename );

% get options
options=varargin2options( varargin );
[transform_options,options]=get_option( options, 'transform', {'correct_var', true} );
[kl_options,options]=get_option( options, 'kl_options', struct() );
[p_trans,options]=get_option( options, 'p_trans', min(p,7) );
[mean_func,options]=get_option( options, 'mean_func', [] );
check_unsupported_options( options, mfilename );


% Step 1: calculate the rho_k(pos) numerically
rho_k=pce_expand_1d(rho_stdnor_func,p_trans);
if m_gam==0
    r_j_alpha=repmat(rho_k(1), size(pos,2), 1);
    I_r=multiindex(0,0);
    C_r=ones(size(pos,2));
    return
end

% Step 0: if the number of random variables is zero



% Step 2: calculate <gam_i gam_j> from <u_i u_j>
C_r=covariance_matrix( pos, cov_r_func );
if ~isempty( cov_gam_func )
    C_gam=covariance_matrix( pos, cov_gam_func );
else
    if isstruct(transform_options)
        transform_options=struct2options(transform_options);
    end
    C_gam=transform_covariance_pce( C_r, rho_k, transform_options{:} );
end

% Step 3: Calculate lamda_i and r_i (i.e. do KL expansion)
% g contains the product sqrt(lambda_i)*g_i of the KL of gamma
kl_options.correct_var=true;
g_j_i=kl_solve_evp( C_gam, G_N, m_gam, kl_options );

% Step 4: generate gam(pos)
% this was implicit in step 3

% Step 5: transform gam(pos) into u
[r_j_alpha,I_r]=pce_transform_multi( g_j_i, rho_k );


% Replace the mean
if ~isempty(mean_func)
    r_i_mean=funcall( mean_func, pos );
    r_i_alpha(:,1)=r_i_mean;
end
