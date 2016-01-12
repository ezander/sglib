function paramset=dists2simparamset(dists, varargin)
% Generate parameterset from given distributions
options=varargin2options(varargin);
[param_names, options]=get_option(options, 'param_names',{});
check_unsupported_options(options, mfilename);

M=length(dists);
params=cell(M,1);
  if isempty(param_names)
      param_names=cell(M,1);
  end
paramset=SimParamSet();      
for i=1:M
    dist_i=dists{i};
    if ~isa(dist_i, 'Distribution')
        dist_i=gendist2object(dist_i);
    end
    param_name_i=param_names{i};
    if isempty(param_name_i)
        param_name_i=strvarexpand('p_$i$');
    end
    paramset.add(param_name_i,dist_i);
end

end