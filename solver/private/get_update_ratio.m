function upratio=get_update_ratio
global gsolver_stats;
if isempty(gsolver_stats) || ~isfield(gsolver_stats, 'upratio')
    upratio=1;
    warning( 'get_update_ratio:no_update_ratio', 'gsolver_stats does not contain update_ratio' );
else
    upratio=gsolver_stats.upratio(end);
end

