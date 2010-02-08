function show_hermite_polynomials

x=linspace(-3.5,3.5);
y=pce_evaluate( eye(5), multiindex(1,4), x )
y=row_col_mult( y, exp(-x.^2/2)/sqrt(2*pi) );
plot(x,y)
xlabel('x');
ylabel('y');
legend('h_0','h_1','h_2','h_3','h_4')
title('Hermite functions')
grid on
save_thesis_figure( 'hermite_functions_1d', {} );

x=linspace(-3,3);
y=pce_evaluate( eye(5), multiindex(1,4), x )
%y=row_col_mult( y, exp(-x.^2/2)/sqrt(2*pi) );
plot(x,y)
xlabel('x');
ylabel('y');
legend('H_0','H_1','H_2','H_3','H_4')
ylim([-10,10])
grid on
title('Hermite polynomials')
save_thesis_figure( 'hermite_polynomials_1d', {} );



