% this file generates all the images for the oberseminar

%addpath dummy/


clf; clear;
dist='lognorm';
p_range=1:7;
switch dist
    case 'lognorm'
        params={2, 0.5};
        trans=@lognorm_stdnor;
        pdf=@lognorm_pdf;
        cdf=@lognorm_cdf;
        x=linspace(-5,6);
        xi=linspace(-5,20);
        kd_var=0.3;
        p_range=1:6;
    case 'beta'
        params={2, 4};
        trans=@beta_stdnor;
        pdf=@beta_pdf;
        cdf=@beta_cdf;
        x=linspace(-5,6);
        xi=linspace(-1,2);
        kd_var=0.03;
        p_range=1:7;
    case 'beta_bimodal'
        params={0.5, 0.4};
        trans=@beta_stdnor;
        pdf=@beta_pdf;
        cdf=@beta_cdf;
        x=linspace(-5,6);
        xi=linspace(-1,2,91);
        kd_var=0.03;
        p_range=1:2:13;
    case 'uniform'
        params={2, 4};
        trans=@uniform_stdnor;
        pdf=@uniform_pdf;
        cdf=@uniform_cdf;
        x=linspace(-5,5);
        xi=linspace(0,6);
        kd_var=0.05;
        p_range=1:2:15;
    case 'zh'
        params={0.03};
        trans=@zinn_harvey_connected_stdnor;
        pdf=@normal_pdf;
        cdf=@normal_cdf;
        x=linspace(-5,6);
        xi=linspace(-3,3);
        kd_var=0.1;
    case 'bimodal'
        params={};
        trans=@(x)(2+3*(0.5+atan(20*x)/pi));
        inv_trans=@(y)(tan(pi*((y-2)/3-0.5))/20);
        d_inv_trans=@(y)(1./cos(pi*y/3-pi*7/6).^2*pi/60);

        pdf=@(x)((x>=2&x<=5).*1./cos(pi*x/3-pi*7/6).^2*pi/60.*normal_pdf(tan(pi*((x-2)/3-0.5))/20));
        % norm_cdf: R->[0,1], x_cdf: I->[0,1], trans:R->I, x_cdf=norm_cdf( inv_trans )        
        cdf=@(x)((x>=2&x<=5).*normal_cdf(tan(pi*((x-2)/3-0.5))/20)+(x>5));
        x=linspace(-5,6);
        xi=linspace(0,7);
        kd_var=0.1;
        p_range=1:2:15;
    otherwise
        error( 'unknown distribution' );
end

for p=p_range
    subplot(1,3,1)
    pcc=pce_expand_1d( {trans,params}, p );
    y=hermite_val( pcc, x );
    plot(x,funcall({trans,params},x),'r');
    hold on;
    plot(x,y,'b');
    hold off;

    subplot(1,3,2)
    plot( xi, pdf( xi, params{:} ), 'r' );
    hold on;
    kernel_density( hermite_val( pcc, randn(20000,1) ),200, kd_var, 'g' );
    plot( xi, pce_pdf( xi, pcc ), 'b' );
    xlim( [min(xi),max(xi)] );
    hold off;
    title(sprintf( 'order: %d', p ) );
    
    subplot(1,3,3)
    plot( xi, cdf( xi, params{:} ), 'r' );
    hold on;
    plot( xi, pce_cdf( xi, pcc ), 'b' );
    xlim( [min(xi),max(xi)] );
    hold off;
    bp=waitforbuttonpress;
    if bp==1; break; end
end
