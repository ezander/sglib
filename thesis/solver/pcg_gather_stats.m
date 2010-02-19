function stats=pcg_gather_stats( what, stats, varargin )
switch(what)
    case 'init'
        stats=gather_stats_init( stats, varargin{:} );
    case 'step'
        stats=gather_stats_step( stats, varargin{:} );
    case 'finish'
        stats=gather_stats_finish( stats, varargin{:} );
    otherwise
        error( 'not yet implemented' )
end


function stats=gather_stats_init( stats, initres )
norm_func={@tensor_norm,  {stats.G}, {2}};
stats.res_norm=[initres]; %#ok
stats.res_relnorm=[1]; %#ok
stats.res_accuracy=[];
stats.res_relacc=[];
stats.upratio=[1];%#ok
stats.sol_err=[];
stats.sol_relerr=[];
if ~isempty( stats.X_true )
    stats.X_true_eps=tensor_truncate( stats.X_true, stats.trunc_options );
    stats.sol_err=funcall( norm_func, stats.X_true );
    stats.sol_relerr=[1]; %#ok
    stats.soleps_err=funcall( norm_func, stats.X_true_eps );
    stats.soleps_relerr=[1]; %#ok
end


function stats=gather_stats_step( stats, F, A, Xn, Rn, normres, relres, upratio )
norm_func={@tensor_norm,  {stats.G}, {2}};

% maybe there is a difference between the residual in the alg and here
% I think so...
TRn=tensor_add( F, tensor_operator_apply( A, Xn ), -1 );
%normres=funcall( norm_func, TRn );
%relres=normres/stats.initres;

DRn=tensor_add( Rn, tensor_add( F, tensor_operator_apply( A, Xn ), -1 ), -1 );
ra=funcall( norm_func, DRn );

stats.res_norm(end+1)=normres;
stats.res_relnorm(end+1)=relres;
stats.res_accuracy(end+1)=ra;
stats.res_relacc(end+1)=ra/normres;
stats.upratio(end+1)=upratio;

if ~isempty( stats.X_true )
    solerr=funcall( norm_func, tensor_add( Xn, stats.X_true, -1 ) );
    solrelerr=solerr/stats.sol_err(1);
    stats.sol_err(end+1)=solerr;
    stats.sol_relerr(end+1)=solrelerr;

    solepserr=funcall( norm_func, tensor_add( Xn, stats.X_true_eps, -1 ) );
    solepsrelerr=solepserr/stats.soleps_err(1);
    stats.soleps_err(end+1)=solepserr;
    stats.soleps_relerr(end+1)=solepsrelerr;
end

function stats=gather_stats_finish( stats, varargin ) %#ok
fields=intersect( fieldnames(stats), {'X_true', 'X_true_eps', 'G'} )
stats=rmfield( stats, fields );
%nothing yet

