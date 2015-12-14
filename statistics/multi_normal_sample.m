function xi=multi_normal_sample(n, mu, sigma2)
% MULTI_NORMAL_SAMPLE Sample from a multivariate normal distribution.
%   XI=MULTI_NORMAL_SAMPLE(N, MU, SIGMA2) samples from a multivariate normal
%   distribution, where N is an integer, MU is a Mx1 vector and SIGMA2 is an
%   MxM matrix. The returned samples XI will be MxN and the mean of XI will
%   be (approx.) equal to MU and the covariance (approx.) equal to SIGMA2.
%
%   Instead of specifiying a an Mx1 vector and an MxM matrix it is also
%   possible that MU and SIGMA2 are a) 1x1 and MxM b) 1x1 and Mx1, c) Mx1
%   and 1x1 d) Mx1 and Mx1. The way MU and SIGMA2 are interpreted in those
%   cases should be obvious.
%
% Example (<a href="matlab:run_example multi_normal_sample">run</a>)
%
% See also NORMAL_SAMPLE

%   Elmar Zander
%   Copyright 2015, Institute of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


% Size of MU
m_mu = size(mu,1);
assert(size(mu,2)==1);

% Size of SIGMA2
m_sig = size(sigma2,1);
assert(size(sigma2,2)==1 || size(sigma2,2)==m_sig);

% Determine the correct size M from both
assert(m_mu==m_sig || m_mu==1 || m_sig==1);
m = max(m_mu, m_sig);

% Sample from the normal distribution
xi0 = randn(m, n);

% Correct for the variance
if m_sig==1
    xi = sqrt(sigma2) * xi0;
elseif isvector(sigma2)
    xi = binfun(@times, sqrt(sigma2), xi0);
else
    % Maybe L has only NR<N columns because SIGMA2 is not positive definite
    % (may happen sometimes even due to numerical error)
    [L, nr] = covariance_decomp(sigma2);
    xi = L * xi0(1:nr, :);
end

% Make MU a vector if necessary
if m_mu==1
    xi = mu + xi;
else
    xi = binfun(@plus, mu, xi);
end
