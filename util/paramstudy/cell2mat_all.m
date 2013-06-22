function s=cell2mat_all( s )

fields=fieldnames(s);
for i=1:length(fields)
    field=fields{i};
    try
        s.(field)=cell2mat(s.(field));
    catch 
        % ignore
    end
end