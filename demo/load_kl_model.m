function varargout=load_kl_model( name, version, silent, output_vars )
% MODEL_KL Load or compute a random field model in KL expanded form.
%   MODEL_KL( NAME, REINIT, SILENT ) loads the model NAME. If the model
%   does not exist or REINIT is true, the model is recomputed and saved to
%   the file 'data/<modelname>.mat'. If SILENT is specfied and true, no
%   ouput is issued, when the model has to be recomputed (otherwise, you'll
%   see some output, so that the user knows what's going on).
% TODO: WRITE STUFF ABOUT VERSION
%  version=1; % increase to force recomputation, set to rand(1) to always force recomputation

global silent_computation

rf_filename=[name '.mat'];
if nargin<2
    version=[];
end
if nargin<3 || isempty(silent)
    silent=false;
end
silent_computation=silent;

%% Part 1: Setting up options and params

% set global and default options
meshname='';
use_mass=true;
els=[]; pos=[];
cov_gam=[];
options_expand_r={'transform', {'correct_var', true} };

% set model specific options and parameters
switch name
    case 'rf_kl_2d-1'
        meshname='rect_mesh';
        use_mass=false;
        p_r=3;
        m_gam_r=10;
        m_r=15;
        lc_r=[0.1 0.2];
        stdnor_r=@normal_stdnor;
        cov_r={@gaussian_covariance,{lc_r,1}};
        cov_gam={@gaussian_covariance,{lc_r,1}};
    case 'rf_kl_1d_sfem21_f'
        [pos,els,bnd]=create_mesh_1d( 0, 1, 21 );
        p_r=3;
        m_gam_r=2;
        m_r=4;
        lc_r=2*0.3;
        stdnor_r={@beta_stdnor,{4,2}};
        cov_r={@gaussian_covariance,{lc_r,1}};
    case 'rf_kl_1d_sfem21_k'
        [pos,els,bnd]=create_mesh_1d( 0, 1, 21 );
        p_r=4;
        m_gam_r=4;
        m_r=4;
        lc_r=0.3;
        stdnor_r={@beta_stdnor,{4,2}};
        cov_r={@gaussian_covariance,{lc_r,1}};
    otherwise

        error( 'model_kl:unknown', 'Unknown model name: %s', name );
end

% load mesh if necessary
if ~isempty( meshname )
    [pos,els,bnd]=load_and_correct_mesh( meshname );
elseif isempty(pos) || isempty(els)
    error( 'model_kl:unspec', 'Neither meshname nor els/pos was specified.' )
end

% compute mass matrix if wanted
if use_mass
    G_N=mass_matrix( pos, els );
else
    G_N=[];
end

%% Part 2: Doing the actual computation or retrieval from file

[mu_r_j, r_j_i, rho_i_alpha,I_r]=cached_funcall(...
    @compute_random_field,...
    { stdnor_r, cov_r, cov_gam, pos, G_N, p_r, m_gam_r, options_expand_r, m_r }, ...
    4, ...
    rf_filename, ...
    version );


%% Part 3: Assigning the output
if nargin<4
    varargout={pos, els, mu_r_j, r_j_i, rho_i_alpha, I_r, p_r, m_gam_r, m_r, lc_r, stdnor_r, cov_r, cov_gam};
else
    for i=1:length(output_vars)
        if exist(output_vars{i},'var')
            varargout{i} = eval(output_vars{i});
        else
            error( 'model_kl:output_vars', 'unknown output variable: %s', output_vars{i} );
        end
    end
end


%% Appendix: Some auxiliary functions

function [pos,els,bnd]=load_and_correct_mesh( meshname );
s=load( ['data/' meshname '.mat' ]);
pos=s.coords';
els=s.nodes';
[pos,els]=correct_mesh( pos, els );
if isfield(s, 'bnd')
    bnd=s.bnd;
else
    bnd=find_boundary( els );
end


function [mu_r_j,rho_i_alpha,r_j_i, I_r]=compute_random_field( stdnor_r, cov_r, cov_gam, pos, G_N, p_r, m_gam_r, options_expand_r, m_r )
global silent_computation
silent=silent_computation;
% compute the random field
if ~silent
    fprintf( 'model_kl: expanding field, this may take a while...\n' );
end
[r_j_alpha, I_r]=expand_field_pce_sg( stdnor_r, cov_r, cov_gam, pos, G_N, p_r, m_gam_r, options_expand_r{:} );
if ~silent
    fprintf( 'model_kl: computing kl, this may take a while, too...\n' );
end
[mu_r_j,r_j_i,rho_i_alpha]=pce_to_kl( r_j_alpha, I_r, m_r, G_N );
if ~silent
    fprintf( 'model_kl: finished, saving to file...\n' );
end
