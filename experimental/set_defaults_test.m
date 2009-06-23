function bla

blubb
blubb(3,4)
blubb(7)

function blubb(a,b)
def.a=1;
def.b=2;
setdefaults(def);
disp(a+b);




function setdefaults(defaults)
    var_names = evalin('caller', 'who');
    default_names = fieldnames(defaults);
    must_replace = ~ismember(default_names, var_names);
    for k = find(must_replace)'
        name = default_names{k};
        assignin('caller', name, defaults.(name));
    end
