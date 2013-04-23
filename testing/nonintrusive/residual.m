% function to compute the residuum (preconditioned)

function r = residual(p, AI, A, fg, f0, u_old)
% compute the residual AI*(p(2)*f0 - (A*u_old + (p(1)+2)*(u_old'*u_old)*u_old))

r = AI*((fg + p(2)).*f0 - (A*u_old + (p(1)+2)*(u_old'*u_old)*u_old));

end
