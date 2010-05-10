clear

model_1d_large
% p_f=2;
% lc_f=0.02;
% p_k=4;
% p_u=2;
% m_f_expr='i';
% m_k_expr='10';
% maxt=240;
% mini=35;

% f(35,2), k(10,4), (u,45,2)

res=[];
% for i=mini:100
%     m_f=eval(m_f_expr);
%     m_k=eval(m_k_expr);
%     m_g=0;
%     m_h=0;
    define_geometry
    discretize_model
    t=tic;
    setup_equation
    t=toc(t);
    res=[res; i, t, size(I_u,1), size(I_u,1), size(I_k,1)];
    disp(res);
%     if t>maxt; break; end
% end


start=1;
m=plot_linreg( res(start:end,1), res(start:end,2), 'logx', true, 'logy', true, 'log_axes', false );
m=plot_linreg( res(start:end,1), res(start:end,2), 'logx', false, 'logy', true, 'log_axes', false );
%plot_linreg( res(:,1), res(:,2), 'logx', false, 'logy', false );
