function show_sparsity_block_struct

p_u=3;
m_k=5; p_k=6;
m_f=5; p_f=3;
alphasort=true
kfirst=false;

multiplot_init(1,1);

% show full sparsity pattern
multiplot;
[S,I_k,I_u]=compute_sparsity( m_k, p_k, m_f, p_f, p_u, alphasort, kfirst, false );
spy2(S);

% show I_f block structure
k_mask=any(I_k,1)
f_mask=~k_mask;
x=(0:size(I_u,1)-1)+0.5;
[b,m,n]=unique( I_u( :, f_mask ), 'rows' );
stairs( x, size(I_u,1)-n', 'r' )

% show "sparse" sparsity pattern
p_k=2;
S=compute_sparsity( m_k, p_k, m_f, p_f, p_u, alphasort, kfirst, false );
spy2(S,'face_color', 'g');
