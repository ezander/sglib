function comp_state=rand_state_store

rngs={'state', 'twister', 'seed' };
n=length(rngs);

for i=1:n
    state{i}=rand(rngs{i});
end
rc=rand();
for i=1:n
    rand(rngs{i},state{i}); 
    r=rand();
    rand(rngs{i},state{i}); 
    if r==rc
        comp_state={rngs{i},state{i}};
        break;
    end
end



