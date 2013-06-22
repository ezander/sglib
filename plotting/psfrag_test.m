x=linspace(0,35,300);
y=sin(x);
set(0,'DefaulttextInterpreter', 'none')
plot(x,y,x+.1,y+.1,x+.2,y.^2+.2);
set( gca, 'tag', 'aplot' );
xlabel('$x_a$'); 
ylabel('\#test\& $yyy^{23}$')
legend({'$f1$', '$g^{(2)}$', '$\phi(x)$'}, 'tag' ,'psf_legend' )
text(10,1,'$a^b$')


save_latex( gca, 'xxx' )
%save_latex( gcf, 'xxx' )


