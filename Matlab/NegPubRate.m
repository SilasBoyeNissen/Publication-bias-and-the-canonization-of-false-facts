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

p0n = 1:101; % Number of negative publication rates tested
p0v = 0; % negative publication rate (0 means all tested)
p1 = 1; % publishing positive results rate
q0 = 0.5; % Initial belief of being true (0 means all tested)
q0n = 1; % Number of initial beliefs tested
p0vary = false; % Vary the neg. publication rate?
hypothesis = 0; % the hypothesis is actually false (0)
FPactual = 0;

fontsize = 40;
set(figure(1), 'Position', [300, 0, 1100, 950]);
ha = TightSubplot(2, 2, [0 0], [0.11 0.02], [0.11 0.02]);
colors = [Hex2rgb('#fef0d9'); Hex2rgb('#fdcc8a'); Hex2rgb('#fc8d59'); Hex2rgb('#e34a33'); Hex2rgb('#b30000')];
FParray = 0.05:0.05:0.25; % False positive rate (alpha)
xaxes = 'Negative publication rate';
outputfig = 'NegPubRate';

if p0vary == true
    outputfig = 'DynamicRho0';
    xaxes = 'Baseline of negative publication rate';
end

for figno = 1:4
    axes(ha(figno));
    canT = zeros(101, 5);
    if figno == 1;
        figtitle = 'A';
        beta = 0.2; % false negative rate (beta)
        tau0 = 0.1; % lower threshold for cannonization
        tau1 = 0.9; % upper threshold for cannonization
    elseif figno == 2;
        figtitle = 'B';
        beta = 0.4; % false negative rate (beta)
    elseif figno == 3;
        figtitle = 'C';
        beta = 0.2; % false negative rate (beta)
        tau0 = 0.001; % lower threshold for cannonization
        tau1 = 0.999; % upper threshold for cannonization
    else
        figtitle = 'D';
        beta = 0.4; % false negative rate (beta)
    end
    for curve = 5:-1:1;
        alpha = FParray(curve);
        Calculator();
        plot(0:1/100:1, canT(:, curve), '.', 'Color', colors(curve, :), 'MarkerSize', 25), hold on;
    end
    legend('\alpha=.25', '\alpha=.2', '\alpha=.15', '\alpha=.1', '\alpha=.05', 'Location', 'northeast', 'Orientation', 'vertical');
    text(0.5, 0.925, figtitle, 'FontSize', fontsize, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
    csvwrite(['../Data/' outputfig figtitle '.csv'], canT);
    set(gca, 'fontsize', fontsize);
    legend('boxoff');
    ylim([0 1]);
end

set(ha(1:2), 'XTickLabel', '');
set(ha(3), 'XTick', [0 0.2 0.4 0.6 0.8]);
set(ha(4), 'XTick', [0 0.2 0.4 0.6 0.8 1]);
set(ha(1:4), 'YTick', [0 0.2 0.4 0.6 0.8]);
set(ha(1), 'YTick', [0 0.2 0.4 0.6 0.8 1]);
set(ha([2 4]), 'YTickLabel', '');
text(0, -0.18, xaxes, 'fontsize', fontsize, 'HorizontalAlignment', 'center');
text(-1.2, 1, 'Probability of canonizing false claim as fact', 'fontsize', fontsize, 'HorizontalAlignment', 'center', 'rotation', 90);
print(['../Figures/' outputfig '.eps'], '-depsc');
toc;