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

FPactual = 0;
p0n = 1:101; % Number of negative publication rates tested
p0v = 0; % negative publication rate (0 means all tested)
p1 = 1; % publishing positive results rate
q0 = 0.5; % Initial belief of being true (0 means all tested)
q0n = 1; % Number of initial beliefs tested
p0vary = false; % Vary the neg. publication rate?
hypothesis = 0; % the hypothesis is actually false (0)
beta = 0.2; % false negative rate (beta)

fontsize = 36;
outputfig = 'EvidentiaryStandards';
set(figure(1), 'Position', [300, 200, 1100, 550]);
ha = TightSubplot(1, 2, [0 0], [0.18 0.02], [0.15 0.01]);
colors = [Hex2rgb('#fdcc8a'); Hex2rgb('#fc8d59'); Hex2rgb('#e34a33')];
qlarray = [0.1 0.01 0.001];
quarray = [0.9 0.99 0.999];

for figno = 1:2
    axes(ha(figno));
    canT = zeros(101, 3);
    if figno == 1;
        figtitle = 'A';
        alpha = 0.05; % false positive rate (alpha)
    else
        figtitle = 'B';
        alpha = 0.25; % false positive rate (alpha)
    end
    for curve = 1:3;
        tau0 = qlarray(curve); % lower threshold for cannonization
        tau1 = quarray(curve); % upper threshold for cannonization
        Calculator();
        plot(0:1/100:1, canT(:, curve), '.', 'Color', colors(curve, :), 'MarkerSize', 25), hold on;
    end
    legend('\tau_0=.1', '\tau_0=.01', '\tau_0=.001', 'Location', 'northeast', 'Orientation', 'vertical');
    text(0.5, 0.925, figtitle, 'FontSize', fontsize, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
    csvwrite(['../Data/' outputfig figtitle '.csv'], canT);
    set(gca, 'fontsize', fontsize);
    legend('boxoff');
    ylim([0 1]);
end

set(ha(1), 'XTick', [0 0.2 0.4 0.6 0.8]);
set(ha(2), 'XTick', [0 0.2 0.4 0.6 0.8 1]);
set(ha(1:2), 'YTick', [0 0.2 0.4 0.6 0.8 1]);
set(ha(2), 'YTickLabel', '');
text(0, -0.16, 'Negative publication rate', 'fontsize', fontsize, 'HorizontalAlignment', 'center');
text(-1.25, 0.49, ['Probability of canonizing' char(10) 'false claim as fact'], 'fontsize', fontsize, 'HorizontalAlignment', 'center', 'rotation', 90);
print(['../Figures/' outputfig '.eps'], '-depsc');
toc;