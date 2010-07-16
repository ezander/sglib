%%

Xi=Ui{1}
Xi

strvarexpand( 'rank: $tensor_rank( Xi )$' )
strvarexpand( 'size: $tensor_size( Xi )$' )
strvarexpand( 'size: $prod(tensor_size( Xi ))$' )

%%
multiplot_init( 1,1 );
multiplot;
plot( tensor_modes( Xi ), 'x-' )
logaxis( gca, 'y' )



