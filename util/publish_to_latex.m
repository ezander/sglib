function publish_to_latex( file, read_now, varargin )

options=varargin2options( varargin{:} );
[puboptions.format,options]=get_option( options, 'format', 'latex' );
[puboptions.stylesheet,options]=get_option( options, 'stylesheet', '');
[puboptions.outputDir,options]=get_option( options, 'outputDir', 'tex' );
[puboptions.imageFormat,options]=get_option( options, 'imageFormat', 'epsc2' );
[puboptions.figureSnapMethod,options]=get_option( options, 'figureSnapMethod', 'print' );
[puboptions.useNewFigure,options]=get_option( options, 'useNewFigure', true );
[puboptions.maxHeight,options]=get_option( options, 'maxHeight', [] );
[puboptions.maxWidth,options]=get_option( options, 'maxWidth', [] );
[puboptions.showCode,options]=get_option( options, 'showCode', true );
[puboptions.evalCode,options]=get_option( options, 'evalCode', true );
[puboptions.catchError,options]=get_option( options, 'catchError', true );
[puboptions.stopOnError,options]=get_option( options, 'stopOnError', true );
[puboptions.createThumbnail,options]=get_option( options, 'createThumbnail', true );
check_unsupported_options( options, mfilename );

publish( file, puboptions );
system( sprintf( 'cd tex && latex %s && dvips %s && ps2pdf %s.ps && cp %s.ps %s.pdf ..', file, file, file, file, file ) );

if read_now
    system( sprintf( 'gv %s.pdf &', file ) );
end
