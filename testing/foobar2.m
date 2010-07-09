%%
clf;
ttt=tensor_modes( Xn ); ttt=ttt/ttt(1); semilogy(ttt); hold on
ttt=tensor_modes( Rn ); ttt=ttt/ttt(1); semilogy(ttt, 'r')
ttt=tensor_modes( Pn ); ttt=ttt/ttt(1); semilogy(ttt, 'g')
ttt=tensor_modes( Zn ); ttt=ttt/ttt(1); semilogy(ttt, 'k')
legend( 'X', 'R', 'P', 'Z' );

% function foobar
% 
% 
% 
% I_u=multiindex(2,2);
% I_k=multiindex(2,3);
% 
% 
% model_large;
% build_model;
% I_k=multiindex(m_k,p_k);
% I_f=multiindex(m_f,p_f);
% I_g=multiindex(m_g,p_g);
% p_u=get_base_param('p_u', max([p_k,p_f,p_g]));
% [I_k,I_f,I_g,I_u]=multiindex_combine( {I_k, I_f, I_g}, p_u );
% 
% k_i_iota=rand(5, size(I_k,1));
% 
% M=hermite_triple_fast( I_u, I_u, I_k );
% Delta_i=tensor_multiply( M, k_i_iota, 3, 2 );
% 
% M2=hermite_triple_fast( I_u, I_u, I_k, 'algorithm', 'sparse' );
% %Delta_i=tensor_multiply( M, k_i_iota, 3, 2 );
% Delta_i2=M2*k_i_iota';
% Delta_i3=reshape( Delta_i2, [size(I_u,1), size(I_u,1), size(k_i_iota,1)] );
% 
% 
% norm(M2(:)-M(:))
% norm(reshape(Delta_i-Delta_i3,1,[]))
% 
% m1=M(:);
% m2=full(M2(:));
% x=find(m1~=m2);
% 
% keyboard
