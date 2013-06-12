function num=filedate( file )
% FILEDATE Returns the modification date of the file as double or -infty.
%   NUM=FILEDATE( FILE ) returns in NUM the modification date of FILE if
%   FILE exists or -INF otherwise. Makes testing for whether an update is
%   needed easy.
%
% Example (<a href="matlab:run_example filedate">run</a>)
%   num1=filedate( 'create.m' );
%   num2=filedate( 'result.mat' );
%   if num1>num2; eval( 'create' ); end
%
% See also DIR, DATENUM, NEEDS_UPDATE

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if ~exist(file,'file')
    num=-inf;
else
    x=dir( file );
    if isfield(x, 'datenum')
        num=x.datenum;
    else
        num=datenum(x.date);
    end
end
