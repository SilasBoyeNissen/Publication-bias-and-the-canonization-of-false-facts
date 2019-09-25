clear;
clf;
clc;
tic;
format long;

global canT;
global curve;
global beta;
global alpha;
global FPactual;
global hypothesis;
global p0n;
global p0v;
global p0vary;
global p1;
global q0;
global q0n;
global tau0;
global tau1;

p0n = 1:50001; % Number of negative publication rates tested
p0v = 0; % negative publication rate (0 means all tested)
p1 = 1; % publishing positive results rate
q0 = 0.5; % Initial belief of being true (0 means all tested)
q0n = 1; % Number of initial beliefs tested
p0vary = false; % Vary the neg. publication rate?
hypothesis = -1; % the hypothesis is actually false (0)
FPactual = 0;
canT = zeros(50001, 4);
alpha = 0.05; % false positive rate (alpha)
beta = 0.2; % false negative rate (beta)
tau0 = 0.001; % lower threshold for cannonization
tau1 = 0.999; % upper threshold for cannonization

fontsize = 22;
outputfig = 'RocCurves';
set(figure(1), 'Position', [300, 200, 600, 550]);
ha = TightSubplot(1, 1, [0 0], [0.11 0.01], [0.11 0.01]);
colors = [Hex2rgb('#006837'); Hex2rgb('#78c679')];
axes(ha(1));
h = [];

for curve = 1:4
    hypothesis = hypothesis + 1;
    Calculator();
    if mod(curve, 2) == 0
        h(end+1) = plot(canT(1:101, curve-1), canT(1:101, curve), '.-', 'Color', colors(curve/2, :), 'LineWidth', 2.5, 'MarkerSize', 25); hold on;
        plot(canT(102:end, curve-1), canT(102:end, curve), '--', 'Color', colors(curve/2, :), 'LineWidth', 2.5), hold on;
        hypothesis = -1; % the hypothesis is actually false (0)
        tau0 = 0.1; % lower threshold for cannonization
        tau1 = 0.9; % upper threshold for cannonization
    end
end

plot(0:0.1:1, 0:0.1:1, 'k-');
legend(h, '\tau_0=.001', '\tau_0=.1', 'Location', 'southeast', 'Orientation', 'vertical');
legend('boxoff');
ylim([0 1]);
set(ha(:), 'XTick', 0:0.2:1);
set(ha(:), 'YTick', 0:0.2:1);
set(gca, 'fontsize', fontsize);
text(0.5, -0.09, 'Prob. of canonizing false claim', 'fontsize', fontsize, 'HorizontalAlignment', 'center');
text(-0.1, 0.5, 'Prob. of canonizing true claim', 'fontsize', fontsize, 'HorizontalAlignment', 'center', 'rotation', 90);
print(['../Figures/' outputfig '.eps'], '-depsc');
csvwrite(['../Data/' outputfig '.csv'], canT);
toc;