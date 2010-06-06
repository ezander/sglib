function S=kl_pce_sparsity( I_u, I_k, no_deterministic )

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
[I_unique,dumm2,ind2block]=unique( I_u( :, f_mask ), 'rows' );
block_deg=sum(I_unique,2);

