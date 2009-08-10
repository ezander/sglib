% DEMO_KS_TEST Demonstrate the usage of the  Kolmogorov-Smirnov test function.

N=1000;

% create N normal random numbers
g=randn(N,1);
y=linspace(0,1,N);
% transform random numbers to lognormal distribution
x=sort(exp(g));

% plot the exact distribution
clf;
plot(x,lognorm_cdf(x,0,1), 'r-', 'linewidth', 5 );
xlim([-5 10]);
hold on;
% plotted over linear distributed values in [0,1] gived empirical CDF
plot(x,y,'k');

% now plot different pce approximations
col='gycbg';
for p=1:8
    pcc=pce_expand_1d( @exp, p );
    x_pc=hermite_val(pcc,g);
    x_pc=sort(x_pc);
    % plot the approximation
    plot( x_pc, y, col(min(p,length(col))) );
    % check whether kolmogorov smirnov can differentiate between
    % approximation and true distribution
    [reject]=ks_test( [x,y'], x_pc );
    disp(sprintf('order: %1d reject: %1d', p, reject ) );
end
legend('exp analyt.', 'exp','pce 1','pce 2','pce 3','pce 4','pce 5' );
hold off;

% check that the real distribution is not rejected
% (but this can happen in 5% of all cases if the usual 95% confidence 
% interval is used)
x=x(:); 
[reject]=ks_test( @lognorm_cdf, x );
disp(sprintf('order: %1d reject: %1d', inf, reject ) );

% Check that in approximately 5% of all cases the hypothesis that the
% distributions match is rejected even if they match indeed
sr=0; 
for i=1:1000; 
    x_samp=randn(N,1); 
    [reject]=ks_test( @normal_cdf, x_samp ); 
    sr=sr+reject; 
end; 
disp( sprintf( 'Should reject in ~5%% of all cases, did it in %3.1f%%.', sr/10 ) );
