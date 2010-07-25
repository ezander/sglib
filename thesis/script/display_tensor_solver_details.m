underline( 'Tensor solver stats' );
if isfield( info, 'descr' )
    strvarexpand( 'description: $info.descr$' )
end
strvarexpand( 'time: $info.time$' )
strvarexpand( 'iterations: $info.iter$' )
strvarexpand( 'relative res.: $info.relres$' )
if ~isempty(info.errvec)
    strvarexpand( 'relative error: $info.errvec(end)$' )
end
strvarexpand( 'epsilon: $info.epsvec(end)$' )

strvarexpand( 'precond calls: $sum(info.rank_res_before)$' )
if isfield( info, 'rank_K' )
    strvarexpand( 'op rank: $info.rank_K$' )
    strvarexpand( 'apps per rank: $sum(info.rank_sol_after)$' )
    strvarexpand( 'op applications: $info.rank_K*sum(info.rank_sol_after)$' )
end