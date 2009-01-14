function publish_demos
clear

options.format='latex';
options.stylesheet='';
options.outputDir='tex';
options.imageFormat='epsc2';
options.figureSnapMethod='print';
options.useNewFigure=true;
options.maxHeight=[];
options.maxWidth=[];
options.showCode=true;
options.evalCode=true;
options.catchError=true;
options.stopOnError=true;
options.createThumbnail=true;

read_now=true;
%publish_demo( 'demo_distributions', read_now, options );
%publish_demo( 'demo_kl_expand', read_now, options );
publish_demo( 'presentation_oberseminar', read_now, options );

function publish_demo( file, read_now, options )
publish( file, options );
system( sprintf( 'cd tex && latex %s && dvips %s && ps2pdf %s.ps && cp %s.ps %s.pdf ..', file, file, file, file, file ) );

if read_now
    system( sprintf( 'gv %s.pdf &', file ) );
end

    