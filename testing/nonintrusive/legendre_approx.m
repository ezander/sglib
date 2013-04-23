function  result =  legendre_approx( coefficient, order_index, x )
 

% x=popu;
% order_index=ind;
% 
% coefficient= u_alpha_quadr;


  [n, m]=size(coefficient);
  
  % n is the dimension of the output , m is number of polynomial terms
  
% [~, num]=size(x);
  [nn, num]=size(x);
  
  result= zeros(n,num);
  for i=1:m    
    poly_eval = legendre_polynomial_2D( order_index(i, :), x);
    
   result=  result +    kron(coefficient(:, i), poly_eval);
   
  
  end


end

