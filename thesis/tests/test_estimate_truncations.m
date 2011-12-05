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
%D = tensor_add(X,X0, -1);
%disp(tensor_norm(X,[],'orth',false))
%disp(tensor_norm(D,[],'orth',false))



Y1 = operator_apply(Ki, X);
DX1=operator_apply(Mi_inv,Y1);




options={'pass_on', {'truncate_func', tr_func, 'reverse', true}};
Y2 = operator_apply(Ki, X, options{:});
DX2=operator_apply(Mi_inv,Y2);
options={'pass_on', {'truncate_func', tr_func, 'reverse', false}};
Y3 = operator_apply(Ki, X, options{:});

disp(trunc.eps)
Xt=funcall(tr_func, X);
disp(tensor_error(X,Xt, 'relerr', false))
disp(tensor_error(X,Xt, 'relerr', true))

tensor_error(Y1,Y2, 'relerr', false)
tensor_error(Y1,Y3, 'relerr', false)

L=size(Ki,1);
eps_fak=trunc.eps*(1+trunc.eps)^(L-1);
disp(eps_fak)


f=0;
for i=1:L
   f=f+i*norm(full(Ki{i,1}),2)*norm(full(Ki{i,2}),2) ;
end
epsadd=f*eps_fak;
disp([epsadd, epsadd*tensor_norm(X),epsadd*tensor_norm(X)/tensor_error(Y1,Y2, 'relerr', false)])

f=0;
for i=1:L
   f=f+i*norm(full(Ki{L+1-i,1}),2)*norm(full(Ki{L+1-i,2}),2) ;
end
epsadd=f*eps_fak;
disp([epsadd, epsadd*tensor_norm(X),epsadd*tensor_norm(X)/tensor_error(Y1,Y3, 'relerr', false)])



A=Ki;
Mi_inv={inv(A{1,1}),inv(A{1,2})};
%DX3=operator_apply(Mi_inv,Y2);

tensor_error(DX1,DX2, 'relerr', false)

f=norm(full(Mi_inv{1,1}),2)*norm(full(Mi_inv{1,2}),2) ;
disp(tensor_error(DX1,DX2, 'relerr', false))
disp(f*tensor_error(Y1,Y2, 'relerr', false))
disp(f*tensor_error(Y1,Y2, 'relerr', false)/tensor_error(DX1,DX2, 'relerr', false))

keyboard




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

