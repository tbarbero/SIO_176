load('float5903390.mat');
% m_proj('mercator','lat',[-75 0],'long', [-270,0]);
% m_coast('patch',[.7 .7 .7],'edgecolor','r');
% h=m_line(argo.longitude,argo.latitude,'marker','o','color','k','linewi',2,'linest','none','markersize',5,'markerfacecolor','k');
% m_grid('linestyle','none','tickdir','out','linewidth',3);


% temperature shapoe is 316x400
% to index through this matrix do temp(row,column)

figure(2)
plot(temperature(5,1:300))
hold on
plot(temperature(5,300:400))
hold off


