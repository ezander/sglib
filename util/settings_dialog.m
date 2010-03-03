function settings=settings_dialog( setters, settings, varargin )

options=varargin2options( varargin );
[control.title,options]=get_option( options, 'title', 'Settings' );
[control.spacing,options]=get_option( options, 'spacing', 1.8 );
[control.width,options]=get_option( options, 'width', 100 );
[control.indent,options]=get_option( options, 'indent', 3 );
[control.set_callback,options]=get_option( options, 'set_callback', [] );
check_unsupported_options( options, mfilename );

control.handles=struct();
control.setters=setters;
control.num_settings=length(setters);
control.numberlines=control.num_settings+2;
control.height=(control.numberlines+1)*control.spacing;
control.modal=nargout>0;
control.h_mainfig=create_figurewindow( control );

for i=1:control.num_settings
    control=create_setter( i, setters{i}, settings, control );
end

ypos=control.num_settings+2;
create_button( 0, ypos, 6, 'OK', @ok_button_callback, control );
create_button( 8, ypos, 10, 'Cancel', @cancel_button_callback, control );

set( control.h_mainfig, 'Visible', 'on' );
if control.modal
    uiwait( control.h_mainfig );
end


function control=create_setter( i, setter_info, settings, control )
ypos=i;

switch setter_info{1}
    case 'list'
        [name, default, option_list]=setter_info{2:4};
        if isfield( settings, name )
            value=settings.(name);
        else
            value=default;
        end
        create_text( 1, ypos,  30, name, control );
        h=create_popupmenu( 25, ypos, 30, option_list, value, default, control );
        control.handles.(name)=h;
    case 'bool'
        [name, default]=setter_info{2:3};
        if isfield( settings, name )
            value=settings.(name);
        else
            value=default;
        end
        create_text( 1, ypos,  30, name, control );
        h=create_popupmenu( 25, ypos, 30, {'true', 'false'}, 2-value, 2-default, control );
        control.handles.(name)=h;
    case 'text'
        [name, default]=setter_info{2:3};
        if isfield( settings, name )
            value=settings.(name);
        else
            value=default;
        end
        create_text( 1, ypos,  30, name, control );
        h=create_textinput( 25, ypos, 30, value, control );
        control.handles.(name)=h;
        
    otherwise
        error( 'util:settings_dialog:unknown_elem', 'Unsupported element: %s', setter_info{1} );
end



function store_values( control )
%disp('store_values( control );');
setters=control.setters;
for setter=setters
    setter_info=setter{1};
    switch setter_info{1}
        case 'list'
            [name, option_list]=setter_info{[2,4]};
            value=get( control.handles.(name), 'Value' );
            settings.(name)=option_list{ value };
        case 'bool'
            [name]=setter_info{2};
            value=get( control.handles.(name), 'Value' );
            settings.(name)=value==1;
        case 'text'
            [name]=setter_info{2};
            value=get( control.handles.(name), 'String' );
            settings.(name)=value;
        otherwise
            error( 'util:settings_dialog:unknown_elem', 'Unsupported element: %s', setter_info{1} );
    end
end
if ~isempty( control.set_callback )
    funcall( control.set_callback, settings, setters );
end




function cancel_button_callback(h, eventdata, control) %#ok
delete( control.h_mainfig );

function ok_button_callback(h, eventdata, control) %#ok
store_values( control );
delete( control.h_mainfig );


function h=create_textinput( x, y, w, value, control )
h = uicontrol( 'Parent', control.h_mainfig, 'Units','characters', 'HandleVisibility','callback', ...
    'Style','edit', ...
    'String', value, ...
    'HorizontalAlignment', 'left', ...
    'BackgroundColor', 'white', ...
    'Position',[control.indent+x,control.height-y*control.spacing,w,1.2]...
    );

function h=create_popupmenu( x, y, w, strings, current, default, control )
if ischar(current); current=strmatch( current, strings, 'exact'); end
if ischar(default); default=strmatch( default, strings, 'exact'); end
value=[current, default, 1];
h = uicontrol( 'Parent', control.h_mainfig, 'Units','characters', 'HandleVisibility','callback', ...
    'Style','popupmenu', ...
    'String', strings, ...
    'Value', value(1), ...
    'Position',[control.indent+x,control.height-y*control.spacing,w,1]...
    );

function h=create_button( x, y, w, text, callback, control )
h = uicontrol( 'Parent', control.h_mainfig, 'Units','characters', 'HandleVisibility','callback', ...
    'Style','pushbutton', ...
    'String', text, ...
    'Callback', {callback, control}, ...
    'Position',[control.indent+x,control.height-y*control.spacing,w,2]...
    );

function h=create_text( x, y, w, text, control )
h = uicontrol( 'Parent', control.h_mainfig, 'Units','characters', 'HandleVisibility','callback', ...
    'HorizontalAlignment', 'left', ...
    'Style','text', ...
    'String', text, ...
    'Position',[control.indent+x,-0.3+control.height-y*control.spacing,w,1]...
    );

function h=create_figurewindow( control )
h =  figure(...       % the main GUI figure
    'MenuBar','none', ...
    'Toolbar','none', ...
    'Units', 'characters', ...
    'HandleVisibility','callback', ...
    'Name', control.title, ...
    'NumberTitle','off', ...
    'Resize', 'off', ...
    'WindowStyle', 'modal', ...
    'Visible', 'off', ...
    'Color', get(0, 'defaultuicontrolbackgroundcolor'));

if control.modal
    set( h, 'WindowStyle', 'modal' );
end


pos=get( h, 'Position' );
pos(3)=100;
pos(4)=control.height;
set( h, 'Position', pos );

