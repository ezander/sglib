function psfrag_info=psfrag_format( axes_h, varargin )

ticks_default.replace=true;
ticks_default.tag_format='?t:%g';
ticks_default.tex_format='%g';
ticks_default.fontsize=0;
ticks_default.pos='cc';

xticks_options=ticks_default;
xticks_options.tag_format='xt:%g';
yticks_options=ticks_default;
yticks_options.tag_format='yt:%g';
zticks_options=ticks_default;
zticks_options.tag_format='zt:%g';

%xt=format_ticklabels( axes_h, 'x', xticks_options );
%yt=format_ticklabels( axes_h, 'y', yticks_options );
%zt=format_ticklabels( axes_h, 'z', zticks_options );
xl=format_label( axes_h, 'x', 'xl:%s', '%s' );
yl=format_label( axes_h, 'y', 'yl:%s', '%s' );
zl=format_label( axes_h, 'z', 'zl:%s', '%s' );

ti=format_title( axes_h, 'ti:%s', '%s' );

lg=format_legend( axes_h, 'lg:%s', '%s' );

tx=format_text( axes_h, 'tx:%s', '%s' );



xt=format_ticklabels( axes_h, 'x', 'xt:%g', '%g' );
yt=format_ticklabels( axes_h, 'y', 'yt:%g', '%g' );
zt=format_ticklabels( axes_h, 'z', 'zt:%g', '%g' );

xl=format_label( axes_h, 'x', 'xl:%s', '%s' );
yl=format_label( axes_h, 'y', 'yl:%s', '%s' );
zl=format_label( axes_h, 'z', 'zl:%s', '%s' );

ti=format_title( axes_h, 'ti:%s', '%s' );

lg=format_legend( axes_h, 'lg:%s', '%s' );

tx=format_text( axes_h, 'tx:%s', '%s' );

psfrag_info=celljoin( xt, yt, zt, xl, yl, zl, ti, lg, tx );


function psfrag_info=format_title( axes_h, tag_format, tex_format )
% FORMAT_TITLE Formats a title text object belonging to an axis object.
title_h=get( axes_h, 'Title' );
psfrag_info=format_handle( title_h, tag_format, tex_format );

function psfrag_info=format_label( axes_h, xyz, tag_format, tex_format )
% FORMAT_LABEL Formats a label text object belonging to an axis object.
label_h=get( axes_h, [upper(xyz) 'Label'] );
psfrag_info=format_handle( label_h, tag_format, tex_format );

function psfrag_info=format_legend( axes_h, tag_format, tex_format )
% FORMAT_TEXT Formats all text objects in a legend belonging to an axis object.
legend_h=legend( axes_h );
handles=findall(legend_h, 'type', 'text');
psfrag_info=format_handles( handles, tag_format, tex_format );

function psfrag_info=format_text( axes_h, tag_format, tex_format )
% FORMAT_TEXT Formats all text objects descendant from some axis object.
handles=findall(axes_h, 'type', 'text');
psfrag_info=format_handles( handles, tag_format, tex_format );

function psfrag_info=format_ticklabels( axes_h, xyz, tag_format, tex_format )
% FORMAT_TICKLABELS Formats all the ticklables of some axis.
psfrag_info={};
labels={};
c=upper(xyz);
for t=get( axes_h, [c 'Tick'] )
    labels=cellappend( labels, sprintf(tag_format, t) );
    psfrag_info=cellappend( psfrag_info, {sprintf(tag_format, t), ...
                                          sprintf(tex_format, t)} );
end
set( axes_h, [c 'TickLabel'], labels )


function tag_handle( handle )
% TAG_HANDLE Tags an object so its not processed twice
set( handle, 'Tag', 'psfrag' );

function bool=is_handle_tagged( handle )
% IS_HANDLE_TAGGED Returns wether an object is already tagged.
bool=strcmp( 'psfrag', get( handle, 'Tag' ) );


function psfrag_info=format_handle( h, tag_format, tex_format )
% FORMAT_HANDLE Formats one text objects passed in by handle.
psfrag_info={};
if is_handle_tagged(h); return; end
label=get(h, 'String' );
if isempty(strtrim(label) ); return; end
tag_label=sprintf( tag_format, tex_escape(label));
tex_label=sprintf( tex_format, label);
psfrag_info={{tag_label, tex_label}};
set( h, 'String', tag_label );
set( h, 'Interpreter', 'none' );
tag_handle( h );

function psfrag_info=format_handles( handles, tag_format, tex_format )
% FORMAT_HANDLES Formats all text objects passed in by their handle.
psfrag_info={};
for i=1:length(handles)
    info=format_handle( handles(i), tag_format, tex_format);
    psfrag_info=celljoin( psfrag_info, info );
end


function list=cellappend( list, item )
% CELLAPPEND Append an item to a cell array.
if ~isempty(item); list={list{:}, item}; end


function list=celljoin(varargin)
% CELLJOIN Join an arbitrary number of cell arrays into one.
list={};
for i=1:length(varargin)
    list={list{:}, varargin{i}{:} };
end


function estr=tex_escape(str)
% TEX_ESCAPE Escapes a string such that it can be used as PSFrag label.
estr=[];
for x=str
    switch x
        case {'{', '}', '$', '\', '&', '%', '^', '_', ' '} % do nothing, ignore
        case '#'
            estr=[estr 'num-'];
        case '~'
            estr=[estr '-'];
        otherwise
            estr=[estr x];
    end
end





