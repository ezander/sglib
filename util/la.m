function l

s=dir;
curr=pwd;
for dodirs=[true,false]; 
    for i=1:length(s)
        if s(i).isdir~=dodirs
            continue;
        end
        if s(i).isdir
            format='<a href="matlab:cd %s; fprintf(''\\n%%s:\\n'',pwd); l">%s/</a>';
            str=sprintf( format, fullfile(curr,s(i).name), s(i).name );
            
        else
            format='<a href="error:%s,1,1">%s</a>';
            str=sprintf( format, fullfile(curr,s(i).name), s(i).name );
        end
        disp(str);
    end
end
