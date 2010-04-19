function [Un,Sn,Vn,err]=svd_add(U,S,V,A,B,varargin)
% SVD_ADD Efficiently add a decomposed matrix to an SVD.
%   [UN,SN,VN,ERR]=SVD_ADD(U,S,V,A,B,OPTIONS) efficiently computes the SVD
%   of U*S*V'+A*B'. The matrix of singular values S can also be a vector,
%   or empty, in which case the function assumes the columns of U are
%   scaled by the singular values. The output format is the same as the
%   input format, so if S is empty on entry it will also be on exit. ERR
%   contains the relative error in the truncation (if any), with respect to
%   the norm used (see Options). 
%    
% Options:
%   reltol: {0}
%     Specifies relative tolerance for truncation. The default (0) means no
%     truncation at all (at least if 'rank' is infinite)
%   pnorm: {inf}
%     Specifies the Schatten-p norm used for truncation, i.e. the norm that
%     is used for calculating the tolerance. Default (inf) is the spectral
%     norm, (2) would be the Frobenius norm. ATTENTION: this is not to be
%     confused with matrix norms induced by the vector p-norms but rather
%     the p-norm applied to the vector of singular values.
%   rank: {inf} 
%     The maximum rank of the output SVD. If set to inf and reltol is zero
%     no truncation will happen. If both rank and reltol are set the
%     the criterion leading to the smaller rank will be applied.
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options(varargin);
[reltol,options]=get_option(options,'reltol', 0 );
[pnorm,options]=get_option(options,'pnorm', inf );
[rank,options]=get_option(options,'rank', inf );
check_unsupported_options(options);

type=get_svd_type(S);
[U,S,V]=svd_to_type( U, S, V, 'matrix' );

M=size(A,1);
N=size(B,1);
L=size(A,2);

[P,RA]=qr((eye(M)-U*U')*A,0);
[Q,RB]=qr((eye(N)-V*V')*B,0);

K=blkdiag(S,zeros(L))+[U'*A; RA]*[V'*B;RB]';
[Us,Sn,Vs]=svd(K);
Un=[U P]*Us;
Vn=[V Q]*Vs;

[k,err]=schattenp_truncate( diag(Sn), reltol, true, pnorm, rank );
Un=Un(:,1:k);
Vn=Vn(:,1:k);
Sn=Sn(1:k,1:k);

[Un,Sn,Vn]=svd_to_type( Un, Sn, Vn, type );

