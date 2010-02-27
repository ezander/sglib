function show_kl_decay


m=50;

[els,pos,G_N]=load_pdetool_geom( 'square', 0 ); %#ok<ASGLU>
x=linspace(-4,4,201);
funcs={@gaussian_covariance, @exponential_covariance, @spherical_covariance};
lc_fs=[2, 1, 0.5];



clf
subfig=false;

for i=1:length(funcs)
    
    sigma=zeros(m,0);
    y=zeros(length(x),0);
    for j=1:length(lc_fs);
        cov_func={funcs{i},{lc_fs(j), 1}};
        [v_f,sigma(:,j)]=kl_solve_evp( covariance_matrix( pos, cov_func ), G_N, m ); %#ok<ASGLU>
        y(:,j)=funcall( cov_func, x', [] );
    end
    
    if subfig
        subplot(3,2,2*i-1)
    end
    plot(x,y); 
    legend('L=2.0','L=1.0','L=0.5')
    if ~subfig
        save_thesis_figure( 'correlation_func_%s', {func2str(func{1})} );
    end

    if subfig
        subplot(3,2,2*i-0)
    end
    plot(sigma); 
    legend('L=2.0','L=1.0','L=0.5')
    if ~subfig
        save_thesis_figure( 'kl_decay_corr_%s', {func2str(func{1})} );
    end
    
    if ~subfig
        plot(log(sigma));
        legend('L=2.0','L=1.0','L=0.5')
        save_thesis_figure( 'log_kl_decay_corr_%s', {func2str(func{1})} );
    end
end

if subfig
    save_thesis_figure( 'kl_decay');
end
