function mat=matrix_gallery( name, varargin )
% MATRIX_GALLERY Short description of matrix_gallery.
%   MATRIX_GALLERY Long description of matrix_gallery.
%
% Example (<a href="matlab:run_example matrix_gallery">run</a>)
%
% See also GALLERY, TRIDIAGONAL

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

if ismatlab
  mat=gallery( name, varargin{:} );
elseif strcmp(name,'tridiag')
  n=varargin{1};
  a=varargin{2};
  b=varargin{3};
  c=varargin{4};
  mat=a*diag(ones(1,n-1),1)+b*diag(ones(1,n),0)+c*diag(ones(1,n-1),-1);
elseif strcmp(name,'randcorr')
  % this is not quite what the matlab function does
  n=varargin{1};
  X=rand(n);
  mat=X'*X;
  mat=0.5*(mat+mat');
else
  error( 'tensor:unittest:internal', 'Unknown gallery matrix type: %s', name );
end
