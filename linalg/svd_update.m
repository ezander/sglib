function [Un,Sn,Vn,err]=svd_update(U,S,V,C,varargin)
% SVD_UPDATE Efficiently add columns to an SVD.
%   [UN,SN,VN,ERR]=SVD_UPDATE(U,S,V,C,OPTIONS) efficiently computes the SVD
%   of [X C], where X=U*S*V'. On input and output formats and options,
%   please see SVD_ADD.
%
% Example (<a href="matlab:run_example svd_update">run</a>)
%
% See also SVD_ADD


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

M=size(U,1);
K=size(U,2);
N=size(V,1);
L=size(C,2);

V=[V; zeros(L,K)];
A=C;
B=[zeros(N,L); eye(L)];

[Un,Sn,Vn,err]=svd_add(U,S,V,A,B,varargin{:});