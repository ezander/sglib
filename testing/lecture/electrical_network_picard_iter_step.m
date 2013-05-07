function du = electrical_network_picard_iter_step(state, u, p)
% ELECTRICAL_NETWORK_PICARD_ITER_STEP Computes one Picard iteration for the electrical network.
%
% Note: could also be called modified Newton with linearised Jacobian at u=0

% Compute residual at u
res = electrical_network_residual(state, u, p);

% Preconditioner (inverse system matrix)
Pr = state.Pr;

% Compute one Picard iteration step
du = Pr * res;
