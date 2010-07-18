function la

s=dir;
curr=pwd;
for dodirs=[true,false]; 
    for i=1:length(s)
        if s(i).isdir~=dodirs
            continue;
        end
        if s(i).isdir
            format='<a href="matlab:cd %s; fprintf(''\\n%%s:\\n'',pwd); la">%s/</a>';
            str=sprintf( format, fullfile(curr,s(i).name), s(i).name );
            
        else
            [path,name,ext]=fileparts(s(i).name);
            full=fullfile(curr,s(i).name);
            short=s(i).name;
            switch ext
                case '.m'
                    format='<a href="error:%s,1,1">%s</a>';
                    str=sprintf( format, full, short );
                case '.mat'
                    format='<a href="matlab:underline( ''Contents of %s''); whos -file %s">%s</a>';
                    str=sprintf( format, short, full, short );
                otherwise
                    format='<a href="matlab:s=dir(''%s''); s">%s</a>';
                    str=sprintf( format, full, short );
            end
        end
        disp(str);
    end
end
