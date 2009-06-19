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

if exist( 'we_dont_need_that_stuff_yet', 'var' )
    setters={ setters{:}, {'list', 'shading', 'faceted', m_shading_types } };
    setters={ setters{:}, {'list', 'solver_show_message', 'error', m_solver_showmessage } };
end

% do action
appdata=getappdata( 0, 'sglib' );
switch action
    case 'load'
        try
            appdata.settings=load( appdata.settings_file, '-mat' );
        catch
            appdata.settings=struct();
        end
        % for loop setting all defaults on non existent fields
        for i=1:length(setters)
            setter=setters{i};
            if ~isfield( appdata.settings, setter{2} )
                appdata.settings.(setter{2})=setter{3};
            end
        end
    case 'dialog'
        appdata.settings=settings_dialog( setters, appdata.settings, 'title', 'SGLib settings', 'set_callback', @do_set );
    case 'save'
        save( appdata.settings_file, '-struct', appdata.settings, '-mat' );
end

% set output var if requested
if nargout>0
    settings=appdata.settings;
end
% 



function do_set( settings )
setuserwaitmode( settings.userwaitmode );
assert_set_debug( settings.munit_jump_debugger );

appdata=getappdata( 0, 'sglib' );
appdata.settings=settings;
save( appdata.settings_file, '-struct', 'settings', '-mat' );
setappdata( 0, 'sglib', appdata );
