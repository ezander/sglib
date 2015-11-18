function paramset=generate_stdrn_simparamset(sigmas)
% Generate parameterset with standard normal parameters
n=length(sigmas);
params=cell(n,1);
for i=1:n
    str= strvarexpand('params{$i$}=SimParameter(''p_$i$'',NormalDistribution(0,sqrt(sigmas($i$))));');
    eval(str);
end
paramset=SimParamSet(params{:});
end