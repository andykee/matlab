function opdplot(opd)

figure();
imagesc(opd);
axis image
colorbar
xlabel(['RMS = ', num2str(wfe(opd)), '   PV = ', num2str(pv(opd))])

set(gca,'xtick',[]);
set(gca,'ytick',[]);
