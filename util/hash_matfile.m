function [status, hash]=hash_matfile( matfile )
% HASH_MATFILE Compute hash value of MAT file.
%   [STATUS, HASH]=HASH_MATFILE( MATFILE ) compute a hash value of the MAT
%   file MATFILE. The hash value is returned in the variable HASH. If an
%   error occurred STATUS will contain a nonzero value, otherwise it will
%   be zero. Note that for this command the command 'dd' and 'sha1sum' must
%   be available on the OS level and the PATH must be set so that they are
%   callable.
%
% Example (<a href="matlab:run_example hash_matfile">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2014, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

% The first part 'dd ... |' strips the first 80 bytes of the file (input
% blocksize ibs=80, skip 1) in which matlab writes also the date the file
% was written, which would make the hash value not only depend on the data
% in the MAT file, but also on the date and time it was written.
cmd=['dd if=' matfile ' ibs=80 skip=1 obs=512 status=noxfer 2>/dev/null | sha1sum'];
[status, result]=system( cmd );
if status
    hash='';
else
    hash=strtrim(result(1:40));
end
