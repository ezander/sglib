function S=kl_pce_sparsity( I_u, I_k, no_deterministic )
% KL_PCE_SPARSITY Compute sparsity of a stochastic operator.
%   S=KL_PCE_SPARSITY( I_U, I_K, NO_DETERMINISTIC ) computes the sparsity
%   pattern of the stochastic matrices (Delta) of the stochastic operator
%   with I_U being the multiindex set related to the solution and I_k the
%   multiindex set related to the operator. If NO_DETERMINISTIC is true,
%   all elements in the sparsity pattern related to deterministic
%   components of the operator is set to zero (which corresponds to the
%   deterministic component usually being treated separate). If set to
%   false also the determinstic component is also included in the sparsity
%   pattern (which makes a nice and more comprehensive pattern).
%
% Example (<a href="matlab:run_example kl_pce_sparsity">run</a>)
%     I_k=multiindex( 5, 3 );
%     I_f=multiindex( 2, 3 );
%     [I_k,I_f,I_u]=multiindex_combine({I_k,I_f},4);
%     S=kl_pce_sparsity( I_u, I_k, false );
%     spy2( S );
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


if nargin<3
    no_deterministic=true;
end

ind2block=find_blocks( I_u, I_k );


S=sparse(size(I_u,1),size(I_u,1));
ms=max(sum(I_k,2));

for b=1:max(ind2block);
    block=find(ind2block'==b);
    for i=block
        for j=block(block<=i)
            d=abs(I_u(i,:)-I_u(j,:));
            if no_deterministic && sum(d)==0; continue; end
            if sum(d)<=ms && ismember(d, I_k, 'rows')
                S(i,j)=1;
                S(j,i)=1;
            end
        end
    end
end

function [ind2block,block_deg]=find_blocks( I_u, I_k )
k_mask=any(I_k,1);
f_mask=~k_mask;
[I_unique,dummy,ind2block]=unique( I_u( :, f_mask ), 'rows' ); %#ok<ASGLU>
block_deg=sum(I_unique,2);

