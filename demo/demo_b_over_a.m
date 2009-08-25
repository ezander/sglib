function demo_b_over_a( varargin )
% DEMO_B_OVER_A Show division of random variables.

init_demos

hold off

options=varargin2options( varargin{:} );

% the shift value let's you distinguish some of the pdf's which otherwise
% would be right on top of each other
[shift,options]=get_option( options, 'shift', 0.02 );
check_unsupported_options( options, mfilename );


% Trying to approximate a random variable X=B/A by PCE
% b and a depending on the same basic gaussian random var i.e. a=a(xi),
% b=b(xi). I should try the same with a=a(xi1) and b=b(xi2) then the pdf of
% a\b will be the convolution of b and 1/a


% Define the random variables A, B and X.
%a_func={@exponential_stdnor, {2}};
a_func={@uniform_stdnor, {2,3}};
b_func={@lognormal_stdnor, {1.5, 0.5}};
x_func={@div_func,{b_func, a_func}};

disp( 'show the pdf''s of the three random vars' );
p=3;
gam=randn_sorted(10000);
kernel_density( funcall( a_func, gam ), [], [], 'b' ); hold on;
kernel_density( funcall( b_func, gam ), [], [], 'g' );
kernel_density( funcall( x_func, gam ), [], [], 'r' );
legend( 'A', 'B', 'X=B/A' ); title( 'pdf''s' );
hold off;
userwait;

disp( 'compare the pdf of X' );
% method 1: b_func/a_func
kernel_density( 0*shift+funcall( x_func, gam ), [], [], 'b' ); hold on;
% method 2: samples from b_func over samples of a_func
kernel_density( 1*shift+funcall( b_func, gam )./funcall( a_func, gam ), [], [], 'r' );
% method 3: pce by b_func/a_func
x_iota=pce_expand_1d( x_func, p );
kernel_density( 2*shift+hermite_val( x_iota, gam ), [], [], 'g' );
% method 4: solving stochastic galerkin equatin with pces of a and b
a_alpha=pce_expand_1d( a_func, p );
b_beta=pce_expand_1d( b_func, p );
x_iota2=solve_sg_eq( a_alpha, b_beta );
kernel_density( 3*shift+hermite_val( x_iota2, gam ), [], [], 'k' );
% method 5: using the compute_pce_operator function (basically the same
% as method 4)
I=(0:p)';
stiffness_func={@(x)(x),{}};
K=compute_pce_operator( a_alpha, I, I, stiffness_func, 'alpha_beta_mat')
x_iota3=(K\(b_beta'.*factorial(I)))'
kernel_density( 4*shift+hermite_val( x_iota3, gam ), [], [], 'y' );
legend( 'method 1', 'method 2' , 'method 3' , 'method 4' , 'method 5' ); title( 'pdf''s of x' );
hold off;
userwait;

disp( 'zoom in on the peak' );
xlim([1,4]);
userwait;

return

% some test's I've forgotten what they were for...
x_iota3=solve_sg_eq_update( a_func, p, b_beta ); %#ok
kernel_density( 4*shift+hermite_val( x_iota3, gam ), [], [], 'k' );
[x_iota; x_iota2; x_iota3]'
format short
[(x_iota-x_iota2)'./x_iota' (x_iota-x_iota3)'./x_iota']*100

hold off;


function y=div_func( x, num_func, den_func )
y=funcall(num_func,x)./funcall(den_func,x);

function x_iota=solve_sg_eq( a_alpha, b_beta )
% sum( a_alpha H_alpha)*sum( x_iota H_iota)=sum( b_beta H_beta)
% E[ % H_Delta] =>
% sum( a_alpha  x_iota E[H_iota H_alpha H_delta])=sum( b_beta E[H_beta H_delta])
% sum( a_alpha  x_iota Delta_iota_alpha_delta])=delta! b_delta
% sum( a_alpha  x_iota Delta_iota_alpha_delta])=delta! b_delta
% K*X=B with

p=length(b_beta)-1;
B=(factorial(0:p).*b_beta)';
K=zeros(p+1,p+1);
for alpha=0:p
    for delta=0:p
        for iota=0:p
            K(delta+1,iota+1)=K(delta+1,iota+1)+...
                    a_alpha(alpha+1)*hermite_triple_product(alpha,delta,iota);
        end
    end
end
x_iota=(K\B)';

function x_iota=solve_sg_eq_update( a_func, p, b_beta ) %#ok
[x,w]=gauss_hermite_rule( 3 );
a_alpha=zeros(size(b_beta));
for i=0:p
    h=hermite(i);
    y=w*(funcall( a_func, x).*polyval(h,x));
    a_alpha(i+1)=y/factorial(i);
end

D=diag(factorial(0:p));
B=D*b_beta;
K=zeros(p+1,p+1);
for alpha=0:p
    for delta=0:p
        for iota=0:p
            K(delta+1,iota+1)=K(delta+1,iota+1)+...
                    a_alpha(alpha+1)*hermite_triple_product(alpha,delta,iota);
        end
    end
end
x_iota=(K\B)';
