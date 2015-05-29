function [r_i_k,sigma_k,l]=kl_solve_evp( C, G_N, l, varargin )
% KL_SOLVE_EVP Solve the Karhunen-Loeve eigenvalue problem.
%   [R_I_K,SIGMA_K]=KL_SOLVE_EVP( C, G_N, L, OPTIONS ) performs the
%   Karhunen-Loeve expansion on the input arguments. C is the pointwise
%   covariance matrix (if you have the covariance functions first stuff it
%   into COVARIANCE_MATRIX to generate the matrix). G_N is the spatial
%   Gramian matrix, if unspecified (i.e. []) the identity matrix is used.
%   G_N can also be a function that computes a matrix-vector product
%   instead of an explicit matrix represenation. L is the number of KL
%   terms to be returned.
%   R_I_K and SIGMA_K contain the eigenfunctions and eigenvalues of the KL
%   eigenproblem respectively. If only one output argument (i.e. R_I_K) is
%   used, then the R_I_K are multiplied by SIGMA_K before).
%
%   Options:
%     correct_var: true, {false}
%       With this option set to true you can apply a correction to the
%       eigenfunctions such that they match the variance specified by
%       diag(C) in each point exactly. This affects the accuracy
%   of some algorithms, but generally not the convergence. If you need e.g.
%   exactly variance 1 in each point, turn this on; otherwise you can leave
%   it of.
%
% Note: A mnemonic for the indices: for the KL the index of the
%   eigenfunctions is K and runs from to L
%
% Note: This function was renamed from KL_EXPAND to KL_SOLVE_EVP because
%   you don't actually get the full expansion, but only the spatial part of
%   it by solving the KL the eigenvalue problem.
%
% Example (<a href="matlab:run_example kl_solve_evp">run</a>)
%   n=10;
%   [pos,els]=create_mesh_1d(0,1,n);
%   C=covariance_matrix( pos, {@gaussian_covariance, {0.3, 2}} );
%   options.correct_var=true;
%   G_N=mass_matrix( pos, els );
%   r_i_k=kl_solve_evp( C, G_N, 3, options );
%   [mu,sig2]=pce_moments( [zeros(size(r_i_k,1),1), r_i_k], multiindex(3,1))
%
% See also COVARIANCE_MATRIX, OPTIONS

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


%TODO: make kl_solve_evp adhere to naming conventions
%TODO: dont actually compute GCG, use a function
%TODO: accept function instead of explicit mass matrix

options=varargin2options( varargin );
[correct_var,options]=get_option( options, 'correct_var', false );
[diag_warning_threshold]=get_option( options, 'diag_warning_threshold', 0.5 );
[use_sparse,options]=get_option( options, 'use_sparse', true );
check_unsupported_options( options, mfilename );

% check that not more eigenvectors are requested than size of C allows
if l>size(C,1)
    warning('kl_solve_evp:options', 'more kl-eigenvectors requested than matrix size allows: %d (reducing to %d)', ...
        l, size(C,1) );
    l=size(C,1);
end

% If the covariance matrix is close to diagonal the mesh is usually too
% coarse to resolve the covariance function good enough. Result is usually
% pretty bad kl eigenfunctions.
sd=sum(diag(C));
sod=sum(C(:))-sd;
%fprintf( 'kl prop: %g\n', full(sod/sd) );
if sod/sd<diag_warning_threshold
    warning( 'sglib:kl_solve_evp',  'Covariance matrix close to diagonal. Maybe your grid is too coarse for the given covariance length?' );
end

% calculate discrete covariance matrix W
if ~isempty(G_N)
    W=G_N*C*G_N;
else
    W=C;
end

% symmetrise W (often slightly unsymmetric causing eigs to complain)
if ~issymmetric( W )
    W=0.5*(W+W');
end

% Calculate eigenvalues and -vectors of generalized eigenvalue problem
% Since EIGS uses RAND for the starting vector, results are every time
% different, which makes a problem for cached function calls. Thus the
% state of RAND is
rand_state = rand('state'); %#ok<RAND>
rand('state', 0); %#ok<RAND>
eigs_options.disp=0;
if use_sparse
    if isempty(G_N)
        [V,D]=eigs( W, l, 'lm', eigs_options );
    else
        [V,D]=eigs( W, G_N, l, 'lm', eigs_options );
    end
    d=diag(D);
else
    if isempty(G_N)
        [V,D]=eig( W );
    else
        [V,D]=eig( W, G_N );
    end
    d=diag(D);
    [d,ind]=sort(d,'descend');
    V=V(:,ind(1:l));
    d=d(1:l);
end
rand('state',rand_state); %#ok<RAND>

% extract only positive eigenvalues, negative are possibly due to numerical
% errors. Maybe a warning should be issued here!
nl=sum(imag(d)==0 & d>0);
if nl<l
    warning( 'sglib:kl_solve_evp:negative', 'Not enough positive eigenvalues in KL eigenvalue problem reducing from %d to %d', l, nl);
    l=nl;
end
V=V(:,1:l);
d=d(1:l);

% retrieve the sigmas
sigma_k=reshape( sqrt(d), 1, [] );
% retrieve the r_i's
r_i_k=V;
if ~isempty(G_N) && isoctave()
    r_i_k=row_col_mult( r_i_k, 1./sqrt(diag(r_i_k'*G_N*r_i_k)') );
end

% correct the variance of output field to match that of the covariance
% matrix given
if correct_var
    in_var=diag(C);
    out_var=zeros(size(in_var));
    for k=1:l
        out_var=out_var+(r_i_k(:,k)*sigma_k(k)).^2;
    end
    r_i_k=row_col_mult( r_i_k, sqrt(in_var./out_var) );
end

% if the user doesn't want to have sigma_k then we put it into the r_i_k's
% then r_i_k*G_N*r_i_k'=diag(lambda) instead of r_i_k*G_N*r_i_k'=eye(m)
if  nargout<2
    r_i_k=row_col_mult( r_i_k, sigma_k );
end

function bool=issymmetric( A )
B=A';
bool=all(B(:)==A(:));
