function eps=eps_from_error( pcg_err, rho )
eps=pcg_err*(1-rho);
scale=10^(floor(log10(eps)))/10;
eps=roundat( eps, scale );


