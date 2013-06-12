function K=kl_pce_compute_operator_fast( k_i_k, k_k_alpha, I_k, I_u, stiffness_func, form, varargin )

options=varargin2options( varargin );
[verbosity,options]=get_option( options, 'verbosity', 0 );
check_unsupported_options( options, mfilename );

k_mask=any(I_k,1);
f_mask=~k_mask;
[ind2kblock, I_ku]=find_blocks( I_u, k_mask );
[ind2fblock, I_fu]=find_blocks( I_u, f_mask );

t=tic;
K_k=kl_pce_compute_operator( k_i_k, k_k_alpha, I_k(:,k_mask), I_ku(:,k_mask), stiffness_func, form, varargin{:} );
if verbosity>1
    fprintf( 'kappa_op: '); toc(t);
end

%K=map_blocks_slow( K_k, I_u, ind2fblock, ind2kblock, I_fu );
K=map_blocks( K_k, I_u, ind2fblock, ind2kblock, I_fu, verbosity );

function K=map_blocks( K, I_u, ind2fblock, ind2kblock, I_fu, verbosity )
n=size(I_u,1);
t=tic;
i=zeros(5*n,1);
j=zeros(5*n,1);
s=zeros(5*n,1);
for k=1:size(K,1)
    D=K{k,2};
    
    c=0;
    for b=1:max(ind2fblock);
        block=find(ind2fblock'==b);
        kind=ind2kblock(block);
        
        scale=multiindex_factorial(I_fu(b,:));
        [I,J]=meshgrid(block);
        S=D(kind,kind);
        l=numel(I);
        i(c+1:c+l)=I(:);
        j(c+1:c+l)=J(:);
        s(c+1:c+l)=scale*S(:);
        c=c+l;

    end
    K{k,2}=sparse(i(1:c),j(1:c),s(1:c),n,n);
end
if verbosity>1
    fprintf( 'placement: '); toc(t);
end


function K=map_blocks_slow( K, I_u, ind2fblock, ind2kblock, I_fu )
t=tic;
nnz_est=size(I_u,1);
for k=1:size(K,1)
    D=K{k,2};
    S=sparse([],[],[],size(I_u,1), size(I_u,1),nnz_est);
    
    for b=1:max(ind2fblock);
        block=find(ind2fblock'==b);
        kind=ind2kblock(block);
        
        scale=multiindex_factorial(I_fu(b,:));
        S(block,block)=scale*D(kind,kind);
    end
    
    K{k,2}=S;
    nnz_est=nnz(S);
end
if verbosity>1
    fprintf( 'placement: '); toc(t);
end


function [ind2block,I_unique]=find_blocks( I_u, mask )
[I_mask,block2ind,ind2block]=unique( I_u( :, mask ), 'rows' );
I_unique=I_u( block2ind, : );
I_unique(:,~mask)=0;

