function plot_burgers(params)
close all

Csave = params.optim.Csave;
Bsave = params.optim.Bsave;
Wsave = params.optim.Wsave;
xpts = params.optim.xpts;
tpts = params.optim.tpts;
n = params.optim.n;

t = params.data.t;
x = params.data.x;
u = params.data.u;
N = params.data.N;

colors_mat = {[1, 123, 118]/255,...
              [255, 82, 0]/255,...
              [0.9290,0.6940,0.1250]};

L = params.optim.library(t);

usrpca = params.ROM.usrpca;
uspod = params.ROM.uspod;
upod = params.ROM.upod;
spod_spec = diag(params.ROM.S.spod{1});
srpca_spec = diag(params.ROM.S.srpca{1});

views = [12,23];
xpos =  [0 -2 0];
ypos =  [9 10 0];
zpos = [-9.5 0 1];
zlims = [0 2];

xlims = [-8.1423 7.7952];
ylims = [0.0595 20.0595];
xpos_flat = [-9 10];
ypos_flat = [0 -0.5];

%%

f1 = figure('DefaultAxesPosition', [0.1, 0.1, 0.8, 0.8]);
% plot the 3D surface of the data
surfl(x,t,u.'+1), shading interp, colormap(gray)
hold on 
imagesc(x,t,u.'/max(u(:))), shading interp, colormap(flipud(gray))
% title('Original Data','fontsize',18)
set_3d_figs(views, xpos,xlims, ypos, ylims, zpos, zlims)


f2 = figure('DefaultAxesPosition', [0.1, 0.1, 0.8, 0.8]);
pcolor(x,t,u.'), shading interp, colormap(flipud(gray))
% title('Original Data','fontsize',18)
set_flat_figs(xlims,ylims,xpos_flat,ypos_flat)

f3 = figure('DefaultAxesPosition', [0.1, 0.1, 0.8, 0.8]);
% plot the edge/ridge-found points
pcolor(x,t,u.'), shading interp, colormap(flipud(gray))
hold on
scatter(xpts,tpts,'c','filled')
% title('Ridge Detection','fontsize',18)
set_flat_figs(xlims,ylims,xpos_flat,ypos_flat)


% plot initial spectral clustering
f4 = figure('DefaultAxesPosition', [0.1, 0.1, 0.8, 0.8]);
pct = sum(Wsave{1})/sum(Wsave{1}(:));
pcolor(x,t,u.'), shading interp, colormap(flipud(gray))
hold on
for jj = 1:size(Wsave{1},2)
    xplot = xpts(logical(Wsave{1}(:,jj)));
    tplot = tpts(logical(Wsave{1}(:,jj)));
    plot(xplot,tplot,'.','markersize',16,'color',colors_mat{jj})
end
% title('Spectral Clustering','fontsize',18)
set_flat_figs(xlims,ylims,xpos_flat,ypos_flat)


f5 = figure('DefaultAxesPosition', [0.1, 0.1, 0.8, 0.8]);
% plot initial models
shifts = L*Bsave{1};
pcolor(x,t,u.'), shading interp, colormap(flipud(gray))
hold on
for jj = 1:size(shifts,2)
    xtmp = shifts(:,jj);
    plot(xtmp,t,'color',colors_mat{jj},'LineWidth',6)
end
% title('Model Discovery','fontsize',18)
set_flat_figs(xlims,ylims,xpos_flat,ypos_flat)


% plot final spectral clustering
f6 = figure('DefaultAxesPosition', [0.1, 0.1, 0.8, 0.8]);
pct = sum(Wsave{end})/sum(Wsave{end}(:));
pcolor(x,t,u.'), shading interp, colormap(flipud(gray))
hold on
for jj = 1:size(Wsave{end},2)
    xplot = xpts(logical(Wsave{end}(:,jj)));
    tplot = tpts(logical(Wsave{end}(:,jj)));
    plot(xplot,tplot,'.','markersize',16,'color',colors_mat{jj})
end
% title(['Final Clusters, Iteraton ',num2str(length(Asave))],'fontsize',18)
set_flat_figs(xlims,ylims,xpos_flat,ypos_flat)

% plot final models
f7 = figure('DefaultAxesPosition', [0.1, 0.1, 0.8, 0.8]);
shifts = L*Bsave{end};
pcolor(x,t,u.'), shading interp, colormap(flipud(gray))
hold on
for jj = 1:size(shifts,2)
    xtmp = shifts(:,jj);
    plot(xtmp,t,'color',colors_mat{jj},'LineWidth',6) 
end
% title(['Final Models, Iteraton ',num2str(length(Asave))],'fontsize',18)
set_flat_figs(xlims,ylims,xpos_flat,ypos_flat)

%%
f8 = figure('DefaultAxesPosition', [0.1, 0.1, 0.8, 0.8]);
surfl(x,t,usrpca.'+1), shading interp, colormap(gray)
hold on 
imagesc(x,t,usrpca.'/max(usrpca(:))), shading interp, colormap(flipud(gray))
set_3d_figs(views, xpos,xlims, ypos, ylims, zpos, zlims)
% title('Shifted RPCA')

f9 = figure('DefaultAxesPosition', [0.1, 0.1, 0.8, 0.8]);
surfl(x,t,uspod.'+1), shading interp, colormap(gray)
hold on 
imagesc(x,t,uspod.'/max(uspod(:))), shading interp, colormap(flipud(gray))
set_3d_figs(views, xpos,xlims, ypos, ylims, zpos, zlims)
% title('Shifted POD')

f10 = figure('DefaultAxesPosition', [0.1, 0.1, 0.8, 0.8]);
surfl(x,t,upod.'+1), shading interp, colormap(gray)
hold on 
imagesc(x,t,upod.'/max(upod(:))), shading interp, colormap(flipud(gray))
set_3d_figs(views, xpos,xlims, ypos, ylims, zpos, zlims)
% title('Unshifted POD')

f11 = figure;%('DefaultAxesPosition', [0.1, 0.1, 0.8, 0.8]);
semilogy(diag(params.ROM.S.pod),'color',colors_mat{1},'linewidth',2)
hold on
semilogy(spod_spec,'color',colors_mat{2},'linewidth',2)
semilogy(srpca_spec,'color',colors_mat{3},'linewidth',2)
set(gca,'fontsize',18)
xlim([-5 200])
xlabel('rank r','fontsize',24)
ylabel('\sigma_r', 'fontsize',24,'rotation',0,'position',[-30 1e-4])
legend('POD','shifted POD','shifted RPCA')

% print(f1,'../figures/burgers_data','-depsc2', '-loose')
% print(f2,'../figures/burgers_data_flat','-depsc2', '-loose')
% print(f3,'../figures/burgers_init_ridge','-depsc2', '-loose')
% print(f4,'../figures/burgers_init_clusters','-depsc2', '-loose')
% print(f5,'../figures/burgers_init_models','-depsc2', '-loose')
% print(f6,'../figures/burgers_clusters','-depsc2', '-loose')
% print(f7,'../figures/burgers_models','-depsc2', '-loose')
% print(f8, '../figures/burgers_sprca','-djpeg', '-loose')
% print(f9, '../figures/burgers_spod','-djpeg', '-loose')
% print(f10, '../figures/burgers_pod','-djpeg', '-loose')
% print(f11, '../figures/burgers_spectrum','-depsc2', '-loose')

end