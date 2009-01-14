function varargout=model_poisson_1d( cmd, varargin )

%options=varargin2options( varargin{:};
persistent x els 

switch( cmd )
    case 'init'
    case 'boundary_ind'
    case 'stiffness_mult'
        i=varargin{1};
        k=varargin{2};
        x=varargin{3};
        
        
    case 'mass_mult'
        
    case 'nodes'
        varargout{1}=x;
end


