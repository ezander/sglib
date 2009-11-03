function [main_tex, fig_tex]=write_tex_include( basename, topic, texdir, relepsdir, standalonetex, psfrag_list )


if standalonetex
    tex_filename=sprintf( './%s/%s_%s.tex', texdir, basename, topic );
    inc_filename=sprintf( '%s_%s-fig', basename, topic );
    [fid, msg]=fopen( tex_filename, 'w' );
    if fid==-1
        warning( 'write_tex_include:fopen', 'could not open file: %s for writing (%s)\nAborting function...', tex_filename, msg );
        return
    end
    fprintf(fid,'%s\n', '\documentclass{article}');
    fprintf(fid,'%s\n', '\usepackage{graphicx}');
    fprintf(fid,'%s\n', '\usepackage{psfrag}');
    fprintf(fid,'%s\n', '\begin{document}');
    fprintf(fid,'%s\n', '\let\PSReplLabelFontsize=\scriptsize');
    fprintf(fid,'%s\n', '\let\PSReplLegendFontsize=\tiny');
    fprintf(fid,'%s\n', '\def\PSReplAny#1#2{\psfrag{#1}[cc][cc][1][0]{{\PSReplLabelFontsize #2}}}');
    fprintf(fid,'%s\n', '\def\PSReplVert#1#2{\psfrag{#1}[cr][cr][1][0]{{\PSReplLabelFontsize #2}}}');
    fprintf(fid,'%s\n', '\def\PSReplHorz#1#2{\psfrag{#1}[tc][tc][1][0]{{\PSReplLabelFontsize #2}}}');
    fprintf(fid,'%s\n', '\def\PSReplLegend#1#2{\psfrag{#1}[Bl][Bl][1][0]{{\PSReplLegendFontsize #2}}}');
    fprintf(fid,'%s\n', ['\input{',inc_filename,'}']);
    fprintf(fid,'%s\n', '\end{document}');
    fclose(fid);
    main_tex=tex_filename;
end
if isempty(relepsdir); relepsdir='.'; end
tex_filename=sprintf( './%s/%s_%s-fig.tex', texdir, basename, topic );
eps_filename=sprintf( '%s/%s_%s.eps', relepsdir, basename, topic );

fid=fopen( tex_filename, 'w' );
if fid==-1
    warning( 'write_tex_include:fopen', 'could not open file: %s for writing (%s)\nAborting function...', tex_filename, msg );
    return
end
for i=1:length(psfrag_list)
    %fprintf(fid, '\\PSReplAny{%s}{%s}\n', psfrag_list{i}{1}, psfrag_list{i}{2} );
    fprintf(fid, '\\psfrag{%s}[%s][%s][1][0]{{%s %s}}\n', psfrag_list{i}{1}, psfrag_list{i}{4}, psfrag_list{i}{4}, psfrag_list{i}{3}, psfrag_list{i}{2} );
end
fprintf(fid, '\\includegraphics[width=0.8\\textwidth]{%s}\n', eps_filename );
fclose(fid);
fig_tex=tex_filename;

