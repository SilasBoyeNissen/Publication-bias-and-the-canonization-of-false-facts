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

p0n = 1; % Number of negative publication rates tested
p0v = 0.1; % negative publication rate (0 means all tested)
p1 = 1; % publishing positive results rate
q0 = 0; % Initial belief of being true (0 means all tested)
q0n = 1:101; % Number of initial beliefs tested
p0vary = false; % Vary the neg. publication rate?
hypothesis = 0; % the hypothesis is actually false (0)
FPactual = 0;

fontsize = 40; % 34
outputfig = 'InitialBeliefs';
set(figure(1), 'Position', [300, 0, 1100, 950]);
ha = TightSubplot(2, 2, [0 0], [0.11 0.06], [0.11 0.02]);
colors = [Hex2rgb('#ffffcc'); Hex2rgb('#c2e699'); Hex2rgb('#78c679'); Hex2rgb('#31a354'); Hex2rgb('#006837')];

for figno = 1:4
    axes(ha(figno));
    canT = zeros(101, 5);
    if figno == 1;
        figtitle = 'A';
        p0array = [0.025 0.05 0.1 0.2 0.4];
        alpha = 0.05; % false positive rate (alpha)
        beta = 0.2; % false negative rate (beta)
        tau0 = 0.1; % lower threshold for cannonization
        tau1 = 0.9; % upper threshold for cannonization
    elseif figno == 2;
        figtitle = 'B';
        p0array = [0.1 0.3 0.4 0.5 1];
        alpha = 0.2; % false positive rate (alpha)
        beta = 0.4; % false negative rate (beta)
    elseif figno == 3;
        figtitle = 'C';
        p0array = [0.025 0.05 0.1 0.2 0.4];
        alpha = 0.05; % false positive rate (alpha)
        beta = 0.2; % false negative rate (beta)
        tau0 = 0.001; % lower threshold for cannonization
        tau1 = 0.999; % upper threshold for cannonization
    else
        figtitle = 'D';
        p0array = [0.1 0.3 0.4 0.5 1];
        alpha = 0.2; % false positive rate (alpha)
        beta = 0.4; % false negative rate (beta)
    end
    for curve = 1:5;
        p0v = p0array(curve);
        Calculator();
        plot(0:1/100:1, canT(:, curve), '.', 'Color', colors(curve, :), 'MarkerSize', 25), hold on;
    end
    if figno == 1
        legend({'$\rho_0$=.025', '.05', '.1', '.2', '.4'}, 'Position', [-0.19, 0.47, 1, 1], 'Orientation', 'horizontal', 'Interpreter', 'latex', 'FontSize', fontsize)
    elseif figno == 2
        legend({'$\rho_0$=.1', '.3', '.4', '.5', '1'}, 'Position', [0.26, 0.47, 1, 1], 'Orientation', 'horizontal', 'Interpreter', 'latex', 'FontSize', fontsize);
    end
    text(0.08, 0.92, figtitle, 'FontSize', fontsize, 'FontWeight', 'bold', 'HorizontalAlignment', 'center')
    csvwrite(['../Data/' outputfig figtitle '.csv'], canT);
    set(gca, 'fontsize', fontsize);
    legend('boxoff')
end

set(ha(1:2), 'XTickLabel', '');
set(ha(3), 'XTick', [0 0.2 0.4 0.6 0.8]);
set(ha(4), 'XTick', [0 0.2 0.4 0.6 0.8 1]);
set(ha(1:4), 'YTick', [0 0.2 0.4 0.6 0.8]);
set(ha(1), 'YTick', [0 0.2 0.4 0.6 0.8 1]);
set(ha([2 4]), 'YTickLabel', '');
text(0, -0.2, 'Prior belief of being true', 'fontsize', fontsize, 'HorizontalAlignment', 'center');
text(-1.21, 1, 'Probability of canonizing false claim as fact', 'fontsize', fontsize, 'HorizontalAlignment', 'center', 'rotation', 90);
print(['../Figures/' outputfig '.eps'], '-depsc');
toc;