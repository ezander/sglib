function K=kl_pce_compute_operator_fast( k_i_k, k_k_alpha, I_k, I_u, stiffness_func, form, varargin )

k_mask=any(I_k,1);
f_mask=~k_mask;
[ind2kblock, I_ku]=find_blocks( I_u, k_mask );
[ind2fblock, I_fu]=find_blocks( I_u, f_mask );

K=kl_pce_compute_operator( k_i_k, k_k_alpha, I_k, I_ku, stiffness_func, form, varargin );
for k=1:size(K,1)
    D=K{k,2};
    S=sparse(size(I_u,1), size(I_u,1));
    
    for b=1:max(ind2fblock);
        block=find(ind2fblock'==b);
        kind=ind2kblock(block);
        
        scale=multiindex_factorial(I_fu(b,:));
        S(block,block)=scale*D(kind,kind);
    end
    
    K{k,2}=S;
end







function [ind2block,I_unique]=find_blocks( I_u, mask )
[I_mask,block2ind,ind2block]=unique( I_u( :, mask ), 'rows' );
I_unique=I_u( block2ind, : );
I_unique(:,~mask)=0;

%block_deg=sum(I_unique,2);

