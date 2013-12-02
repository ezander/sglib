function mem=memstats(varargin)
% MEMSTATS Get memory statistics under GNU/Linux.
%   MEMSTATS retrieves statistics about memory usage of the current matlab
%   process. It works by reading the 'status' file, in the folder
%   corrsponding to the current process id in 'proc' file system. This is
%   very Linux specific and will not work in other operating systems.
%
% Example (<a href="matlab:run_example memstats">run</a>)
%   memstats()
%
% See also MEMORY

%   Elmar Zander
%   Copyright 2011, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options(varargin);
[mem,options]=get_option(options,'mem',struct([]));
[append,options]=get_option(options,'append',false);
check_unsupported_options(options,mfilename);

% get PID and determine name of memory status file in procfs
pid=getpid;
ppid=getppid(pid);

fields=readstatusfile(ppid);
if isempty(fields)
    return
end

% find out the index of the structure array to be updated
if append
    ind=length(mem)+1;
else
    ind=max(1,length(mem));
end
    
% scan fields for memory related stuff and update data structures
for i=1:length(fields{1})
    name=fields{1}{i}(1:end-1);
    if  strcmp( name(1:min(end,2)), 'Vm' )
        fullvalue=fields{2}{i};
        num=str2double(fullvalue(1:end-3));
        unit=fullvalue(end-1:end);
        switch lower(unit)
            case 'kb'; meminbytes=num*1024;
            case 'mb'; meminbytes=num*1024^2;
            case 'gb'; meminbytes=num*1024^3;
        end
        
        if isfield( mem, name ) && ~append
            mem(ind).(name)=max( mem(ind).(name), meminbytes );
        else
            mem(ind).(name)=meminbytes;
        end
                
        %fprintf( '%s: %d - %s: %d\n', name, num, unit, meminbytes );
    end
end


function ppid=getppid(pid)
% open the status file and read into fields (cell arrays)
ppid=-1;
fields=readstatusfile(pid);
if isempty(fields)
    return
end
    
% scan fields for memory related stuff and update data structures
for i=1:length(fields{1})
    name=fields{1}{i}(1:end-1);
    if strcmp( name, 'PPid' )
        fullvalue=fields{2}{i};
        ppid=str2double(fullvalue);
        return
    end
end

function fields=readstatusfile(pid)
% open the status file and read into fields (cell arrays)
file=fullfile(filesep, 'proc', num2str(pid,'%d'), 'status' );
[fid,message]=fopen( file, 'r' );
if fid==-1
    warning( 'sglib:memstats', 'Could not open file "%s" for getting memory information. Reason: %s', file, message );
    fields={};
    return;
end
fields=textscan( fid, '%s %s', 'Delimiter', '\t' );
fclose(fid);
