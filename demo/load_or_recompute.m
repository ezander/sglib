function [data,version,recomp]=load_or_recompute( ndata, compute_func, params, filename, version )

if nargin<5
    version=[];
end

if exist( filename, 'file' ) 
    s=load( filename );
else
    s=struct();
end

if ~isempty(version) && (~isfield(s,'version') || ~isequal(s.version,version))
    s=struct();
end

if isfield(s,'params') && isequal(s.params,params) && isfield(s,'data')
    recomp=false;
    data=s.data;
    if isfield(s,'version')
        version=s.version;
    else
        version=[];
    end
else
    recomp=true;
    data=cell(ndata,1);
    [data{:}]=funcall( compute_func, params{:} );
    if ismatlab()
        save( filename , '-V6', 'data', 'params', 'version' );
    else
        save( '-mat', filename, 'data', 'params', 'version' );
    end
end


    
