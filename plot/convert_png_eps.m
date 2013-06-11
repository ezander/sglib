function [res,epsfilename,msgs]=convert_png_eps(inoutfilename, varargin)
% CONVERT_PNG_EPS Short description of convert_png_eps.
%   CONVERT_PNG_EPS Long description of convert_png_eps.
%
% Example (<a href="matlab:run_example convert_png_eps">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options(varargin);
[dpi,options]=get_option(options,'dpi',300); %#ok<ASGLU>
[pslevel,options]=get_option(options,'pslevel','2'); %#ok<ASGLU>
[quiet,options]=get_option(options,'quiet',false);
[extra_params,options]=get_option(options,'extra_params','');
check_unsupported_options(options,mfilename);

[path,filename]=fileparts(inoutfilename);
pngfilename=fullfile(path,[filename,'.png']); %#ok<NASGU>
% TODO: mean hack since sam2p currently does not work for me with 
% png images
bmpfilename=fullfile(path,[filename,'.bmp']); %#ok<NASGU>
pngfilename=bmpfilename;
epsfilename=fullfile(path,[filename,'.eps']);

if quiet
    extra_params=['-j:quiet ', extra_params]; %#ok<NASGU>
end

cmd=strvarexpand('convert $pngfilename$ -trim $pngfilename$' );
[res,msgs]=system( cmd );

cmd=strvarexpand('sam2p $extra_params$ -m:dpi:$dpi$ -ps:$pslevel$ -- $pngfilename$ $epsfilename$' );
[res,msgs]=system( cmd );
if res
    switch res
        case 2; cause=sprintf( 'Input file ''%s'' could not be read or output file ''%s'' be written.', pngfilename, epsfilename );
        case 127; cause='Converter program ''sam2p'' was not found on the path';
        otherwise; cause=sprintf( 'Unknown (%d).', res );
    end
    disp( msgs );
    warning( 'sglib:convert_png_eps:syserr', 'Error executing command: %s\nCause: %s', cmd, cause );
end
delete(bmpfilename)