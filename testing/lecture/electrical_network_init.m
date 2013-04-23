function state = electrical_network_init( varargin )
% ELECTRICAL_NETWORK_INIT Initialises the structure that keeps the internal
% state of the electrical network example.
%
% Example:
%    state = electrical_network_init('R', 200, 'f0', 5);

options = varargin2options(varargin);
[R, options] = get_option(options, 'R', 0.01);
[fg, options] = get_option(options, 'fg', 25);
[f0, options] = get_option(options, 'f0', [1; zeros(4,1)]);
check_unsupported_options(options, mfilename);

% edge - node incidence matrix
B=[0  1  0 -1  0  0;
   1  0  0  0 -1  0; 
   0  0  0 -1  1  0; 
   0  0 -1  1  0  0; 
   1  0 -1  0  0  0;  
   0 -1  1  0  0  0;
  -1  1  0  0  0  0; 
   0  0  1  0 -1  0;
   0  0  0  0  1 -1];

% conductivity of resistors on edges
n = size(B,1);
D = diag((1/R)*ones(1,n));
As = B'*D*B;

% As should be singular
assert(rank(As)<min(size(As)));

% grounding of the last node is achieved by removing the last row and
% column of the matrix
A = As(1:end-1, 1:end-1);
assert(rank(A)==min(size(A)));

% store everything in the state variable
state = struct();
state.A = A;
state.Pr = inv(A);
state.R = R;
state.f0 = f0;
state.fg = fg;
state.num_params = 2;
state.num_vars = size(A,1);
state.u0 = zeros(state.num_vars, 1);
