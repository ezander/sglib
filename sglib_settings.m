function settings=sglib_settings( action )

% before running the setup should have been performed at least partly
sglib_check_setup;

% set default for action
if nargin==0 || isempty(action)
    action='dialog';
end

% init currently known settings
% maybe, but only maybe, we should have some registering mechanism
m_solver_showmessage = {'never', 'always', 'error', 'nooutputarg'};
m_shading_types = {'none', 'faceted', 'interp'};
m_userwaitmodes = {'keyboard','mouse','continue'};

setters={};
setters={ setters{:}, {'list', 'userwaitmode', setuserwaitmode('getmode'), m_userwaitmodes  } };
setters={ setters{:}, {'bool', 'show_greeting', true } };
setters={ setters{:}, {'bool', 'munit_jump_debugger', true } };

setters={ setters{:}, {'text', 'medit_author', '<author>' } };
setters={ setters{:}, {'text', 'medit_institution', '<institution>' } };
setters={ setters{:}, {'bool', 'medit_options_and_notes', false } };

if exist( 'we_dont_need_that_stuff_yet', 'var' )
    setters={ setters{:}, {'list', 'shading', 'faceted', m_shading_types } };
    setters={ setters{:}, {'list', 'solver_show_message', 'error', m_solver_showmessage } };
end

% do action
switch action
    case 'load'
        settings_file=sglib_get_appdata('settings_file');
        try
            settings=read( settings_file );
        catch
            settings=struct();
        end
        % for loop setting all defaults on non existent fields
        for i=1:length(setters)
            setter=setters{i};
            if ~isfield( settings, setter{2} )
                settings.(setter{2})=setter{3};
            end
        end
        sglib_set_appdata( settings, 'settings' );
    case 'dialog'
        settings=sglib_get_appdata('settings', struct() );
        settings=settings_dialog( setters, settings, 'title', 'SGLib settings', 'set_callback', @do_set );
    case 'save'
        settings_file=sglib_get_appdata('settings_file');
        settings=sglib_get_appdata('settings', struct() );
        write( settings_file, settings );
end

% set output var if requested
if nargout==0
    clear settings;
end
%



function do_set( settings )
setuserwaitmode( settings.userwaitmode );
assert_set_debug( settings.munit_jump_debugger );

settings_file=sglib_get_appdata( 'settings_file' );
write( settings_file, settings );
sglib_set_appdata( settings, 'settings' );



function write( filename, settings )
%save( filename, '-struct', 'settings', '-mat' );
write_struct_ascii( filename, settings );

function settings=read( filename )
%settings=load( filename, '-mat' );
settings=read_struct_ascii( filename );


function write_struct_ascii( filename, s )
fid=fopen( filename, 'w' );
fields=fieldnames(s);
for i=1:length(fields)
    name=fields{i};
    value=s.(name);
    switch class(value)
        case {'logical', 'double' }
            stringval=mat2str(value);
        case 'char'
            % mat2str works correctly for matlab version >= 7.4 but not
            % below (and I don't want to rely on that)
            stringval=strescape(value);
        otherwise
            error('Unsupported datatype %s for write_struct_ascii', class(value) );
    end
    fprintf( fid, '%s:%s\n', name, stringval );
end
fclose(fid);

function stringval=strescape(value)
bracket=false;
stringval='';
for i=1:size(value,1)
    if i>1
        stringval=[stringval ''';'''];
        bracket=true;
    end
    for j=1:size(value,2)
        c=value(i,j);
        if (c>=32 && c<=126) || (c>=161 && c<=255) 
            stringval=[stringval c];
        else
            stringval=[stringval sprintf(''' char(%d) ''',c)];
            bracket=true;
        end
    end
end

stringval=['''' stringval ''''];
if bracket
    stringval=['[' stringval ']'];
end

function s=read_struct_ascii( filename )
fid=fopen( filename, 'r' );
n=0;
s=struct();
while true
    n=n+1;
    str = fgetl(fid);
    if isnumeric(str); break; end
    str=strtrim(str);
    if isempty(str) || str(1)=='#'; continue; end
    x=strfind(str,':');
    if isempty(x); 
        warning( 'read_struct_ascii:format', 'Bad formatting in line %d of %s: %s', n, filename, str );
    else
        x=x(1);
    end
    name=str(1:x-1);
    value=eval(str(x+1:end));
    s.(name)=value;
end
fclose(fid);










