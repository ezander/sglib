function sglib_reports( type )
dirs={'.', 'util', 'plot', 'munit', 'simplefem', 'demo', 'doc' };

switch type
    case 'mlint'
        mlint_reports( dirs );
    case 'contents'
        contents_reports( dirs );
    case 'help'
        help_reports( dirs );
    otherwise
        error( 'unknown report type %s', type );
end


function help_reports( dirs )
do_reports( dirs, {@helprpt, {'dir'}} );

function contents_reports( dirs )
do_reports( dirs, {@contentsrpt} );

function mlint_reports( dirs )
do_reports( dirs, {@mlintrpt, {'dir'}} );

function do_reports( dirs, func )
for i=1:length(dirs)
    s=funcall( func, dirs{i} );
    display_html( s );
end

function display_html( s )
sOut = [s{:}];
[stat,h1]=web(['text://' sOut],'-noaddressbox');
while true
    pause(0.05);
    try
        x=get(h1,'CurrentLocation');
    catch
        break
    end
end
