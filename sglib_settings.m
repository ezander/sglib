function sglib_settings


m_solver_showmessage = {'never', 'always', 'error', 'nooutputarg'};
m_shading_types = {'none', 'faceted', 'interp'};
m_userwaitmodes = {'keyboard','mouse','continue'};

setters={};
setters={ setters{:}, {'list', 'userwaitmode', m_userwaitmodes, 'mouse' } };
setters={ setters{:}, {'list', 'shading', m_shading_types, 'faceted' } };
setters={ setters{:}, {'list', 'solver_show_message', m_solver_showmessage, 'error' } };

% should load from file if exists, otherwise set defaults
settings=getappdata( 0, 'sglib' );
try
    settings=load( 'sglib.settings', '-mat' );
end
settings.userwaitmode=m_userwaitmodes{ setuserwaitmode('getmode') };

settings_dialog( setters, settings, 'title', 'SGLib settings', 'set_callback', @do_set );

function do_set( settings )
setuserwaitmode( settings.userwaitmode );
setappdata( 0, 'sglib', settings );
save( 'sglib.settings', '-struct', 'settings', '-mat' );
