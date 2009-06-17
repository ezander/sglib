function [f,sqrt_lambda]=kl_expand( C, G, m, varargin )
% KL_EXPAND Perform Karhunen-Loeve expansion.
%   [F,SQRT_LAMBDA]=KL_EXPAND( C, G, M, OPTIONS ) performs the
%   Karhunen-Loeve expansion on the input arguments. C is the pointwise
%   covariance matrix (if you have the covariance functions first stuff it
%   into COVARIANCE_MATRIX to generate the matrix). G is the spatial Gramian matrix,
%   if unspecified (i.e. []) the identity matrix is used. G can also be a
%   function that computes a matrix-vector product instead of an explicit
%   matrix represenation. M is the number of KL terms to be
%   returned.
%   F and SQRT_LAMBDA contain the eigenfunctions and eigenvalues of the KL
%   eigenproblem respectively. If only one output argument (i.e. F) is used,
%   then the f_i are multiplied by sqrt_lambda_i before).
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
% Example (<a href="matlab:run_example kl_expand">run</a>)
%   n=10;
%   x=linspace(0,1,n)';
%   els=[1:n-1; 2:n]';
%   C=covariance_matrix( x, {@gaussian_covariance, {0.3, 2}} );
%   options.correct_var=true;
%   G=mass_matrix( els, x );
%   f=kl_expand( C, G, 3, options );
%   [mu,sig2]=pce_moments( [zeros(size(f,1),1), f], multiindex(3,1))
%
% See also COVARIANCE_MATRIX, OPTIONS

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


%TODO: make kl_expand adhere to naming conventions
%TODO: dont actually compute GCG, use a function
%TODO: accept function instead of explicit mass matrix

options=varargin2options( varargin{:} );
[correct_var,options]=get_option( options, 'correct_var', false );
check_unsupported_options( options, mfilename );

% check that not more eigenvectors are requested than size of C allows
if m>size(C,1)
    warning('kl_expand:options', 'more kl-eigenvectors requested than matrix size allows: %d (reducing to %d)', ...
        m, size(C,1) );
    m=size(C,1);
end

% calculate discrete covariance matrix W
if ~isempty(G)
    W=G*C*G;
else
    W=C;
end

% symmetrise W (often slightly unsymmetric causing eigs to complain)
if issymmetric( C ) && ~issymmetric( G ) && ~issymmetric( W )
    W=0.5*(W+W');
end

% Calculate eigenvalues and -vectors of generalized eigenvalue problem
% Since EIGS uses RAND for the starting vector, results are every time
% different, which makes a problem for cached function calls. Thus the
% state of RAND is 
rand_state = rand('state');
rand('state', 0);
eigs_options.disp=0;
if isempty(G)
    [V,D]=eigs( W, m, 'lm', eigs_options );
else
    [V,D]=eigs( W, G, m, 'lm', eigs_options );
end
rand('state',rand_state);

% retrieve the lambdas
sqrt_lambda=reshape( sqrt(diag(D)), 1, [] );
% retrieve the f's (f_i should correspond to f(:,i))
f=V;
if ~isempty(G) && isoctave()
    f=row_col_mult( f, 1./sqrt(diag(f'*G*f)') );
end

% correct the variance of output field to match that of the covariance
% matrix given
if correct_var
    in_var=diag(C);
    out_var=zeros(size(in_var));
    for i=1:m
        out_var=out_var+(f(:,i)*sqrt_lambda(i)).^2;
    end
    f=row_col_mult( f, sqrt(in_var./out_var) );
end

% if the user doesn't want to have sqrt_lambda then we put it into the f's
% then f*M*f'=diag(lambda) instead of f*M*f'=eye(m)
if  nargout<2
    f=row_col_mult( f, sqrt_lambda );
end

function bool=issymmetric( A )
B=A';
bool=all(B(:)==A(:));

