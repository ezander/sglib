% $Id: non_intrus_Galerkin_testcase.m,v 1.3 2013/01/27 22:36:37 hgm Exp $
%
% The Log entries are at the end of the file.
%

%% solve Au + (2+p_1) |u|^2 u = (fg+p_2) f by using stochastic Galerkin method and direct integration method
 
% 
% Solve Au + (2+p_1) |u|^2 u = (fg+p_2) f
%
% iterative solver: u_(j+1) = inv(A)*((fg+p_2) f - (2+p_1) (u_j'*u_j) *u_j)

%% texfile{
%%  AUTHOR    = "$Author: hgm $",
%%  VERSION   = "$Revision: 1.3 $",
%%  DATE      = "$Date: 2013/01/27 22:36:37 $",
%%  FILENAME  = "$RCSfile: non_intrus_Galerkin_testcase.m,v $"}
%
%

% max no. of inner iterations
jinmax = 4;

% additive const for p_2, factor of f_0
fg = 25;

% value for resistors
R=1/100;
 
% setup the matrix A, and compute inverse(A) and its dimension m
[A, AI, m]=setup_matrix_for_elec_network( R );
 
 
% the rhs
f0 = zeros(m,1); f0(1) = 1;
  

u=zeros(m,1);
u_old=u; 
 
% approximate u by Gauss-Legendre polynomials, for comparison firstly compute the coefficients 
% by direct integration using Gauss-Legendre quadrature

% get the order index for 2 dimensional polynomials with total degree 3,
% varlist is the list of L2 norms of the terms 
[ind, var_list] =multi_dim_polynomial_order_list( 2, 3);  %

num_terms= length(var_list); % number of polynomial terms
 
% get the nodes and weights of 2-D Gauss-Legendre quadrature
[node,weight]=lgwt_2D(4, -1, 1);

num_node= length(node);

% u samples at the Gauss-Legendre nodes
u_node=zeros(m, num_node);



% sample u at the Gauss-Legendre quadrature nodes by using iterative solver 
maxiter=1000;
acr = 1000*eps;  

for i=1:num_node
    p= node(:,i);

    for j=1:maxiter

        u = u_old + residual(p, AI, A, fg, f0, u_old);

        if max(abs(u-u_old))<acr;
           fprintf('Converged! iter= %d\n',j)
           break; 
        end
        u_old=u;
    end

    u_node(:, i) = u;
end


% integrate the coefficients of the polynomial terms by using
% Gauss-Legendre quadrature

u_alpha = zeros(m, num_terms);% the coefficients of the polynomial terms  

for i=1:num_terms    
    poly_eval = legendre_polynomial_2D( ind(i, :), node );
    
    for n=1:m
       u_alpha(n, i) =  sum(u_node(n, :).*poly_eval.*weight)/var_list(i) ;
        
    end  
end



% testify the polynomial approximation by comparing to a real sample

% first compute a sample by iterative solver

p=rand(2, 1);

    for j=1:maxiter
 
         u = u_old + residual(p, AI, A, fg, f0, u_old); 
 
        if max(abs(u-u_old))<acr
           fprintf('Converged! \n')
           break; 
        end
        u_old=u;
    end
 
% then compute the polynomial approximation 
  u_approx =  legendre_approx( u_alpha, ind, p );

  p_save = p;  u_save = u;
  u_c_save = u_approx;  
  
% compute the discrepancy
 approx_error= max(abs(u_approx-u))
     
 %%====================================================================================
 % compute the coefficients by stochastic Galerkin method, using Gauss-Seidel iterations
 
  u_alpha_galer = zeros(m, num_terms); % the coefficients of the polynomial terms 
  temp=zeros(m,num_node);
  
  for j=1:maxiter
       u_alpha_old =  u_alpha_galer;
       
    for i=1:num_terms   % inner loop
      
        % Numerical integration to evaluate the right hand side of the Galerkin equation for u updating, using Gauss-Legendre quadrature.  
       u_cur = legendre_approx( u_alpha_galer, ind, node );  % u approximated by polynomials using the most recent updated  coefficients. 
       poly_eval = legendre_polynomial_2D( ind(i, :), node );  % evaluate the ith polynomial term at the Gauss-Legendre nodes
       
       % evaluate A^(-1)*((fg + p_2) f - (2+p_1) (u'*u) *u) 

       for k=1:num_node
          for jin=1:jinmax
             u_cur(:,k) = u_cur(:,k) + residual(node(:,k), AI, A, fg, f0, u_cur(:,k));
          end
       end
       
       % integrate for the coefficients
        u_alpha_galer(:, i) = sum( repmat(poly_eval, m, 1).* u_cur.* repmat(weight, m, 1), 2)/var_list(i);
    end  
   
    % exit condition
    if  max(max(abs(u_alpha_old - u_alpha_galer)))<acr
         fprintf('Galerkin converged! iter= %d\n',j)
         break;
    end
  end

  
 % to compare the Galerkin result with the direct integration result
 
 % compute the discrepancy
  coefficient_difference= max(max(abs(u_alpha_galer-u_alpha)))

 % then compute the polynomial approximation 
  u_approx_gal =  legendre_approx( u_alpha_galer, ind, p );
 
 % compute the discrepancy
  approx_error_colloc= max(abs(u_c_save - u_save))
  approx_error_galerkin= max(abs(u_approx_gal - u))
 
 u_alpha
 u_alpha_galer


% The Log entries
%
% $Log: non_intrus_Galerkin_testcase.m,v $
% Revision 1.3  2013/01/27 22:36:37  hgm
% calling parameters increased for function residual, variable fg
%
% Revision 1.2  2013/01/27 22:07:22  hgm
% Use the residual function, some more comparisons
%
% Revision 1.1  2013/01/26 19:06:37  hgm
% Initial revision as obtained from Dishi
%
% 
% 
%
  
