function type=get_svd_type( S )

if isempty(S)
    type='empty';
elseif isvector(S)
    type='vector';
else
    type='matrix';
end
