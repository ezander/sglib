function [T_k,sigma,k]=ctensor_truncate( T, varargin )
% CTENSOR_TRUNCATE Computes a truncated rank tensor product.
%   [T_K,SIGMA,K]=CTENSOR_TRUNCATE( T, OPTIONS ) truncates the tensor T to a
%   rank K approximation T_K. SIGMA contains the singular values of T, and
%   K the rank of the approximation that was determined by choice of
%   parameters.
%
% Options:
%   p: 2 (the Schatten p norm, 2 is Frobenius (Hilbert-Schmidt), inf is
%         induced 2 norm (spectral,Euclidean), 1 is trace norm
%   k_max: inf
%   eps: 0
%   relcutoff: true
%
% Example (<a href="matlab:run_example ctensor_truncate">run</a>)
%   % still to come
%
% See also CTENSOR_ADD

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options( varargin );
[G,options]=get_option( options, 'G', {} );
[p,options]=get_option( options, 'p', 2 );
[k_max,options]=get_option( options, 'k_max', inf );
[eps,options]=get_option( options, 'eps', 0 );
[relcutoff,options]=get_option( options, 'relcutoff', true );
[orth_columns,options]=get_option( options, 'orth_columns', 0 );
check_unsupported_options( options, mfilename );

timers( 'start', mfilename );

if isnumeric(T)
    [U,S,V]=svd(T,0);
    [T_k,sigma,k]=ctensor_truncate_svd( {U*S,V}, G, eps, k_max, relcutoff, p, min(size(T)) );
    T_k=T_k{1}*T_k{2}';
elseif iscell(T)
    if length(T)==2
        [T_k,sigma,k]=ctensor_truncate_svd( T, G, eps, k_max, relcutoff, p, orth_columns );
    else
        U_k=call_cp_als( ktensor( T ), k_max, eps, 'random' );
        lambda=U_k.lambda(:);
        T_k=U_k.u';
        T_k{1}=row_col_mult( T_k{1}, lambda' );
    end
elseif isobject(T)
        T_k=call_cp_als( T, k_max, eps, 'random' );
else
    error( 'sglib:ctensor_truncate:tensor_format', 'Unknown tensor format' );
end

timers( 'stop', mfilename );

function T_k=call_cp_als(T,k_max,eps,init)
OPTS.tol=eps;
OPTS.maxiters=50;
OPTS.init=init;
OPTS.printitn=0;
T_k=cp_als( T, k_max, OPTS );
if any(isnan(double(T_k)))
    keyboard;
end
