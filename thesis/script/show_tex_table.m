function show_tex_table(n,infos)
global info_tp

if nargin<2 || isempty(infos)
    infos=info_tp;
end

switch n
    case 1
        entries={
            -1, '','';
            0, 'Mode',             '$info.descr$';
            -1, '','';
            0,  'Mean rank res.',   '$round(mean(info.rank_res_before))$';
            0,  'Mean rank sol.',   '$round(mean(info.rank_sol_after))$';
            0,  'Ssqr rank res.',   '$round(sum(info.rank_res_before.^2))$';
            0,  'Ssqr rank sol.',   '$round(sum(info.rank_sol_after.^2))$';
            0,  'Final rank res.',  '$round(info.rank_res_before(end))$';
            0,  'Final rank sol.',  '$round(info.rank_sol_after(end))$';
            -1, '','';
            0,  'Iterations',       '$round(info.iter)$';
            -1, '','';
            0,  'Runtime',          '$rft(timer.gen_solver_simple)$';
            1,  'Truncations',      '$rft(timer.tensor_truncate)$';
            2,  'QR',               '$rft(timer.qr_internal)$';
            2,  'SVD',              '$rft(timer.tensor_truncate_svd__svd)$';
            1,  'Operator',         '$rft(timer.tensor_operator_apply_elementary)$';
            2,  'Preconditioner',   '$rft(timer.operator_lusolve)$';
            -1, '','';
            0,  'Memory (MiB)',     '$rfm((info.memmax.VmSize-info.memorig.VmSize)/1024/1024)$';
            -1, '','';
            0,    'Time',             '$info.time$';
            0,    'Relerr',             '$info.relerr2$';
            0,    'Flag',             '$info.flag$';
            0,    'Relres',             '$info.relres(end)$';
            };
        rft=@(x)(roundat(x,0.1));
        rfm=@(x)(roundat(x,0.01));
    case 2
        entries={
            -1, '','';
            0, 'Preconditioner',             '\$\P_{\kwf{$info.name$}}\$';
            -1, '','';
            0,  'Setup time (s)',               '$info.setup_time$';
            -1, '','';
            0,  '\$\rho(\D)\$',               '$info.diff_rho$';
            0,  '\$\opnorm[2]{\D}\$',         '$info.diff_norm_2$';
            0,  '\$\opnorm[F]{\D}\$',         '$info.diff_norm_fro$';
            -1, '','';
            0,  '\$\rho(\PD)\$',            '$info.idiff_rho$';
            0,  '\$\opnorm[2]{\PD}\$',      '$info.idiff_norm_2$';
            0,  '\$\opnorm[F]{\PD}\$',      '$info.idiff_norm_fro$';
            -1, '','';
            0,  '\$q\$',                 '$info.contract$';
            -1, '','';
            0,  '\$n_{\kwf{pcg}}\$',      '$info.npcg$';
            0,  '\$n_{\kwf{gsi}}\$',      '$info.ngsi$';
            0,  '\$k_{10}\$',      '$info.k10$';
            -1, '','';
            %    'Time',             '$info.time$';
            };
        rft=@(x)(roundat(x,0.1));
        rfm=@(x)(roundat(x,0.01));
        
    otherwise
        error( 'foobar' );
end
maketable( infos, entries, true, rft, rfm )

function maketable( infos, entries, trans, rft, rfm )
fprintf( '\n');
fprintf( '%% ---BEGIN SGLIB GENERATED---\n');
if trans
    for j=1:length(entries)
        for i=0:length(infos)
            printentry( infos, entries, i, j, i==length(infos), rft, rfm );
        end
        fprintf( '\n');
    end
else
    for i=0:length(infos)
        for j=1:length(entries)
            printentry( infos, entries, i, j, j==length(entries), rft, rfm );
        end
        fprintf( '\n');
    end
end
fprintf( '%% ---END SGLIB GENERATED---\n');

function printentry( infos, entries, i, j, atend, rft, rfm )
mode=entries{j,1};
if mode==-1
    if i==0; fprintf( '\\hline'); end
    return
end
if i==0
    entry=strvarexpand( entries{j,2} );
    if mode>0
        entry=sprintf( '\\hspace*{%dem}%s', mode, entry);
    end
else
    if iscell(infos)
        info=infos{i};
    else
        info=infos(i);
    end
    if isfield(info,'timers')
        timer=info.timers;
    end
    entry=strvarexpand( entries{j,3} );
    
    if isfield(info,'flag') && info.flag~=0
        entry=[entry strvarexpand( '($info.flag$)' )];
    end
end
del='& ';
if atend
    del='\\';
end
fprintf( '%s %s', entry, del );

