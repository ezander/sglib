function d=tensor_norm( T, meth, M1, M2 )
% TENSOR_NORM Compute the norm of a sparse tensor.
%   D=TENSOR_NORM( T, METH ) computes the norm of the sparse tensor product
%   T using the method specified in METH.
%   
%   Methods to compute the tensor norm:
%     'orth': assuming the column vectors in the components of T are
%       orthogonal the tensor norm is just the sum of the products of the
%       sum of squares of each pair of column vectors (i.e. assume the 
%       tensor product is given as sum_i u_i x v_i then the norm is just 
%       sqrt( sum_i u_i^2 v_i^2, but *only* if <u_i,u_j>=0 and <v_i,v_j>=0
%       for i~=j) 
%     'svd' (default): uses the sparse svd for computation of the norm
%     'full': first computes the full tensor product and then computes the
%       norm as the Frobenius norm of this matrix. *Note:* This is only
%       intented for testing purposes since it is in general a waste of
%       memory and far too slow for real world applications.
%     'inner': computes the norm as the square root of the scalare product
%       of T with itself.
%
% Example (<a href="matlab:run_example tensor_norm">run</a>)
%   T={rand(8,2), rand(10,2)};
%   fprintf('Note that orth gives a wrong result since the columns are not orthogonal \n');
%   for meth={'orth', 'svd', 'full', 'inner'}; 
%     fprintf('%- 5s:  %f\n', meth{1}, tensor_norm( T, meth{1} ) )
%   end
%   Z=tensor_add(T,T,-1);
%   fprintf('Note that orth gives a wrong result since the columns are not orthogonal \n');
%   for meth={'orth', 'svd', 'full', 'inner'}; 
%     fprintf('%- 5s:  %f\n', meth{1}, tensor_norm( Z, meth{1} ) )
%   end
%
% See also TENSOR_ADD, TENSOR_REDUCE

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


if nargin<2 || isempty(meth)
    meth='svd';
end

if nargin<3
    M1=[]; M2=[];
end

if isempty(M1)~=isempty(M2)
    error( 'tensor_norm:gramians', 'both gramians must be given or both must be empty' );
end

switch lower(meth)
    case 'orth'
        t1_sqr=sum(T{1}.^2,1);
        t2_sqr=sum(T{2}.^2,1);
        d=sqrt( sum(t1_sqr.*t2_sqr) );
    case 'svd'
        if isempty(M1)
            % see help on QR for this...
            R1=triu(qr(T{1},0));
            R2=triu(qr(T{2},0));
        else
            [Q1,R1]=gram_schmidt(T{1},M1,false,1);
            [Q2,R2]=gram_schmidt(T{2},M2,false,1);
            Q1; Q2; %#ok: Q1, Q2 unused
        end
        s=svd(R1*R2',0);
        d=norm( s, 2 );
    case 'full'
        % The following line should produce the same value (slower and waste of
        % memory, but useful for debugging)
        if isempty(M1)
            d=norm(T{1}*T{2}','fro');
        else
            d=sqrt(trace( M1*T{1}*T{2}'*M2*T{2}*T{1}' ));
        end
    case 'inner'
        sp=max( tensor_scalar_product(T,T,'M1', M1, 'M2', M2), 0 );
        d=sqrt( sp );
end

