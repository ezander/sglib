function err=pce_error_est( x_i_alpha, I_x, y_i_alpha, I_y )
% PCE_ERROR_EST Computes the L2-error between two PCE expansions.
%   PCE_ERROR_EST Long description of pce_error_est.
%
% Example (<a href="matlab:run_example pce_error_est">run</a>)
%
% See also

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



% After the following few lines cindx and cindy will contain the indices in
% I_x and I_y that are the same in both (i.e. I_x(cindx,:)==I_y(cindy,:))
% and onlyx and onlyy will contain the indices that are only in I_x or I_y,
% respectively. 

if isequal(size(I_x),size(I_y)) && isequal(I_x, I_y)
    cindx=(1:size(I_x,1));
    cindy=cindx;
    onlyx=[];
    onlyy=[];
else
    if size(I_x,2)~=size(I_y,2)
        error( 'sglib:pce_error_est:size_mismatch', 'multiindices are defined on a different number of random variables' )
    end
    Mx=size(I_x,1);
    My=size(I_y,1);
    [cindy,cindx]=multiindex_find( I_x, I_y );
    onlyx=setdiff( (1:Mx)', cindx );
    onlyy=setdiff( (1:My)', cindy );
end


d2c=(x_i_alpha(:,cindx)-y_i_alpha(:,cindy)).^2*multiindex_factorial(I_x(cindx,:) );
d2x=x_i_alpha(:,onlyx).^2*multiindex_factorial(I_x(onlyx,:));
d2y=y_i_alpha(:,onlyy).^2*multiindex_factorial(I_y(onlyy,:));
err=sqrt(d2c+d2x+d2y);
