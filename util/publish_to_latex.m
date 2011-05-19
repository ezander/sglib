function publish_to_latex( file, read_now, varargin )
% PUBLISH_TO_LATEX Uses the matlab publishing with options set up for Latex.
%   PUBLISH_TO_LATEX( FILE, READ_NOW, OPTIONS ) publishes FILE with all
%   options set up for Latex. Further it set the wait mode to 'continue'
%   and resets it later to its previous state. Then, it calls the Latex
%   toolchain (latex->dvips->ps2pdf) to produce PDF output. Finally, if
%   READ_NOW is true, it invokes a viewer on the produced PDF file.
%
% Options:
%   Please see source code for options. Most of them are just passed along
%   to PUBLISH.
%
% Example (<a href="matlab:run_example publish_to_latex">run</a>)
%   publish_to_latex( 'odedemo', true );
%
% See also PUBLISH, USERWAIT, SETUSERWAITMODE

%   Elmar Zander
%   Copyright 2007, 2009, Institute of Scientific Computing, TU Braunschweig.
%   $Id$
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


% parse options
options=varargin2options( varargin );
[puboptions.format,options]=get_option( options, 'format', 'latex' );
[puboptions.stylesheet,options]=get_option( options, 'stylesheet', '');
[puboptions.outputDir,options]=get_option( options, 'outputDir', 'tex' );
[puboptions.imageFormat,options]=get_option( options, 'imageFormat', 'epsc2' );
%[puboptions.imageFormat,options]=get_option( options, 'imageFormat', 'pdf' );
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

% store userwait mode and set it to 'continue' (publish shouldn't wait for
% the user to press any key)
[mode,msg,func]=setuserwaitmode();
setuserwaitmode('continue');
% publish the file
publish( file, puboptions );
% restore old userwait mode
setuserwaitmode(mode,msg,func);

% make system call to 'tex' the generated file and copy ps/pdf to current
% directory
system( sprintf( 'cd tex && latex %s && dvips %s && ps2pdf %s.ps && cp %s.ps %s.pdf ..', file, file, file, file, file ) );

% show the file
if nargin>=2 && read_now
    open( [file, '.pdf'] );
end
