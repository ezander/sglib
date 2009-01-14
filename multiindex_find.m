function ind=multiindex_find( I_r, alpha )
% MULTIINDEX_FIND Find a multiindex in a list of indices.
%   IND=MULTIINDEX_FIND( I_R, ALPHA ) tries to find the multiindex ALPHA in
%   the list of multiindices given by I_R. Returned is a logical array
%   containing a one (i.e. logical true) at each position where ALPHA was
%   found (usually and hopefully only one). If you want to have a real
%   index you can use FIND on the result, i.e. FIND(IND), but you don't
%   need that for indexing.
%
%   Note: This function does not guarantee orthogonality of eigenfunctions
%   or uncorrelatedness of random variables like the KL. It just unpacks
%   the information contained in R into the format used by the KL. However,
%   if the tensor was truncated in a "KL-compatible" way, the result should
%   be the same.
%
% Example:
%   I=multiindex(5,3);
%   alpha=[0 1 0 0 2]; disp(alpha);
%   ind=multiindex_find( I, alpha );
%   disp(find(ind));
%   disp(I(ind,:));
%
% See also MULTIINDEX, FIND

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


m=size(I_r,1);
%ind=sum(abs(I_r-repmat(alpha,m,1)),2)==0;
ind=all(I_r==repmat(alpha,m,1),2);

% % Some ideas about Goedelization I had. This may work better when there
% % are more than one multiindex to search for. But this is currently not
% % needed. Sometimes it's incredible through which pains you have to go to
% % something reasonably fast in matlab...
% n=size(I_r,2);
% lp=log(prime_list(n));
% goedel_I=round(exp(I_r*lp'));
% goedel_alpha=round(exp(alpha*lp'));
% ind=(goedel_I==goedel_alpha);
% 
% function p=prime_list(n)
% l=n;
% p=primes(l);
% while length(p)<n
%     l=2*l;
%     p=primes(l);
% end
% p=p(1:n);
