
delta=0.01;
[X, Y]=ndgrid(-1+delta/2 : delta:1, -1+delta/2 : delta:1);

popu = [X(:)';Y(:)'];

Z=zeros(size(X));

Z(:) = legendre_polynomial_2D( [ 2 3], popu );

surf(X, Y, Z )

 [ind, var_list] =multi_dim_polynomial_order_list( 2, 3);
 
 num_terms= length(var_list);
 
 inner_prod= zeros(num_terms);
 
 for i=1:num_terms
    for j=i:num_terms
        
       inner_prod(i, j) = sum(  delta^2* legendre_polynomial_2D( ind(i, :), popu ) ...
                                .*legendre_polynomial_2D( ind(j, :), popu ) ) ; 
                            
       if i==j           
           inner_prod(i, j)= inner_prod(i, j)/var_list(i);
       end
    end
     
 end