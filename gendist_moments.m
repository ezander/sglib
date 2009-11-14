function [mean,var,skew,kurt]=gendist_moments(dist, params, shift, scale)
% GENDIST_MOMENTS Short description of gendist_moments.
%   GENDIST_MOMENTS Long description of gendist_moments.
%
% Example (<a href="matlab:run_example gendist_moments">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Comuting
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if ~exist('shift', 'var' ) || isempty(shift)
    shift=0;
end
if ~exist('scale', 'var' ) || isempty(scale)
    scale=1;
end
if ~exist('params', 'var' ) 
    params={};
end

n=max(nargout,1);
m=cell(1,n);
[m{:}]=feval( [dist '_moments'], params{:} );

% Apply scale and shift to the moments. Note: since we are using not the
% raw but the normalized central moments we only have to shift the mean by
% 'shift' and multiply the variance by 'scale^2', while the higher moments
% like skewness and kurtosis excess are unaffected.
mean=m{1}+shift;
if nargout>=2
    var=m{2}*scale^2;
end
if nargout>=3
    skew=m{3};
end
if nargout>=4
    kurt=m{4};
end
