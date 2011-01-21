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
if isfield( info, 'rho' ) && isfield( info, 'updnormvec' ) && isfield( info, 'epsvec' )
    rho=info.rho;
    errest=rho/(1-rho)*info.updnormvec/info.norm_U+info.epsvec;
    strvarexpand( 'error est.: $errest(end)$' )
end

strvarexpand( 'epsilon: $info.epsvec(end)$' )

strvarexpand( 'precond calls: $sum(info.rank_res_before)$' )
if isfield( info, 'rank_K' )
    strvarexpand( 'op rank: $info.rank_K$' )
    strvarexpand( 'apps per rank: $sum(info.rank_sol_after)$' )
    strvarexpand( 'op applications: $info.rank_K*sum(info.rank_sol_after)$' )
end

strvarexpand( 'max. res rank: $max(info.rank_res_before)$' )
strvarexpand( 'last res rank: $info.rank_res_before(end)$' )
strvarexpand( 'max. sol rank: $max(info.rank_sol_after)$' )
strvarexpand( 'last sol rank: $info.rank_sol_after(end)$' )
