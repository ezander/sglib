trunc.eps=1e-18;
trunc.k_max=inf;
trunc.show_reduction=false;

% test with truncation
mh=multiplot_init( 3, 3 );
fast=false;
fast=false;

if fast
    modes={'before'};
    epsvals=10.^-[0:2:14];
else
    modes={'operator', 'before', 'after'};
    epsvals=10.^-[0:0.5:14];
end

for xxx=1:length(modes)
    mode=modes{xxx};
    
    common={'maxiter', 100, 'reltol', tol, 'abstol', tol, 'Minv', Minv, 'verbosity', 1 };
    leg={};
    err=[];
    res=[];
    time=[];
    ep=[];
    
    multiplot([],1);
    logaxis( gca, 'y' );
    title( 'res by iter' );
    for eps=epsvals
        disp(strvarexpand('$xxx$ $mode$ $eps$'));
        trunc.eps=eps;
        leg=[leg {strvarexpand('$eps$')}]; %#ok<AGROW>
        
        %[X,flag,info]=generalized_solve_simple( A, F, 'Minv', Minv, common{:}, 'trunc_mode', 'operator', 'trunc', trunc   );
        t=tic;
        [X,flag,info]=generalized_solve_simple( A, F, 'Minv', Minv, common{:}, 'trunc_mode', mode, 'trunc', trunc   );
        tt=toc(t);
        if exist('x','var') && ~isempty(x)
            curr_err=norm( x-tensor_to_vector( X ) )/gvector_norm(x);
        else
            curr_err=1;
        end
        err=[err curr_err];
        res=[res info.relres/gvector_norm(F)];
        time=[time tt];
        ep=[ep eps];
        
        multiplot([],1);
        plot( info.resvec, '-+' );
        %legend( leg );
        
        multiplot([],7);
        logaxis( gca, 'x' );
        title( 'rank by eps and iter' );
        plot( info.rank_sol_after+0.2*xxx, 'x-' );
        %legend_add( mode );
        
        disp(strvarexpand('  => time=$tt$  iter=$info.iter$  flag=$flag$  res=$res(end)$'));
    end
    
    multiplot([],2);
    logaxis( gca, 'xy' );
    title( 'err by eps' );
    plot( ep, err, 'x-' );
    legend_add( mode );
    
    multiplot([],3);
    logaxis( gca, 'xy' );
    title( 'res by eps' );
    plot( ep, res, 'x-' );
    legend_add( mode );
    
    multiplot([],4);
    logaxis( gca, 'x' );
    title( 'err/eps by eps' );
    plot( ep, err./ep, 'x-' );
    legend_add( mode );
    
    multiplot([],5);
    logaxis( gca, 'x' );
    title( 'res/eps by eps' );
    plot( ep, res./ep, 'x-' );
    legend_add( mode );
    
    multiplot([],6);
    logaxis( gca, 'x' );
    title( 'time by eps' );
    plot( ep, time, 'x-' );
    legend_add( mode );
    
    
    multiplot([],8);
    logaxis( gca, 'y' );
    plot( fak^(xxx-1)*tensor_modes( X ), 'x-' );
    legend_add( mode );
    
end

multiplot([],2);
plot( ep, ep, '-' );
legend_add( '"identity"' );

multiplot([],3);
plot( ep, ep, '-' );
legend_add( '"identity"' );

if exist('rho','var')
    multiplot([],4);
    plot( ep, repmat(1/(1-rho),size(ep)), '-' );
    lim=ylim;
    lim(2)=min(3/(1-rho), lim(2) );
    ylim(lim);
    legend_add( 'theoretical' );
end

if exist('cmptime','var')
    multiplot([],6);
    plot( ep, repmat(cmptime,size(ep)), '-' );
    legend_add( 'full pcg' );
end

multiplot([],8);
logaxis( gca, 'y' );
plot( fak^xxx*svd(reshape(x,tensor_size(X))), 'x-' );
legend_add( 'pcg sol.' );

save_figure( mh(1), {[model_name, '_%s'], 'res_by_iter'} );
save_figure( mh(2), {[model_name, '_%s'], 'err_by_eps' } );
save_figure( mh(3), {[model_name, '_%s'], 'res_by_eps' } );
save_figure( mh(4), {[model_name, '_%s'], 'err_div_eps' } );
save_figure( mh(5), {[model_name, '_%s'], 'res_div_eps' } );
save_figure( mh(6), {[model_name, '_%s'], 'time_by_eps' } );
save_figure( mh(7), {[model_name, '_%s'], 'rank' } );
save_figure( mh(8), {[model_name, '_%s'], 'modes' } );
