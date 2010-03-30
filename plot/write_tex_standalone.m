function tex_filename=write_tex_standalone( name, figdir )

tex_filename=make_filename( name, figdir, 'tex', '-view' );
inc_filename=make_filename( name, '', 'tex' ); % filename must be relative
makesavepath( tex_filename );

[fid, msg]=fopen( tex_filename, 'w' );
if fid==-1
    warning( 'write_tex_standalone:fopen', 'could not open file: %s for writing (%s)\nAborting function...', tex_filename, msg );
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
