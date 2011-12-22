function test_estimate_truncations

if fasttest('get')
    model_small_easy
else
    %model_large_easy
    model_medium_easy
end

define_geometry
cache_script discretize_model
cache_script setup_equation

trunc.eps = 1e-4;
trunc.k_max=1000;
tr_func={@tensor_truncate_fixed, {trunc}, {2}};

clc
X0 = Fi;
D=operator_apply(Ki(1,:),X0);
X = tensor_add(X0,D,tensor_norm(X0)*10*trunc.eps/tensor_norm(D));


% apply without truncation
Y1 = operator_apply(Ki, X);

% apply reverse with truncation
options={'pass_on', {'truncate_func', tr_func, 'reverse', true}};
Y2 = operator_apply(Ki, X, options{:});

% apply forward with truncation
options={'pass_on', {'truncate_func', tr_func, 'reverse', false}};
Y3 = operator_apply(Ki, X, options{:});

fprintf('eps=%g\n', trunc.eps)
Xt=funcall(tr_func, X);
abserrX=tensor_error(X,Xt, 'relerr', false);
relerrX=tensor_error(X,Xt, 'relerr', true);
fprintf('|X-Xt|: abs=%g, rel=%g\n', abserrX, relerrX)


L=size(Ki,1);
eps_fak=trunc.eps*(1+trunc.eps)^(L-1);
%disp(eps_fak)

% reverse evaluation of operator
abserrrev = tensor_error(Y1,Y2, 'relerr', false);
fprintf('|AX-A_epsX|: rev=%g\n', abserrrev)

f=0;
for i=1:L
   f=f+i*norm(full(Ki{i,1}),2)*norm(full(Ki{i,2}),2) ;
end
epsadd=f*eps_fak;
abserrrevest=epsadd*tensor_norm(X);
%disp([epsadd, abserrrevest, abserrrevest/abserrrev])
fprintf('|AX-A_epsX|: revest=%g, overest=%g\n', abserrrevest, abserrrevest/abserrrev)



% forward evaluation of operator
abserrfor = tensor_error(Y1,Y3, 'relerr', false);
fprintf('|AX-A_epsX|: for=%g\n', abserrfor)

f=0;
for i=1:L
   f=f+i*norm(full(Ki{L+1-i,1}),2)*norm(full(Ki{L+1-i,2}),2) ;
end
epsadd=f*eps_fak;
abserrforest=epsadd*tensor_norm(X);
%disp([epsadd, abserrforest, abserrforest/abserrfor])
fprintf('|AX-A_epsX|: forest=%g, overest=%g\n', abserrforest, abserrforest/abserrfor)


% application of preconditioner
A=Ki;
Mi_inv={inv(A{1,1}),inv(A{1,2})};
DX1=operator_apply(Mi_inv,Y1);
DX2=operator_apply(Mi_inv,Y2);

f=norm(full(Mi_inv{1,1}),2)*norm(full(Mi_inv{1,2}),2);
abserrY=tensor_error(Y1,Y2, 'relerr', false);
abserrXest=f*abserrY;
abserrX=tensor_error(DX1,DX2, 'relerr', false);
fprintf('|Y1-Y2|: rev=%g\n', abserrY)
fprintf('|X1-X2|: rev=%g\n', abserrX)
fprintf('|X1-X2|: est=%g overest=%g\n', abserrXest, abserrXest/abserrX)

%keyboard




function U=tensor_truncate_fixed( T, trunc, varargin )

U=tensor_truncate( T, 'eps', trunc.eps, 'k_max', trunc.k_max, varargin{:} );
%gvector_error( T, U, 'relerr', true )

if get_option( trunc, 'show_reduction', false )
    r1=tensor_rank(T);
    r2=tensor_rank(U);
    fprintf( 'fixd: %d->%d\n', r1, r2 );
    if r1>300
        keyboard;
    end
end

