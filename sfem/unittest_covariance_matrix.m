function unittest_covariance_matrix
% UNITTEST_COVARIANCE_MATRIX Test covariance related functions.
%
% Example (<a href="matlab:run_example unittest_covariance">run</a>)
%   unittest_covariance
%
% See also TESTSUITE

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

munit_set_function( 'covariance_matrix' );


n=11;
x=linspace(0,1,n);
C_u=covariance_matrix( x, {@gaussian_covariance,{1e-10}} );
assert_equals( C_u, eye(n), 'identity' );

n=11;
x=linspace(0,1,n);
C_u=covariance_matrix( [x; zeros(size(x))]', {@gaussian_covariance,{1}} );
assert_equals( C_u, [1 exp(-3.85); exp(-3.85) 1], 'identity' );



% some initialization stuff
n=300;
x=linspace(0,1,n);

% First some test whether the normal generation of the 1-dimensional
% covariance matrix is correct (2- and 3-dimensional still missing)
L=.2;
sig=2;
C_u=covariance_matrix( x, {@gaussian_covariance, {L,sig}} );
C_u_ex=toeplitz(sig^2*exp(-x.^2/L^2));
assert_equals( C_u, C_u_ex, 'cov_matrix' );

Lmax=.4;
C_u=covariance_matrix( x, {@gaussian_covariance, {L,sig}}, 'max_dist', Lmax );
cmin=sig^2*exp(-Lmax^2/L^2);
C_u_ex( C_u_ex<cmin ) = 0;
assert_equals( C_u, C_u_ex, 'cov_matrix_lmax' );
assert_true( issparse(C_u), 'cov_matrix_lmax_sparse' );

n=1500;
L=.1; K=5;
x=linspace(-1,2,n);
%tic
C_u=covariance_matrix( x, {@gaussian_covariance, {L,sig}}, 'max_dist', K*L );
%toc
%tic
C_u2=covariance_matrix( x, {@gaussian_covariance, {L,sig}} );
%toc
C_u_ex=toeplitz(sig^2*exp(-(x+1).^2/L^2));
assert_equals( C_u, C_u_ex, 'cov_matrix_4L', 'abstol', sig^2*exp(-K^2) );



n=3;
sig=2.5;
x=rand(2,n);
L=1.4;
C_u=covariance_matrix( x, {@gaussian_covariance, {L,sig}} );
[X,Y]=meshgrid(x(1,:),x(2,:));
DX=(X-X')/L; DY=(Y-Y')/L;
C_u_ex=sig^2*exp(-(DX.^2+DY.^2));
assert_equals( C_u, C_u_ex, 'cov_matrix_2d' );

L=[1.1, 2.1];
C_u=covariance_matrix( x, {@gaussian_covariance, {L,sig}} );
[X,Y]=meshgrid(x(1,:),x(2,:));
DX=(X-X')/L(1); DY=(Y-Y')/L(2);
C_u_ex=sig^2*exp(-(DX.^2+DY.^2));
assert_equals( C_u, C_u_ex, 'cov_matrix_2d_l2' );






























%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% here comes old stuff that not only tests the covariance matrix function
% but also other stuff, need to clean that up

n=20;
x=linspace(0,1,n);

% Then check whether transformation to a non-standard Gaussian works
% a) Do pce and check moments
h=@(x)(4+0.3*x);
[pcc,pci]=pce_expand_1d(h,3);
[mu,sig2,skew]=pce_moments( pcc, pci );
assert_equals( [mu,sig2,skew], [4,0.09,0], 'moments' );

% b) create covariance matrix and check
lc=0.5;
C_u=covariance_matrix( x, {@gaussian_covariance, {lc, sqrt(sig2)}} );
C_u_ex=toeplitz(sig2*exp(-x.^2/lc^2));
assert_equals( C_u, C_u_ex,'cov_matrix' );

% c) transform and check
C_gam=transform_covariance_pce( C_u, pcc );
C_gam_ex=toeplitz(exp(-x.^2/lc^2));
assert_equals( C_gam, C_gam_ex, 'cov_transform' );






%% A test from a paper from Phoon and Queck
C_gam_ex=[ 1.0, 0.3, -0.9;
        0.3, 1.0,  0.3;
       -0.9, 0.3,  1.0 ];
% we use the transformation given by Phoon etal instead of the approx.
% values from the paper
C_u=1/5*C_gam_ex.*(3+2*C_gam_ex.^2);

G=@(gam)(gam.^3);
pcc_u=pce_expand_1d( G, 7 );

C_gam=transform_covariance_pce( C_u, pcc_u, 'correct_var', true, 'comp_ii_check', false );
assert_equals( C_gam, C_gam_ex, 'phoon', 'reltol', 1e-5 );



%% Testing pce transform multi
clear;
n=10;
x=linspace(0,1,n);
m_gam=4;
m_u=5;
M=[];

h_u=@(x)(lognormal_stdnor( x, 2, 0.5) );
u_i=pce_expand_1d(h_u,m_u);
[mean_u,var_u]=pce_moments( u_i, [] );
mean_u; %#ok: mean_u unused
C_u=covariance_matrix( x, {@gaussian_covariance, {0.3, sqrt(var_u)}} );

C_gam=transform_covariance_pce( C_u, u_i, 'comp_ii_reltol', 1e-1 );
v_gam=kl_solve_evp( C_gam, M, m_gam, 'correct_var', true );
[u_alpha1,I_u1]=pce_transform_multi( v_gam, u_i, 'fast', false );
[u_alpha2,I_u2]=pce_transform_multi( v_gam, u_i, 'fast', true );

assert_equals( u_alpha2, u_alpha1, 'pce_transform_multi_fast' );
assert_equals( I_u2, I_u1, 'pce_transform_multi_fast' );


%% Testing covariance matrix from pce
clear;
n=10;
x=linspace(0,1,n);
m_gam=8;
p_u=10;
M=[];

h_u=@(x)(lognormal_stdnor( x, 2, 0.5) );
u_i=pce_expand_1d(h_u,p_u);
[mean_u,var_u]=pce_moments( u_i, [] );
mean_u; %#ok: mean_u unused
C_u=covariance_matrix( x, {@gaussian_covariance, {0.3, sqrt(var_u)}} );

C_gam=transform_covariance_pce( C_u, u_i, 'comp_ii_reltol', 1e-2 );
s=warning('OFF', 'sglib:kl_solve_evp:negative');
v_gam=kl_solve_evp( C_gam, M, m_gam, 'correct_var', true );
warning(s);
[u_alpha,I_u]=pce_transform_multi( v_gam, u_i, 'fast', true );

C_u_pce=pce_covariance( u_alpha, I_u );

assert_equals( C_u_pce, C_u, 'covar_pce', 'abstol', 0.02);
