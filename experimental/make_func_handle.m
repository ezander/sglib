function handle=make_func_handle( func, params, positions )
handle={func, params, positions};
% put tag into cell array
% write compose function, problem with right to left ordering, maybe we get
% rid of that (or keep them recursive, with performance penalty)


