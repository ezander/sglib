function write_tex_include( texfilename, epsfilename, psfrag_list )

makesavepath( texfilename );
epsfilename=epsfilename(1:end-4); % dump the extension


fid=fopen( texfilename, 'w' );
if fid==-1
    warning( 'write_tex_include:fopen', 'could not open file: %s for writing (%s)\nAborting function...', tex_filename, msg );
    return
end
for i=1:length(psfrag_list)
    [tag,txt,font,pos]=psfrag_list{i}{:};
    txt=correct_tex_strings( txt );
    
    fprintf(fid, '\\psfrag{%s}[%s][%s][1][0]{{%s %s}}%%\n', ...
        tag, pos, pos, font, txt );
end
fprintf(fid, '\\includegraphics{%s}%%\n', epsfilename );
fclose(fid);



function str=correct_tex_strings( str )
if (any(find(str=='_')) || any(find(str=='^'))) && ~any(find(str=='$'))
    warning( 'sglib:write_tex_include:bad_tex_string', 'mathcommand witout $ detpsfrag_listected' );
    str=['$' str '$'];
end
