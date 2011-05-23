function I=multiindex2(m,p)
% MULTIINDEX2 Short description of multiindex2.
%   MULTIINDEX2 Long description of multiindex2.
%
% Example (<a href="matlab:run_example multiindex2">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2011, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

use_sparse=true;

% initialization for m=1
I=(0:p)';
q=I;
k=(1:p+2)';

for j=2:m
    In=zeros(0,j);
    if use_sparse
        In=sparse(In);
    end
    kn=1;
    qn=zeros(0,1);
    
    for r=0:p
        s=(k(1):(k(r+2)-1))';
        In=[In; [I(s,:), r-q(s)]];
        kn=[kn; size(In,1)+1];
        qn=[qn; r*ones(size(s))];
    end
    
    I=In;
    k=kn;
    q=qn;
end
