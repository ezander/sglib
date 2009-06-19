function plot_kl(els,pos,mu_k_j,kappa_i_alpha,k_j_i);
clf;
set( gcf, 'Position', [0, 0, 900, 900] );
set( gcf, 'Renderer', 'zbuffer' );
opts={'shading', 'flat', 'show_mesh', false};
for i=1:size(k_j_i,2)
    subplot(4,4,i);
    plot_field( els, pos, k_j_i(:,i), opts{:} );
    title(sprintf('KLE: f_{%d}',i));
    
    subplot(4,4,i+8);
    plot_field( els, pos, k_j_i(:,i), 'view', [30,15], opts{:} );
    title(sprintf('KLE: f_{%d}',i));
end
