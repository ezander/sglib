function tex_filename=write_tex_standalone( name, figdir, use_psfrag )

if nargin<3
    use_psfrag=true;
end

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
if use_psfrag
    fprintf(fid,'%s\n', '\usepackage{psfrag}');
end
fprintf(fid,'%s\n', '\begin{document}');
fprintf(fid,'%s\n', '\newdimen\psfgraphicswidth');
fprintf(fid,'%s\n', '\psfgraphicswidth=0.8\textwidth');
fprintf(fid,'%s\n', '\let\psflabelfontsize=\scriptsize');
fprintf(fid,'%s\n', '\let\psftickfontsize=\scriptsize');
fprintf(fid,'%s\n', '\let\psftextfontsize=\scriptsize');
fprintf(fid,'%s\n', '\let\psflegendfontsize=\tiny');
fprintf(fid,'%s\n', ['\input{',inc_filename,'}']);
fprintf(fid,'%s\n', '\end{document}');
fclose(fid);
