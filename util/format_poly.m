function s=format_poly( p, varargin )
% FORMAT_POLY Format a polynomial for output.
%   S=FORMAT_POLY(P,VARARGIN) converts the polynomial P into formatted
%   string output. If no output arguments are specfied the polynomial is
%   printed immediately.
%
% Options:
%   tight: {true}, false
%     Suppress blanks around "+" and "-".
%   twoline: true, {false}
%     Use twoline output for exponents instead of caret.
%   symbol: {'x'}
%     Use specified symbol as variable name.
%   rats: true, {false}
%     Display coefficients as rational approximations (rats).
%
% Example (<a href="matlab:run_example format_poly">run</a>)
%   format_poly( [-1 2 3] );
%   % displays:
%   %   -x^2+2x+3
%
%   format_poly( [-1 2/3 0 4], 'twoline', true, 'tight', false, 'symbol', 's', 'rats', true );
%   % displays:
%   %     3       2
%   %   -s  + 2/3s  + 4
%
% See also

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

%#ok<*AGROW>

options=varargin2options( varargin );
[tight,options]=get_option( options, 'tight', true );
[twoline,options]=get_option( options, 'twoline', false );
[symbol,options]=get_option( options, 'symbol', 'x' );
[use_rats,options]=get_option( options, 'rats', false );
check_unsupported_options( options, mfilename );

if size(p,1)>1
    s=cell(1,size(p,1));
    for i=1:size(p,1);
        s{i}=format_poly( p(i,:), varargin{:} );
    end
else
    s='';
    first=true;
    for i=length(p):-1:1
        a=p(length(p)+1-i);
        if a~=0
            if a>0
                if ~first;
                    if tight; s=[s '+']; else s=[s ' + ']; end 
                end
            else
                if ~first;
                    if tight; s=[s '-']; else s=[s ' - ']; end 
                else
                    s='-';
                end
            end
            if ~(abs(a)==1 && i>=2)
                if use_rats
                    s=[s strtrim(rats(abs(a)))];
                else
                    s=[s num2str(abs(a))];
                end
            end
            switch(i)
                case 1
                    % nothing
                case 2
                    s=[s symbol];
                otherwise
                    s=[s symbol '^' num2str(i-1) ];
            end
            first=false;
        end
    end
    if first
        s='0';
    end
    if twoline
        ns=[''; ''];
        line=2;
        j=1;
        for i=1:length(s)
            switch s(i)
                case '^'
                    line=1;
                    continue;
                case {'+','-',' '}
                    line=2;
            end
            ns(line,j)=s(i);
            ns(3-line,j)=' ';
            j=j+1;
        end
        s=ns;
    end
end

if nargout==0
    if iscell(s)
        for i=1:length(s); disp(s{i}); end
    else
        disp(s);
    end
    clear s;
end
