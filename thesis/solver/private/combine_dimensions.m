function [U,I]=combine_dimensions(T,I1,I2,varargin)
% COMBINE_DIMENSIONS Short description of combine_dimensions.
%   COMBINE_DIMENSIONS Long description of combine_dimensions.
%
% Example (<a href="matlab:run_example combine_dimensions">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options(varargin);
[order,options]=get_option( options, 'order', false );
check_unsupported_options( options );


%% fake
if nargin==0
    % should go into unittest
    I1=multiindex( 2, 2 )
    I2=multiindex( 3, 1 )
    m1=size(I1,1);
    m2=size(I2,1);
    order=true;
    T={rand(50,5),rand(m1,5), rand(m2,5)};
end

%%

m1=size(I1,1);
m2=size(I2,1);

%The following lines have the same effect as
%  revkron( I1, ones(m2,1) )
%  revkron( ones(m1,1), I2 )
% but should be faster
I12=repmat( I1, m2, 1 );
I21=reshape( repmat( I2', m1, 1 ), [], m1*m2 )';
I=[I12 I21];

R=size(T{1},2);
U{1}=T{1};
U{2}=zeros(m1*m2,R);
for i=1:R
    U{2}(:,i)=revkron(T{2}(:,i),T{3}(:,i));
end



if order
    [I,ind]=sortrows(I);
    U{2}=U{2}(ind,:);
end

if nargin==0
    % should go into unittest
    for n=1:10
        i=floor(rand*m1+1);
        j=floor(rand*m2+1);
        %k=i+(j-1)*m1;
        k=find( multiindex_find( I, [I1(i,:) I2(j,:)] ) );
        
        [I1(i,:) I2(j,:) T{2}(i,:).*T{3}(j,:);
            I(k,:) U{2}(k,:)]
    end
end

%multiindex_find
