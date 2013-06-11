function paper_frauenfelder(varargin)
% PAPER_FRAUENFELDER Some tests related to the paper by Frauenfeld et al.
%   Ref: cmame 194 205-228

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


page209

function page209
% Recreated the figures on page 209 of kl decay in different dimensions

clf
fig=1;
for d=1:2:3
    if d==1
        l=15;
        N=300;
        L=100;
    else
        l=501;
        N=2000;
        L=800;
        disp('This may take a while...');
    end
    
    n=ceil(N^(1/d));
    xd=repmat( linspace(-1,1,n), d, 1);
    wd=repmat( ones(1,n), d, 1);
    x=tensor_mesh( num2cell(xd, 2 ), num2cell(wd, 2 ) );

    V_a={@gaussian_covariance, {1/sqrt(10),1}};
    C_a=covariance_matrix( x, V_a );

    [v, sigma]=kl_solve_evp( C_a, [], L ); %#ok<ASGLU>
    sigma_all=sigma;
    
    is=1:l;
    subplot( 2, 1, fig); semilogy(is-1, kl_remainder(sigma_all,l)); grid on
    fig=fig+1;
end

%%
function foo
x=create_mesh_1d( -1, 1, 300 );
x=create_mesh_2d_rect( 4 );

N=10;
x=tensor_mesh( {linspace(0,1,N), linspace(0,1,N), linspace(0,1,N)}, {ones(1,N), ones(1,N), ones(1,N)} );

V_a={@gaussian_covariance, {1/sqrt(10),1}};
C_a=covariance_matrix( x, V_a );

C_a=0.5*(C_a+C_a');
[v, sigma]=kl_solve_evp( C_a, [], 160 );
[v2, sigma2]=kl_solve_evp( C_a, [], 160, 'use_sparse', false );
sigma=sigma(1:80)

subplot( 2,1,1); semilogy(abs(sigma)); grid on
subplot( 2,1,2); semilogy(abs(sigma2)); grid on
is=1:30; N=600; n=length(is)
subplot( 2,1,2); plot3( repmat((1:N)',1,n), repmat(1:n, N,1), 10*v(:,is)  )
view( -9.5, 80 );


%for i=
%sr=
plot( 1:40, sigma(1:40), 1:40, sigma2(1:40) )
semilogy( 1:40, sigma(1:40), 1:40, sigma2(1:40) )









%%
function s=kl_remainder(sigma,n)
s=sum(sigma.^2)-[0 cumsum(sigma.^2)];
s=s(1:n)/sum(sigma.^2);

