function psfrag_info=psfrag_format( axes_h, varargin )

if strcmp( get(axes_h, 'type' ), 'figure' )
    axes_h=findobj( axes_h, 'type', 'axes', 'tag', '' );
end

general_default.replace=false;
general_default.replace=true;
general_default.fontsize='\psflabelfontsize';
general_default.orient='cc';

ticks_default=general_default;
ticks_default.tag_format='??:%g';
ticks_default.tex_format='%g';
ticks_default.fontsize='\psftickfontsize';

xticks_options=setfields( ticks_default, 'tag_format', 'xt:%g', 'orient', 'tc' );
yticks_options=setfields( ticks_default, 'tag_format', 'yt:%g', 'orient', 'cr' );
zticks_options=setfields( ticks_default, 'tag_format', 'zt:%g', 'orient', 'cr' );

xt=format_ticklabels( axes_h, 'x', xticks_options );
yt=format_ticklabels( axes_h, 'y', yticks_options );
zt=format_ticklabels( axes_h, 'z', zticks_options );

label_default=general_default;
label_default.tag_format='??:%s';
label_default.tex_format='%s';
label_default.fontsize='\psflabelfontsize';

xlabel_options=setfields( label_default, 'tag_format', 'xl:%s', 'orient', 'tc' );
ylabel_options=setfields( label_default, 'tag_format', 'yl:%s', 'orient', 'cr' );
zlabel_options=setfields( label_default, 'tag_format', 'zl:%s', 'orient', 'cr' );
title_options =setfields( label_default, 'tag_format', 'tt:%s', 'orient', 'Bc' );
legend_options=setfields( label_default, 'tag_format', 'lg:%s', 'orient', 'lc', 'fontsize', '\psflegendfontsize' );
text_options  =setfields( label_default, 'tag_format', 'tx:%s', 'orient', 'cc', 'fontsize', '\psftextfontsize' );


xl=format_label( axes_h, 'x', xlabel_options );
yl=format_label( axes_h, 'y', ylabel_options );
zl=format_label( axes_h, 'z', zlabel_options );
tt=format_title( axes_h, title_options );
lg=format_legend( axes_h, legend_options );
tx=format_text( axes_h, text_options );


psfrag_info=celljoin( xt, yt, zt, xl, yl, zl, tt, lg, tx );


function psfrag_info=format_title( axes_h, options )
% FORMAT_TITLE Formats a title text object belonging to an axis object.
title_h=get( axes_h, 'Title' );
psfrag_info=format_handle( title_h, options );

function psfrag_info=format_label( axes_h, xyz, options )
% FORMAT_LABEL Formats a label text object belonging to an axis object.
label_h=get( axes_h, [upper(xyz) 'Label'] );
psfrag_info=format_handle( label_h, options );

function psfrag_info=format_legend( axes_h, options )
% FORMAT_TEXT Formats all text objects in a legend belonging to an axis object.
legend_h=legend( axes_h );
handles=findobj(legend_h, 'type', 'text');
psfrag_info=format_handles( handles, options );

function psfrag_info=format_text( axes_h, options )
% FORMAT_TEXT Formats all text objects descendant from some axis object.
handles=findall(axes_h, 'type', 'text');
psfrag_info=format_handles( handles, options );

function psfrag_info=format_ticklabels( axes_h, xyz, options )
% FORMAT_TICKLABELS Formats all the ticklables of some axis.
psfrag_info={};
if ~options.replace; return; end
labels={};
c=upper(xyz);
for t=get( axes_h, [c 'Tick'] )
    labels=cellappend( labels, sprintf(options.tag_format, t) );
    psfrag_info=cellappend( psfrag_info, {sprintf(options.tag_format, t), ...
                                          sprintf(options.tex_format, t), ...
                                          options.fontsize, ...
                                          options.orient} );
end
set( axes_h, [c 'TickLabel'], labels )


function tag_handle( handle )
% TAG_HANDLE Tags an object so its not processed twice
set( handle, 'Tag', 'psfrag' );

function bool=is_handle_tagged( handle )
% IS_HANDLE_TAGGED Returns wether an object is already tagged.
bool=strcmp( 'psfrag', get( handle, 'Tag' ) );


function psfrag_info=format_handle( h, options )
% FORMAT_HANDLE Formats one text objects passed in by handle.
psfrag_info={};
if is_handle_tagged(h); return; end
label=get(h, 'String' );
if isempty(strtrim(label) ); return; end
tag_handle( h );
if ~options.replace; return; end

tag_label=sprintf( options.tag_format, tex_escape(label));
tex_label=sprintf( options.tex_format, label);
psfrag_info={{tag_label, tex_label, options.fontsize, options.orient}};
set( h, 'String', tag_label );
set( h, 'Interpreter', 'none' );

function psfrag_info=format_handles( handles, options )
% FORMAT_HANDLES Formats all text objects passed in by their handle.
psfrag_info={};
for i=1:length(handles)
    info=format_handle( handles(i), options );
    psfrag_info=celljoin( psfrag_info, info );
end


function list=cellappend( list, item )
% CELLAPPEND Append an item to a cell array.
if ~isempty(item); list=[list, {item}]; end


function list=celljoin(varargin)
% CELLJOIN Join an arbitrary number of cell arrays into one.
list={};
for i=1:length(varargin)
    list={list{:}, varargin{i}{:} }; %#ok<CCAT>
end

function obj=setfields( obj, varargin )
for i=1:2:length(varargin)
    obj.(varargin{i})=varargin{i+1};
end


function estr=tex_escape(str)
% TEX_ESCAPE Escapes a string such that it can be used as PSFrag label.
estr=[];
for x=str
    switch x
        case {'{', '}', '$', '\', '&', '%', '^', '_', ' '} % do nothing, ignore
        case '#'
            estr=[estr 'num-']; %#ok<AGROW>
        case '~'
            estr=[estr '-']; %#ok<AGROW>
        otherwise
            estr=[estr x]; %#ok<AGROW>
    end
end
