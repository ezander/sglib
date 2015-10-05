function dist_obj=gendist2object(dist)

switch dist{1}
    case 'beta'
       dist_obj=BetaDistribution(dist{2}{:});
    case 'exponential'
       dist_obj=ExponentialDistribution(dist{2}{:});
    case 'lognormal'
       dist_obj=LogNormalDistribution(dist{2}{:}); 
    case 'normal'
        dist_obj=NormalDistribution(dist{2}{:});
    case 'uniform'
        dist_obj=UniformDistribution(dist{2}{:});
end
end