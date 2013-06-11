function show_distributions

hold off;

x=point_range([0,1], 'ext', 0.02);
f1=beta_pdf(x,2,3);
f2=beta_pdf(x,0.5,0.5);
f3=beta_pdf(x,0.5,2);
plot(x,f1,x,f2,x,f3);
ylim( [0,4] );

clf; hold all;
x=point_range([0,1], 'ext', 0.02);
an=pi*rand(7,2)*diag([2,1]);
co=[ cos(an(:,1)).*sin(an(:,2)),...
     sin(an(:,1)).*sin(an(:,2)),...
     cos(an(:,2))];
co=(co+1)/2;
set( gca, 'ColorOrder', co );
plot(x,beta_pdf(x,0.5,0.5));
plot(x,beta_pdf(x,1,1));
plot(x,beta_pdf(x,2,2));
plot(x,beta_pdf(x,4,4));
plot(x,beta_pdf(x,10,10));
legend( 'B_{1,1}', '$B_{2,2}$', '$B_{4,4}$', '$B_{10,10}$' );
ylim( [0,4] );
save_eps( 'beta_pdf-symm' );
save_latex( 'beta_pdf-symm' );

