function test_nd_exact

pt = 13;
for p=1:4
    subplot(3,4,p)
    test(13, p, @gauss_legendre_rule, 'smolyak')
    subplot(3,4,p+4)
    test(13, p, @gauss_legendre_rule, 'full_tensor')
    subplot(3,4,p+8)
    test(13, p, @clenshaw_curtis_nested, 'smolyak')
end

function test(pt, p, rule_func, grid)
I = multiindex(2, pt, 'full', true);
q = integrate_nd({@kernel, {I,[]}, {2,3}}, rule_func, 2, p, 'grid', grid);
q_ex = prod(2./(I+1),2);
ok = (abs(q-q_ex)<1e-10);
plot(I(ok,1), I(ok,2), 'b.'); hold on;
plot(I(~ok,1), I(~ok,2), 'r.'); hold off;
xlim( [min(I(:,1))-0.5, max(I(:,1))+0.5] );
ylim( [min(I(:,2))-0.5, max(I(:,2))+0.5] );
axis square

%[multiindex_order(I),q,q_ex,q-q_ex]
%keyboard

function y = kernel(x, I, weight_func)

if ~isempty(weight_func)
    w = funcall(weight_func, x);
else
    w = ones(size(x,2),1);
end

y = gpc_eval_basis({'M', I}, 0.5*(x+1)) * diag(w);




