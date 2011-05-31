function show_cmpsol_huge
% show results for solving the huge model

clc
log_start( fullfile( log_file_base(), mfilename ) );
compare_solvers_pcg( 'model_huge_easy', get_solve_options, 'accurate', false )
show_tex_table;
log_stop();


function opts=get_solve_options
opts={};
opts{end+1}=struct( 'longdescr', 'normal tensor solver', 'descr', 'normal');
opts{end+1}=struct( 'longdescr', 'dynamic tensor solver', 'dyn', true, 'descr', 'dynamic');

opts{end+1}=varargin2options( {'longdescr', 'prec tensor solver', ...
    'dyn', true, 'prec', {'same'}, 'descr', 'prec'} );

ilu_setup={'type', 'ilutp', 'droptol', 2e-2, 'milu', 'row', 'udiag', 1 };
opts{end+1}=varargin2options( {'longdescr', 'ilutp 2 row prec tensor solver', ...
    'dyn', true, 'prec', {'ilu', ilu_setup}, 'descr', 'dynilutp'} );



function show_tex_table
global info_tp

entries={
    'Mode',             '$info.descr$';
    'hl','';
    'Mean rank res.',   '$round(mean(info.rank_res_before))$';
    'Mean rank sol.',   '$round(mean(info.rank_sol_after))$';
    'hl','';
    'Runtime',          '$rft(t.gen_solver_simple)$';
    'Truncations',      '$rft(t.tensor_truncate)$';
    'QR',               '$rft(t.qr_internal)$';
    'SVD',              '$rft(t.tensor_truncate_svd__svd)$';
    'Operator',         '$rft(t.tensor_operator_apply_elementary)$';
    'Preconditioner',   '$rft(t.operator_lusolve)$';
    'hl','';
    'Memory (MiB)',     '$rfm((info.memmax.VmSize-info.memorig.VmSize)/1024/1024)$';
%    'Time',             '$info.time$';
    };
rft=@(x)(roundat(x,0.1));
rfm=@(x)(roundat(x,0.01));
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
hline=strcmp(entries{j,1},'hl');
if hline
    if i==0; fprintf( '\\hline'); end
    return
end
if i==0
    entry=strvarexpand( entries{j,1} );
else
    info=infos{i};
    t=info.timers;
    entry=strvarexpand( entries{j,2} );
end
del='& ';
if atend
    del='\\';
end
fprintf( '%s %s', entry, del );

