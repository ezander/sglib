function [x_mean, x_var, x_m2] = mean_var_update(n, x_n, x_mean, x_var, x_m2)
% MEAN_VAR_UPDATE Updates mean and variance given a new sample.
%   [X_MEAN,X_VAR,X_M2] = MEAN_VAR_UPDATE(N, X_N, X_MEAN, X_VAR, X_M2)
%   updates the mean and variance in X_MEAN and X_VAR with the N-th sample
%   specified in X_N. X_M2 is the second central moment of the samples. If
%   it is specified for input and output a more stable algoritm for
%   calculating the variance can be used. This is not necessary for the
%   computation of the variance so that function can also be used without
%   that parameter in the form [X_MEAN,X_VAR] = MEAN_VAR_UPDATE(N, X_N,
%   X_MEAN, X_VAR). If only the mean shall be calculated only X_MEAN needs
%   to be passed as input parameter: [X_MEAN] = MEAN_VAR_UPDATE(N, X_N,
%   X_MEAN).
%   Except on the first call all parameters that appear in the output
%   parameter list, must also appear in the input parameter list. On the
%   first call X_MEAN, X_VAR and X_M2 can be the empty array or completely
%   omitted.
%
% Example (<a href="matlab:run_example mean_var_update">run</a>)
%   % assume 'do_sample' is a function that generates samples
%   do_sample = @()(rand(3,1));
%
%   % compute just the mean of 1000 samples
%   x_mean=[];
%   for i = 1:1000
%      x_mean = mean_var_update(i, do_sample(), x_mean);
%   end
%   x_mean
%
%   % compute the mean and the variance of 1000 samples
%   x_mean=[]; x_var=[];
%   for i = 1:1000
%      [x_mean, x_var]= mean_var_update(i, do_sample(), x_mean, x_var);
%   end
%   [x_mean, x_var]
%
%   % compute the variance with a numerically more stable algorithm
%   x_mean=[]; x_var=[]; x_m2=[];
%   for i = 1:1000
%      [x_mean, x_var, x_m2]= mean_var_update(i, do_sample(), x_mean, x_var, x_m2);
%   end
%   [x_mean, x_var]
%
% See also MEAN, VAR
%
% References:
%   Donald E. Knuth (1998). The Art of Computer Programming, volume 2: 
%       Seminumerical Algorithms, 3rd edn., p. 232. Boston: Addison-Wesley.
%   Wikipedia: https://en.wikipedia.org/wiki/Algorithms_for_calculating_variance#Online_algorithm


%   Elmar Zander
%   Copyright 2013, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

% set flag whether variance shall be computed
compute_var = nargout>=2;
compute_m2 = nargout>=3;

if n==1
    x_mean = x_n;
    if compute_var && (nargin<4 || isempty(x_var))
        x_var = zeros(size(x_mean));
    end
    if compute_m2
    	x_m2 = zeros(size(x_mean));
    end
else
    delta = x_n - x_mean;
    x_mean = x_mean + delta / n;
    if compute_var
        if compute_m2
            assert(nargin>=5);
            x_m2 = x_m2 + delta .* (x_n - x_mean);
            x_var = x_m2 / (n-1);
        else        
            new_delta = x_n - x_mean;
            x_var = ((n-2) * x_var + delta .* new_delta) / (n-1);
        end
    end
end
