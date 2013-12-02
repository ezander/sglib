function show_pce_pdf_at( pos, els, r_i_alpha, I_r, x, varargin)
% SHOW_PCE_PDF_AT Short description of show_pce_pdf_at.
%   SHOW_PCE_PDF_AT Long description of show_pce_pdf_at.
%
% Example (<a href="matlab:run_example show_pce_pdf_at">run</a>)
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
[N,options]=get_option( options, 'N', 2e4 );
check_unsupported_options(options, mfilename);

colors='bkrcmyg';
Px=point_projector( pos, els, x );
r_x_alpha=Px*r_i_alpha;
for i=1:size(r_x_alpha,1)
    [y,x]=pce_pdf( [], r_x_alpha(i,:), I_r, 'N', N);
    plot(x,y,colors(i)); hold on;
end
hold off;



