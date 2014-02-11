function [Q,R]=gram_schmidt( A, B, mod, reorth )
% GRAM_SCHMIDT Perform Gram-Schmidt orthogonalization.
%   [Q,R]=GRAM_SCHMIDT( A, B, MOD, REORTH ) performs the Gram-Schmidt
%   process on the matrix A such that Q is orthogonal with respect to B
%   (i.e. Q*B*Q'==I), R is an upper triangular matrix and A==Q*R. The B
%   argument B may be omitted or an empty array is passed, in which case
%   that standard Gram-Schmidt process is used (in that case, you may want
%   to call the matlab/octave command QR anyway, because it is more stable
%   and accurate than the Gram-Schmidt process).
%   MOD (default: false) is a boolean flag signifying GRAM_SCHMIDT to use
%   the modified Gram-Schmidt process.
%   REORTH (default: 1) is a integer parameter given the number of
%   reorthogonalizations.
%
%   Choice of default parameters: As shown in [1] one reorthogonalization
%   step is enough to get near machine precision. In that case there is
%   furthermore no difference between modified and classical Gram-Schmidt
%   so that the latter is chosen due to its better amenability to
%   parallelization/vectorization. Methods for selective
%   reorthogonalization should also be considered when efficiency becomes a
%   prime issue (which might or will be the case sooner or later, see [2])
%
% References:
%   [1] L. Giraud, J. Langou , M. Rozloznik: On the loss of orthogonality
%       in the Gram-Schmidt orthogonalization process ,  Computers &
%       Mathematics with Applications 50 (2005), pp. 1069--1075.
%   [2] L. Giraud, J.Langou:   A robust criterion for the modified Gram–
%       Schmidt algorithm with selective reorthogonalization, SIAM J. Sci.
%       Comput., Vol. 25, No. 2, pp. 417–441
%
% Example (<a href="matlab:run_example gram_schmidt">run</a>)
%   n=100; m=200; k=40;
%   A=rand(n,k);
%   M=rand(n,n); M=M'*M;
%   for reorth=0:1
%     for mod=[false,true]
%       [Q,R]=gram_schmidt( A, M, mod, reorth );
%       fprintf( 'mod:%d, re:%d: |R-triu(R)|=%- 8.3e   |Q''MQ-I|=%- 8.3e   |A-QR|=%- 8.3e \n',  ...
%          mod, reorth, ...
%          norm(R-triu(R)), ...
%          norm(Q'*M*Q-eye(size(Q,2))), ...
%          norm(A-Q*R));
%    end
%  end
%
% See also QR, ORTH, QR_INTERNAL

%   Elmar Zander
%   Copyright 2007-2014, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


if nargin<2 || isempty(B)
    B=speye(size(A,1));
end
if nargin<3 || isempty(mod)
    mod=false;
end
if nargin<4 || isempty(reorth) || reorth<0
    reorth=1;
end

% GS Perform the conjugate Gram-Schmidt process.
threshold=1e-10;
n=min(size(A));
Q=zeros(size(A,1),n);
j=0;
for i=1:size(A,2)
    a=A(:,i);
    anorm=norm(a);
    for r=1:(reorth+1)
        if mod
            for k=1:j
                a=a-Q(:,k)*(Q(:,k)'*B*a);
            end
        else
            a=a-Q*(Q'*B*a);
        end
    end
    enorm=norm(a);
    if enorm/anorm<threshold
        continue;
    end
    
    a=a/sqrt(a'*B*a);
    j=j+1;
    Q(:,j)=a;
end
if j<n
    Q=Q(:,1:j);
end
    
R=Q'*B*A;
