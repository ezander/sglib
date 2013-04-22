% DEMO_DENSITY_ESTIMATION Demo showing density estimation functions.
%  Show kernel density plots for different distributions and different
%  numbers of samples.


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

clear;
clc;
clf;


a_func={@uniform_stdnor, {2,3}};
b_func={@lognormal_stdnor, {1.5, 0.5}};
x_func={@beta_stdnor, {1.5, 0.5}};
x_pdf_func={@beta_pdf, {1.5, 0.5}};

dist_params = {{'beta', {0.5, 0.7}};
     {'lognormal', {1.5, 0.5}};
     {'uniform', {0.5, 2.5}};
     {'normal', {1.5, 0.5}}};
%number_of_samples = [100, 1000, 10000, 100000];
number_of_samples = [100, 300, 1000, 3000, 10000];

n=1;
for params = dist_params'
    for N = number_of_samples
        subplot(length(dist_params),length(number_of_samples),n);
        hold all;
        % Generate the samples for the density plot
        x = randn(1,N);
        x_samples = gendist_stdnor(x, params{1}{:});
        kernel_density(x_samples);
        % Generate values for plotting the PDF (somewhat enlarged range of the
        % range given by the samples)
        x_vals = linspace(min(x_samples), max(x_samples));
        x_vals = (x_vals - mean(x_vals)) * 1.2 + mean(x_vals);
        plot(x_vals, gendist_pdf(x_vals, params{1}{:}));
        grid on;
        hold off;
        drawnow;
        n=n+1;
    end
end