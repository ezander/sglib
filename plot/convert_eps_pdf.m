function [res,pdffilename,msgs]=convert_eps_pdf(inoutfilename, varargin)
% CONVERT_EPS_PDF Short description of convert_eps_pdf.
%   CONVERT_EPS_PDF Long description of convert_eps_pdf.
%
% Example (<a href="matlab:run_example convert_eps_pdf">run</a>)
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
[extra_params,options]=get_option(options,'extra_params','');
check_unsupported_options(options,mfilename);

[path,filename]=fileparts(inoutfilename);
epsfilename=fullfile(path,[filename,'.eps']); %#ok<NASGU>
pdffilename=fullfile(path,[filename,'.pdf']);

cmd=strvarexpand('epstopdf $extra_params$ $epsfilename$ --outfile=$pdffilename$' );
[res,msgs]=system( cmd );
if res
    switch res
        case 2; cause=sprintf( 'Input file ''%s'' could not be read or output file ''%s'' be written.', epsfilename, pdffilename );
        case 127; cause='Converter program ''epstopdf'' was not found on the path';
        otherwise; cause=sprintf( 'epstopdf returned an unknown error (%d).', res );
    end
    disp( msgs );
    warning( 'sglib:convert_eps_pdf:syserr', 'Error executing command: %s\nCause: %s', cmd, cause );
end
