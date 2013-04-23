function y =legendre_polynomial_1D(p,x)
 
%%
switch p
case 0     
    y=ones(size(x));  return
case 1
    y=x;     return
case 2
    y= (3*x.^2-1)/2;     return
case 3
    y= (5*x.^3-3*x)/2;    return
case 4
    y=(35*x.^4 - 30*x.^2 + 3)/8;     return
case 5
    y=( 63 *  x .^5 - 70 *  x .^3 + 15 * x  )/8;     return
case 6
    y=(231 * x.^6 - 315 *  x .^4 + 105 *  x .^2 -5)/16 ;     return
 case 7
   y=(429 *  x .^7 - 693 *  x .^5 +315 *  x .^3 -35 * x  )/16 ;     return
case 8
    y=(6435 * x .^8 -12012 * x .^6 + 6930 *  x .^4 -1260 *  x .^2 +35)/128 ;     return
case 9
    y=(12155 *  x .^9 -25740 *  x .^7 +18018 *  x .^5 -4620 *  x .^3 +315 * x  )/128 ;
    return
case 10
       y=(46189 * x .^10 -109395 * x .^8 +90090 * x .^6 -30030 *  x .^4 +3465 *  x .^2 -63)/256 ;
    return
case 11
   y=(88179 *  x .^11 -230945 *  x .^9 +218790 *  x .^7 -90090 *  x .^5 +15015 *  x .^3 -693 * x  )/256 ;
    return  
case 12
    y=(676039 * x .^12 -1939938 * x .^10 +2078505 * x .^8 -1021020 * x .^6 +225225 *  x .^4 -18018 *  x .^2 +231)/1024 ;
    return
    
 otherwise
     fprintf('Error: maximum degree 12\n');         
   return
end




