function s=tensor_modes(T)
% TENSOR_SV Short description of tensor_sv.
%   TENSOR_SV Long description of tensor_sv.
%
% Example (<a href="matlab:run_example tensor_sv">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

[Q1,R1]=qr(T{1},0); % matlab seems to ignore the ,0 so with only one output
[Q2,R2]=qr(T{2},0); % 

s=svd(R1*R2');
