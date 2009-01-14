function s=orthpol_info( name, m, variant, params, varargin )
options=varargin2options( varargin{:} );
[shift,options]=get_option( options, 'shift', [] );
[scale,options]=get_option( options, 'scale', [] );
[support,options]=get_option( options, 'support', [] );
[norm,options]=get_option( options, 'norm', [] );
check_unsupported_options( options, mfilename );

n=(0:m)';
one=ones(m+1,1);
name=lower(name);
variant=lower(variant);
switch name
    case {'legendre', 'spherical' }
        s.supp=[-1,1];
        s.hn=2./(2*n+1);
        s.a1n=n+1;
        s.a2n=0;
        s.a3n=2*n+1;
        s.a4n=n;
    case {'chebyshev' }
        switch variant
            case {1, 'first', 'first king', 't', '', [] }
                s.supp=[-1,1];
                s.hn=pi/2*(one+n>0);
                s.a1n=1;
                s.a2n=0;
                s.a3n=1+(n>=1);
                s.a4n=1;
            case {2, 'second', 'second kind', 'u' }
                s.supp=[-1,1];
                s.hn=pi/2*one;
                s.a1n=1;
                s.a2n=0;
                s.a3n=2;
                s.a4n=1;
            otherwise
                error('unkown variant');
        end
    case {'jacobi' }
        alpha=params(1);
        beta=params(2);
        s.supp=[-1,1];
        %s.hn=pi/2*one;
        s.a1n=2*(n+1).*(n+alpha+beta+1).*(2*n+alpha+beta);
        s.a2n=(2*n+alpha+beta+1)*(alpha^2-beta^2);
        s.a3n=(2*n+alpha+beta).*(2*n+alpha+beta+1).*(2*n+alpha+beta+2);
        s.a4n=2*(n+alpha).*(n+beta).*(2*n+alpha+beta+2);
        if alpha==0 && beta==0 % take limits of the above expressions
            s.a1n(1)=2;
            s.a2n(1)=0;
            s.a3n(1)=2;
            s.a4n(1)=4;
        end
    case {'gegenbauer', 'ultraspherical' }
        alpha=params(1);
        s.supp=[-1,1];
        %s.hn=2./(2*n+1);
        s.a1n=n+1;
        s.a2n=0;
        s.a3n=2*(n+alpha);
        s.a4n=n+2*alpha-1;
        if alpha==0
            warning('discrepancy with mathematica definition for C^(0)(0)')
        end
    case {'laguerre'}
        if length(params>=1)
            alpha=params(1);
        else
            alpha=0;
        end
        s.supp=[0,inf];
        %s.hn=2./(2*n+1);
        s.a1n=n+1;
        s.a2n=2*n+alpha+1;
        s.a3n=-1;
        s.a4n=n+alpha;
    case {'hermite' }
        switch variant
            case {'physicist', 'physics' }
                s.supp=[-inf,inf];
                %s.hn=2./(2*n+1);
                s.a1n=1;
                s.a2n=0;
                s.a3n=2;
                s.a4n=2*n;
            case {'stochasticist', 'stochastics', '', [] }
                s.supp=[-inf,inf];
                %s.hn=2./(2*n+1);
                s.a1n=1;
                s.a2n=0;
                s.a3n=1;
                s.a4n=n;
            otherwise
                error('unkown variant');
        end
        
    otherwise
        error('unkown type');

end



%Section 2.4 of
%c W. Gautschi, On generating orthogonal polynomials'', SIAM J. Sci.
%c Statist. Comput. 3, 1982, 289-317.
