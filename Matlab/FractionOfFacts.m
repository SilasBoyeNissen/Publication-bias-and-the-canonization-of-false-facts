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
alpha = 0.05; % false positive rate (alpha)
beta = 0.2; % false negative rate (beta)
tau0 = 0.001; % lower threshold for cannonization
tau1 = 0.999; % upper threshold for cannonization

fontsize = 36;
outputfig = 'FractionOfFacts';
set(figure(1), 'Position', [300, 200, 1100, 550]);
ha = TightSubplot(1, 2, [0 0], [0.18 0.02], [0.1 0.01]);
p0array = [0.025 0.05 0.1 0.2 0.4 0.025 0.05 0.1 0.2 0.4];

for figno = 1:2
    axes(ha(figno));
    canT = zeros(101, 10);
    hypothesis = 0; % the hypothesis is actually false (0)
    if figno == 1;
        a = 0.07;
        leg = '0';
        figtitle = 'A';
        p0vary = false; % Vary the neg. publication rate?
    else
        a = 0.9;
        leg = 'b';
        figtitle = 'B';
        p0vary = true; % Vary the neg. publication rate?
    end
    for curve = 1:10
        if curve == 6
            hypothesis = 1; % the hypothesis is actually true (1)
        end
        p0v = p0array(curve);
        Calculator();
    end
    prob = zeros(101, 5);
    base = (1/100*q0n-1/100).';
    colors = [Hex2rgb('#ffffcc'); Hex2rgb('#c2e699'); Hex2rgb('#78c679'); Hex2rgb('#31a354'); Hex2rgb('#006837')];
    for i = 5:-1:1
        prob(:, i) = canT(:, i+5).*base(:, 1) ./ (canT(:, i+5).*base(:, 1) + canT(:, i).*(1-base(:, 1)));
        plot(0:1/100:1, prob(:, i), '.', 'Color', colors(i, :), 'MarkerSize', 25), hold on;
    end
    legend(['\rho_' leg '=.4'], ['\rho_' leg '=.2'], ['\rho_' leg '=.1'], ['\rho_' leg '=.05'], ['\rho_' leg '=.025'], 'Location', 'southeast', 'Orientation', 'vertical');
    text(a, 0.91, figtitle, 'FontSize', fontsize, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
    csvwrite(['../Data/' outputfig figtitle '.csv'], canT);
    set(gca, 'fontsize', fontsize);
    legend('boxoff');
    ylim([0 1]);
end

set(ha(1), 'XTick', [0 0.2 0.4 0.6 0.8]);
set(ha(2), 'XTick', [0 0.2 0.4 0.6 0.8 1]);
set(ha(1:2), 'YTick', [0 0.2 0.4 0.6 0.8 1]);
set(ha(2), 'YTickLabel', '');
text(0, -0.16, 'Base rate', 'fontsize', fontsize, 'HorizontalAlignment', 'center');
text(-1.2, 0.5, 'Fraction of facts being true', 'fontsize', fontsize, 'HorizontalAlignment', 'center', 'rotation', 90);
print(['../Figures/' outputfig '.eps'], '-depsc');
toc;