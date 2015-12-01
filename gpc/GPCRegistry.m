classdef GPCRegistry < handle
    properties
        registry@struct
        char2index@int32
    end
    
    methods
        function gpcreg=GPCRegistry()
            gpcreg.registry = GPCRegistry.register_default_polys();
            gpcreg.char2index = GPCRegistry.make_char_lookup(gpcreg.registry);
        end
    end
    
    methods
        function [polysys, dist] = get(gpcreg, syschar)
            index = gpcreg.char2index(syschar);
            if index
                entry = gpcreg.registry(index);
                assert(syschar == entry.syschar);
                polysys = entry.polysys;
                dist = entry.dist;
            else
                polysys = [];
                dist = [];
            end
        end
        
        function set(gpcreg, syschar, polysys, dist)
            index = gpcreg.char2index(syschar);
            if index
                entry = gpcreg.registry(index);
                if entry.polysys ~= polysys
                    error('sglib:gpc_registry:already_set', 'Cannot reset gpc_registry entry with different polynomials.');
                end
                return
            end
            if nargin<4
                dist = polysys.weighting_dist();
            end
            entry = gpcreg.make_reg_entry(syschar, polysys, dist);
            gpcreg.registry(end+1) = entry;
            gpcreg.char2index(syschar) = length(gpcreg.registry);
        end
        
        function syschar = find(gpcreg, polysys)
            chars = find(gpcreg.char2index);
            entries = gpcreg.char2index(chars);
            syschar = '';
            for i=1:length(entries)
                entry = gpcreg.registry(entries(i));
                if entry.polysys==polysys
                    syschar = char(chars(i));
                    break;
                end
            end
        end
        
        function syschar = findfree(gpcreg, pref_charset)
            charsets = {['a':'z', 'A':'Z', '0':'9'], char(1:255)};
            if nargin>=2
                charsets={pref_charset, charsets{:}};
            end
            syschar = '';
            for k=1:length(charsets)
                used = gpcreg.char2index(charsets{k});
                ind = find(~used, 1, 'first');
                if ~isempty(ind)
                    syschar = charsets{k}(ind);
                    break
                end
            end
        end
        
        function [polysys, dist]=getall(gpcreg)
            polysys = gpcreg.registry;
            dist = gpcreg.char2index;
        end
        
        function old_registry=reset(gpcreg, registry)
            old_registry = gpcreg.registry;
            if nargin>1
                gpcreg.registry = registry;
            else
                gpcreg.registry = gpcreg.register_default_polys();
            end
            gpcreg.char2index = gpcreg.make_char_lookup(gpcreg.registry);
        end
    end
    
    methods(Static, Hidden)
        function entry = make_reg_entry(syschar, polysys, dist)
            entry.syschar = syschar;
            entry.polysys = polysys;
            if nargin>2
                entry.dist = dist;
            else
                entry.dist = polysys.weighting_dist();
            end
        end
        
        function registry = register_default_polys()
            registry = struct('syschar', {}, 'polysys', {}, 'dist', {});
            registry(end+1) = GPCRegistry.make_reg_entry('H', HermitePolynomials());
            registry(end+1) = GPCRegistry.make_reg_entry('h', HermitePolynomials().normalized());
            registry(end+1) = GPCRegistry.make_reg_entry('P', LegendrePolynomials());
            registry(end+1) = GPCRegistry.make_reg_entry('p', LegendrePolynomials().normalized());
            registry(end+1) = GPCRegistry.make_reg_entry('T', ChebyshevTPolynomials());
            registry(end+1) = GPCRegistry.make_reg_entry('t', ChebyshevTPolynomials().normalized());
            registry(end+1) = GPCRegistry.make_reg_entry('U', ChebyshevUPolynomials());
            registry(end+1) = GPCRegistry.make_reg_entry('u', ChebyshevUPolynomials().normalized());
            registry(end+1) = GPCRegistry.make_reg_entry('L', LaguerrePolynomials());
            registry(end+1) = GPCRegistry.make_reg_entry('l', LaguerrePolynomials().normalized());
            registry(end+1) = GPCRegistry.make_reg_entry('M', Monomials());
        end
        
        function char2index = make_char_lookup(registry)
            char2index = zeros(256,1,'int32');
            chars = int32(char(registry.syschar));
            indices = 1:length(registry);
            char2index(chars) = indices;
        end
    end
end
