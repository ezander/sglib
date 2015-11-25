classdef CallStatistics < handle
    properties(SetAccess=protected)
        num_calls = 0
        time_calls = 0
        time_stats = []
    end
    properties(Hidden,Access=protected)
        start_tic = nan
    end
    methods 
        function stats = CallStatistics()
        end
        function start_call(stats)
            stats.num_calls = stats.num_calls+1;
            stats.start_tic = tic;
        end
        function end_call(stats)
            dt = toc(stats.start_tic);
            stats.time_calls = stats.time_calls + dt;
            stats.time_stats(end+1) = dt;
        end
    end
    methods(Static)
        function [wrapped_func, stats]=wrap_function(func)
            stats = CallStatistics();
            wrapped_func = funcreate(@func_stats_wrapper, stats, func, @ellipsis);
        end    
    end
end

function varargout=func_stats_wrapper(stats, func, varargin)
stats.start_call();
[varargout{1:nargout}] = funcall(func, varargin{:});
stats.end_call();
end
