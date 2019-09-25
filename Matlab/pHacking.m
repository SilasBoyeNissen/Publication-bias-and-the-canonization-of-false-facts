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
canT = zeros(101, 5);
alpha = 0.05; % false positive rate (alpha)
beta = 0.2; % false negative rate (beta)
tau0 = 0.001; % lower threshold for cannonization
tau1 = 0.999; % upper threshold for cannonization

fontsize = 22;
outputfig = 'pHacking';
set(figure(1), 'Position', [300, 200, 600, 550]);
ha = TightSubplot(1, 1, [0 0], [0.11 0.01], [0.11 0.01]);
colors = [Hex2rgb('#fef0d9'); Hex2rgb('#fdcc8a'); Hex2rgb('#fc8d59'); Hex2rgb('#e34a33'); Hex2rgb('#b30000')];
FPaarray = 0.05:0.05:0.25; % Actual false positive rate (alpha_actual)
axes(ha(1));

for curve = 5:-1:1
    FPactual = FPaarray(curve);
    Calculator();
    plot(0:1/100:1, canT(:, curve), '.', 'Color', colors(curve, :), 'MarkerSize', 25), hold on;
end

legend('\alpha_{act}=.25', '\alpha_{act}=.2', '\alpha_{act}=.15', '\alpha_{act}=.1', '\alpha_{act}=.05', 'Location', 'northeast', 'Orientation', 'vertical');
legend('boxoff');
ylim([0 1]);
set(ha(:), 'XTick', 0:0.2:1);
set(ha(:), 'YTick', 0:0.2:1);
set(gca, 'fontsize', fontsize);
text(0.5, -0.09, 'Negative publication rate', 'fontsize', fontsize, 'HorizontalAlignment', 'center');
text(-0.1, 0.5, 'Probability of canonizing false claim as fact', 'fontsize', fontsize, 'HorizontalAlignment', 'center', 'rotation', 90);
print(['../Figures/' outputfig '.eps'], '-depsc');
csvwrite(['../Data/' outputfig '.csv'], canT);
toc;