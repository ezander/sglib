function show_tex_table(n)
global info_tp

switch n
    case 1
        entries={
            -1, '','';
            0, 'Mode',             '$info.descr$';
            -1, '','';
            0,  'Mean rank res.',   '$round(mean(info.rank_res_before))$';
            0,  'Mean rank sol.',   '$round(mean(info.rank_sol_after))$';
            -1, '','';
            0,  'Runtime',          '$rft(t.gen_solver_simple)$';
            1,  'Truncations',      '$rft(t.tensor_truncate)$';
            2,  'QR',               '$rft(t.qr_internal)$';
            2,  'SVD',              '$rft(t.tensor_truncate_svd__svd)$';
            1,  'Operator',         '$rft(t.tensor_operator_apply_elementary)$';
            2,  'Preconditioner',   '$rft(t.operator_lusolve)$';
            -1, '','';
            0,  'Memory (MiB)',     '$rfm((info.memmax.VmSize-info.memorig.VmSize)/1024/1024)$';
            -1, '','';
            %    'Time',             '$info.time$';
            };
        rft=@(x)(roundat(x,0.1));
        rfm=@(x)(roundat(x,0.01));
    otherwise
        error( 'foobar' );
end
maketable( info_tp, entries, true, rft, rfm )

function maketable( infos, entries, trans, rft, rfm )
fprintf( '\n');
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
    info=infos{i};
    t=info.timers;
    entry=strvarexpand( entries{j,3} );
end
del='& ';
if atend
    del='\\';
end
fprintf( '%s %s', entry, del );

