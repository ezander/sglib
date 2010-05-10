multiplot_init( 2, 1 );

multiplot;
for i=1:100
    plot( pos, kl_pce_field_realization( k_i_k, k_k_alpha, I_k ) );
end


multiplot;
for i=1:100
    plot( pos, kl_pce_field_realization( f_i_k, f_k_alpha, I_f ) );
end
