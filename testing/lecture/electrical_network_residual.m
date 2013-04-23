function r = electrical_network_residual(state, u, p)
% ELECTRICAL_NETWORK_RESIDUAL function to compute the residuum
% (preconditioned).
%
% Each '*_residual' function has the system state as first parameter, the
% approximate solution, for which the residual is computed, as the second
% parameter, and the vector of variable or stochstic parameters as the
% third parameter.

A = state.A;
Pr = state.Pr;
fg = state.fg;
f0 = state.f0;

% Compute the residual of the electrical network

r = Pr * ( (fg + p(2)).*f0 - (A*u + (p(1)+2)*(u'*u)*u));
