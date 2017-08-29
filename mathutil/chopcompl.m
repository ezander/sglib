function A=chopcompl( A, delta )
% CHOPCOMPL Replace real or imaginary part of complex numbers close to zero with zero.
%   CHOPCOMPL(A) returns A with all real or imaginary parts of the numbers
%   in A smaller then 1e-10 in magnitude replaced by 0. CHOPCHOPCOMPL(A,
%   DELTA) returns A with all numbers in A smaller then DELTA in magnitude
%   replaced by 0.
%
% Note: this function was named CHOPCOMPL to distinguish it from the CHOP
%   function of the control toolbox and further to make clear that it does
%   absolute chopping; not relative like the control toolbox function does.
%
% Example (<a href="matlab:run_example chopcompl">run</a>)
%   N = 10;
%   f = cos(linspace(-1,1,N));
%   % Do an FFT of an even function there are lots 
%   % tiny complex parts, which should really be zero
%   F = fft(f).*exp(-2*pi*i*(0:N-1)/(2*N))
%   % Apply chopcompl and they are gone (same with odd functions like...)
%   F = chopcompl( F )
%
% See also CHOPABS, ROUND, CEIL, FLOOR

%   Elmar Zander
%   Copyright 2016, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if nargin<2
    delta=1e-10;
end

ind = abs(real(A))<delta;
A(ind)=1i * imag(A(ind));

ind = abs(imag(A))<delta;
A(ind)=real(A(ind));
