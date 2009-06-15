function sglib_settings

m_shading_types = {'none', 'faceted', 'interp'};
m_userwaitmodes = {'keyboard','mouse','continue'};

setters={};
setters={ setters{:}, {'list', 'userwaitmode', m_userwaitmodes, 'mouse' } };
setters={ setters{:}, {'list', 'shading', m_shading_types, 'faceted' } };

settings.userwaitmode=m_userwaitmodes{ setuserwaitmode('getmode') };
settings.shading='none';

settings_dialog( setters, settings, 'title', 'SGLib settings', 'set_callback', @do_set );

function do_set( settings )
setuserwaitmode( settings.userwaitmode );

