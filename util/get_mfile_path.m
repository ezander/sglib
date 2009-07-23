function path=get_mfile_path

s=dbstack('-completenames');
path=fileparts(s(2).file);
