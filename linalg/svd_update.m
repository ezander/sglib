function [Un,Sn,Vn,err]=svd_update(U,S,V,C,varargin)
% SVD_UPDATE Efficiently add columns to an SVD.
%   [UN,SN,VN,ERR]=SVD_UPDATE(U,S,V,C,OPTIONS) efficiently computes the SVD
%   of [X C], where X=U*S*V'. The matrix of singular values S can also be a vector,
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
%   pnorm: {2}
%     Specifies the Schatten-p norm used for truncation, i.e. the norm that
%     is used for calculating the tolerance. Default (2) is the Frobenius
%     norm, (inf) would be the spectral norm. 
%     ATTENTION: this is not to be
%     confused with matrix norms induced by the vector p-norms but rather
%     the p-norm applied to the vector of singular values. Here we have the
%     equivalence that the matrix 2-norm (spectral) is equal to the
%     Schatten-Infinity norm (largest singular value) and the Frobenius
%     norm is equal to the Schatten-2 norm. The Frobenius norm is more
%     natural for tensor products and thus the default here.
%   rank: {inf} 
%     The maximum rank of the output SVD. If set to inf and reltol is zero
%     no truncation will happen. If both rank and reltol are set the
%     the criterion leading to the smaller rank will be applied.
%
% Example (<a href="matlab:run_example svd_update">run</a>)
%
% See also SVD, SVD_ADD


%   Elmar Zander
%   Copyright 2010-2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

[N,K]=size(V);
L=size(C,2);

V=[V; zeros(L,K)];
B=[zeros(N,L); eye(L)];

[Un,Sn,Vn,err]=svd_add(U,S,V,C,B,varargin{:});
