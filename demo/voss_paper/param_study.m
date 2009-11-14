function s=param_study( script, var_params, def_params, ret_names )
% PARAM_STUDY Short description of param_study.
%   PARAM_STUDY Long description of param_study.
%
% Example (<a href="matlab:run_example param_study">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Comuting
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

% parameter looping stuff
var_param_names=fieldnames(var_params);
n_var_params=size(var_param_names,1);
max_ind=reshape( cellfun('length',struct2cell(var_params)), 1, []);
num_ind=prod(max_ind);

for i=1:length(ret_names)
    s.(ret_names{i})=cell(max_ind);
end

% do the parameter loop
params=def_params;
param_names=reshape(fieldnames(params),1,[]);
ind=ones(1,n_var_params);
for n=1:num_ind
    % get current parameters
    for i=1:n_var_params
        params.(var_param_names{i})=var_params.(var_param_names{i}){ind(i)};
    end
    
    % 
    for i=1:length(param_names)
        name=param_names{i};
        assignin( 'base', name, params.(name) );
    end
    evalin('base', script );
    for i=1:length(ret_names)
        name=ret_names{i};
        s.(name){n}=evalin('base', name );
    end
    
    %disp(reshape( struct2cell(params), 1, [] ))
    
    % compute next index
    for k=1:n_var_params
        ind(k)=ind(k)+1;
        if ind(k)<=max_ind(k); break; end
        ind(k)=1;
    end
end

