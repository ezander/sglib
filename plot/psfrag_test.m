x=linspace(0,35,300);
y=sin(x);
%set(0,'DefaulttextInterpreter', 'none')
subplot(1,1,1)
plot(x,y,x+.1,y+.1,x+.2,y+.2);
xlabel('$x_a$'); 
ylabel('\#test\& $yyy^{23}$')
legend({'$f1$', '$g^{(2)}$', '$\phi(x)$'})
text(10,1,'$a^b$')

basename='aaa'
topic='bbb'

psfrag_list=psfrag_format( gca )

% If requested also save tex file
inc_filename=sprintf( '%s_%s', basename, topic );
tex_filename=sprintf( './%s/%s_%s-fig.tex', 'eps', basename, topic );
write_tex_include( basename, topic, 'eps', '', true, psfrag_list );

save_eps( basename, topic );

system('cd eps && latex aaa_bbb && dvips aaa_bbb && gv aaa_bbb ')

