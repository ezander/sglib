function paramset=generate_stdrn_simparamset(sigmas)
% Generate parameterset with standard normal parameters
n=length(sigmas);
paramset=SimParamSet();

for i=1:n
    param_name_i=strvarexpand('pn_$i$');
    paramset.add(param_name_i, NormalDistribution(0,sigmas(i)));
end

end