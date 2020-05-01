%% Program Description
%
% Authors: Zachary Markow, Muriah Wheelock
% Last Updated 27 March 2020.
%
% Script with MATLAB examples accompanying the 27 March 2020 presentation
% on statistics in the Culver Lab's Machine Learning Coffee Hour.
%


%% Set random number generator to get same values as on slides.

rng(2);


%% Other settings for plot appearance.

fontSize = 14;
lineWidth = 2;


%% z-scoring and Outlier Identification

n = 500;
sampleData = [1150 + 200.*randn(n,1); repmat(1750,10,1)];
sampleMean = mean(sampleData);
sampleSD = std(sampleData);
sampleData_zScore = (sampleData - sampleMean) ./ sampleSD;

%binEdges = 200:50:1800;
nBins = 20;
[hcounts,binEdges] = histcounts(sampleData, nBins);
[hcounts_zscore, binEdges_zscore] = histcounts(sampleData_zScore, nBins);
binCenters = (binEdges(1:(end-1)) + binEdges(2:end)) ./ 2;
binCenters_zscore = (binEdges_zscore(1:(end-1)) + binEdges_zscore(2:end)) ./ 2;

fontSize = 14;

figure;
%subplot(1,2,1)
%stem(binCenters, hcounts, 'bo');
histogram(sampleData, nBins);
xlabel('SAT Score')
ylabel('Number of People')
set(findall(gcf,'-property','FontSize'),'FontSize',fontSize)
saveas(gcf,'zScoringAndOutlierCheck_original.png','png')

figure;
%subplot(1,2,1)
%stem(binCenters, hcounts, 'bo');
histogram(sampleData_zScore, nBins);
xlabel('z-Scored SAT Score')
ylabel('Number of People')
set(findall(gcf,'-property','FontSize'),'FontSize',fontSize)
saveas(gcf,'zScoringAndOutlierCheck_zscore.png','png')


%% 1-Sample t-Test

% Alternative hypothesis: The 20 people in a room have an average resting
% heart rate higher than the population average of 80 beats per minute.

% Null hypothesis: Sample mean <= Population mean.

fontSize = 14;

n = 36;
heartRates = 85 + 10.*randn(n,1);  % Heart rates of people in room.
popMeanHR = 80;
[h,p,~,stats] = ttest(heartRates, popMeanHR, 'Tail', 'right');
manual_tstat = (mean(heartRates)-popMeanHR) / (std(heartRates)/sqrt(n));

figure;
nBins = 9;
histogram(heartRates);
xlabel('Heart Rate (bpm)')
ylabel('Number of People')
title({['Does Sample Mean HR Differ from ' num2str(popMeanHR) ' bpm?'], ['tStat = ' num2str(stats.tstat) ', p = ' num2str(p)]})
set(findall(gcf,'-property','FontSize'),'FontSize',fontSize)
saveas(gcf,'OneSampleTTest.png','png')


%% PDF vs. CDF

n = 100;
sampleData = 1100 + 200.*randn(n,1);

nBins1 = 10;
[hcounts1,binEdges1] = histcounts(sampleData,nBins1);
PMF1 = hcounts1 ./ n;
binCenters1 = (binEdges1(1:(end-1)) + binEdges1(2:end)) ./ 2;
CDF1 = cumsum(PMF1);

nBins2 = 20;
[hcounts2,binEdges2] = histcounts(sampleData,nBins2);
PMF2 = hcounts2 ./ n;
binCenters2 = (binEdges2(1:(end-1)) + binEdges2(2:end)) ./ 2;
CDF2 = cumsum(PMF2);

figure;

subplot(2,1,1)
%plot(binCenters1, PMF1, 'b-', 'LineWidth', lineWidth);
histogram(sampleData,nBins1,'FaceColor',[0 0 0.8]);
hold on
%plot(binCenters2, PMF2, 'r-', 'LineWidth', lineWidth);
histogram(sampleData,nBins2,'FaceColor',[0.8 0 0]);
xlabel('x')
ylabel('Number of Values')
title('Histogram')
legend([num2str(nBins1) ' bins'], [num2str(nBins2) ' bins'], 'Location', 'NorthWest');

subplot(2,1,2)
plot(binCenters1, CDF1, 'b-', 'LineWidth', lineWidth);
hold on
plot(binCenters2, CDF2, 'r-', 'LineWidth', lineWidth);
xlabel('x')
ylabel('P(X \leq x)')
title('CDF')
legend([num2str(nBins1) ' bins'], [num2str(nBins2) ' bins'], 'Location', 'NorthWest');

set(findall(gcf,'-property','FontSize'),'FontSize',fontSize)

saveas(gcf,'PDFvsCDFvsBinSize.png','png')


%% 1-Sample Kolmogorov-Smirnov test for Gaussianity

dz = 0.1;
zVals = (-5):dz:5;
standardNormalPDF = exp(-0.5.*(zVals.^2)) ./ sqrt(2*pi);
standardNormalCDF = cumsum(standardNormalPDF) .* dz;

n = 50;
normalSamp = randn(n,1);  % From Gaussian with mean 0 and variance 1.
nonnormalSamp = 6.*(rand(n,1)-0.5);  % From uniform distribution between -3 to 3.

[h0_normalSamp_KS, p_normalSamp] = kstest(normalSamp);
[h0_nonnormalSamp_KS, p_nonnormalSamp] = kstest(nonnormalSamp);

normalSampCDF = sum(bsxfun(@le,normalSamp,zVals), 1) ./ n;
nonnormalSampCDF = sum(bsxfun(@le,nonnormalSamp,zVals), 1) ./ n;

nBins = 9;
fontSize = 14;
lineWidth = 2;

figure;
histogram(normalSamp,nBins,'FaceColor',[0 0 0.8],'FaceAlpha',0.5);
hold on;
histogram(nonnormalSamp,nBins,'FaceColor',[0.8 0 0],'FaceAlpha',0.5);
xlabel('z')
ylabel('Number of Values')
title({'Histograms of 2 Samples', ['Sample 1 KS Test p = ' num2str(p_normalSamp)], ['Sample 2 KS Test p = ' num2str(p_nonnormalSamp)]})
legend('Sample 1', 'Sample 2', 'Location', 'NorthWest');
set(findall(gcf,'-property','FontSize'),'FontSize',fontSize)
saveas(gcf,'OneSampleKSTestHists.png','png')

figure;
plot(zVals, normalSampCDF, 'b-', 'LineWidth', lineWidth);
hold on;
plot(zVals, nonnormalSampCDF, 'r-', 'LineWidth', lineWidth);
plot(zVals, standardNormalCDF, 'k--', 'LineWidth', lineWidth);
xlabel('z')
ylabel('Number of Values')
title({'CDFs', ['Sample 1 KS Test p = ' num2str(p_normalSamp)], ['Sample 2 KS Test p = ' num2str(p_nonnormalSamp)]})
legend('Sample 1', 'Sample 2', 'Standard Gaussian', 'Location', 'NorthWest');
set(findall(gcf,'-property','FontSize'),'FontSize',fontSize)
saveas(gcf,'OneSampleKSTestCDFs.png','png')


%% 2-sample Welch's t-test when sample variances are unequal.

nA = 100;
nB = 150;
sampleA = 1250 + 100.*randn(nA,1);
sampleB = 1150 + 200.*randn(nB,1);

% Check whether variances are equal.
[hVartest,pVartest] = vartest2(sampleA,sampleB);

% Variances are not equal, so use Welch's t test.
[h0_Welch, p_Welch, ~, stats_Welch] = ttest2(sampleA, sampleB, 'Vartype', 'unequal');

% Plot.
nBins = 15;
figure;
histogram(sampleA,nBins,'FaceColor',[0 0 0.8],'FaceAlpha',0.5)
hold on
histogram(sampleB,nBins,'FaceColor',[0.8 0 0],'FaceAlpha',0.5)
xlabel('SAT Score')
ylabel('Number of People')
title({'Histograms',['vartest2 p = ' num2str(pVartest)],['Welch''s 2-tailed p = ' num2str(p_Welch)]});
legend('Sample A', 'Sample B', 'Location', 'NorthWest');
set(findall(gcf,'-property','FontSize'),'FontSize',fontSize)
saveas(gcf,'TwoSampleWelchttest.png','png')


%% 2-sample KS test on same dataset.

% Variances are not equal, so use Welch's t test.
[h0_KS2, p_KS2] = kstest2(sampleA, sampleB);

% Calculate CDFs.
nBins = 15;
[hcA,binEdgesA] = histcounts(sampleA,nBins);
[hcB,binEdgesB] = histcounts(sampleB,nBins);
CDF_A = cumsum(hcA)./nA;
CDF_B = cumsum(hcB)./nB;
binCentersA = (binEdgesA(1:(end-1)) + binEdgesA(2:end)) ./ 2;
binCentersB = (binEdgesB(1:(end-1)) + binEdgesB(2:end)) ./ 2;

% Plot.
figure;
plot(binCentersA,CDF_A,'b-','LineWidth',lineWidth);
hold on
plot(binCentersB,CDF_B,'r-','LineWidth',lineWidth);
xlabel('SAT Score')
ylabel('Frac of People with Lower Score')
title({'CDFs', ['2-sample KS test p = ' num2str(p_KS2)]});
legend('Sample A', 'Sample B', 'Location', 'NorthWest');
set(findall(gcf,'-property','FontSize'),'FontSize',fontSize)
saveas(gcf,'TwoSampleKSTest.png','png')


%% 2-Sample t-Test, 2-Sample KS test, and Effect Size vs. Statistical Significance

% Generate example dataset of SAT scores from 2 groups of students.
nA = 2500;  nB = 2500;
groupA = 1250 + 200.*randn(nA,1);  % Population is Gaussian with "true" mean 1250 and SD 200.
groupB = 1200 + 200.*randn(nB,1);  % Population is Gaussian with "true" mean 1200 and SD 200.

meanA = mean(groupA);  meanB = mean(groupB);
SD_A = std(groupA);  SD_B = std(groupB);
SD_pooledEst = sqrt( ((nA-1)*(SD_A^2) + (nB-1)*(SD_B^2)) / (nA+nB-2) );  % Gives more weight/trust to the SD estimate from the larger sample if one is larger.

Cohens_d_AKA_CNR = (meanA-meanB) ./ SD_pooledEst;  % Measure of effect size: difference in means relative to spread/variance in samples.

% Use vartest2 to see if variances are equal before assuming that they are.
% Alternative hypothesis: Variances differ.
% Null hypothesis: Variances are equal.
[hVartest,pVartest] = vartest2(groupA,groupB);

% Test whether samples A and B were drawn from populations with different
% means (two-tailed test).  Null hypothesis is that the population/"true"
% means are the equal.  Sample variances are equal, so use standard
% independent-samples t-test (not Welch's t; for Welch, set 'Vartype' to
% 'unequal').
[h0,p,~,stats] = ttest2(groupA,groupB,'Vartype','equal','Tail','both');

nBins1 = 20;
[hc_A,binEdgesA] = histcounts(groupA,nBins1);
binCentersA = (binEdgesA(1:(end-1)) + binEdgesA(2:end)) ./ 2;
[hc_B,binEdgesB] = histcounts(groupB,nBins1);
binCentersB = (binEdgesB(1:(end-1)) + binEdgesB(2:end)) ./ 2;

fontSize = 14;
lineWidth = 2;
figure;
plot(binCentersA,hc_A,'b-','LineWidth',2);
hold on;
plot(binCentersB,hc_B,'r-','LineWidth',2);
title({'Histograms of Samples A and B', ['p(equal variances|data) = ' num2str(pVartest)], ['Cohen''s d (Measure of CNR) = ' num2str(Cohens_d_AKA_CNR)], ['tStat = ', num2str(stats.tstat) ', p-Value = ' num2str(p)]})
xlabel('SAT Score')
ylabel('Number of People')
legend('Group A','Group B','Location','NorthEast');
set(findall(gcf,'-property','FontSize'),'FontSize',fontSize)

saveas(gcf,'EffectSizeVsPValue.png','png')


%% Now use Kolmogorov-Smirnov test of whether those 2 samples are from same distribution.

[h0_KS,p_KS,stats_KS] = kstest2(groupA,groupB);
CDF_A = cumsum(hc_A) ./ nA;
CDF_B = cumsum(hc_B) ./ nB;

Cohens_d_KS = stats_KS / sqrt(nA*nB / (nA+nB));

figure;
plot(binCentersA,CDF_A,'b-','LineWidth',2);
hold on;
plot(binCentersB,CDF_B,'r-','LineWidth',2);
xlabel('SAT Score')
ylabel('Fraction of People with Lower Score')
title({'Histograms of Samples A and B', ['KS Test: p(samples come from same dist | data) = ' num2str(p_KS)], ['Cohen''s d = ' num2str(Cohens_d_KS)]});
set(findall(gcf,'-property','FontSize'),'FontSize',fontSize)
saveas(gcf,'EffectSizeVsPValue_KS.png','png')


%% Perform a permutation test to evaluate whether two samples were drawn from distributions with the same mean.

dx = 0.01;
xVals = 0:dx:1;

n1 = 20;  n2 = 25;  nTotal = n1 + n2;
sample1 = rand(n1,1);  % From uniform distribution between 0 and 1 with mean and median 0.5.
sample2 = 0.3 + randn(n2,1);  % From Gaussian distribution with mean and median 0.3 and variance 1.

m1 = mean(sample1);  m2 = mean(sample2);
diffm_observed = m1 - m2;

% Pool values together and create array of labels identifying which sample
% each value belonged to.
combinedSamples = [sample1; sample2];
sampleIDs = [repmat(1,n1,1); repmat(2,n2,1)];

nPerms = 10000;  % Number of permutations to evaluate.

% Null hypothesis: population mean 1 <= population mean 2.
% Alternative: population mean 1 > population mean 2.

% Will calculate difference in means between samples after mixing up
% labels identifying which value each sample belongs to.
diffm_nullDist = NaN(nPerms,1);  % Preallocate.
for permNum = 1:nPerms
    sampleIDs_perm = sampleIDs(randperm(nTotal));
    m1_perm = mean(combinedSamples(sampleIDs_perm == 1));
    m2_perm = mean(combinedSamples(sampleIDs_perm == 2));
    diffm_nullDist(permNum) = m1_perm - m2_perm;
end

% Calculate p-value: probability of observing a difference in means at
% least as high as seen in the unpermuted samples.
p_diffm_perm = sum(diffm_nullDist > diffm_observed) ./ nPerms;

% Plot null distribution and true value of difference in means.
nBins = 20;
figure;
histogram(diffm_nullDist, nBins);
hold on
yLimVals = get(gca,'YLim');
plot(repmat(diffm_observed,1,2), yLimVals, 'm-', 'LineWidth', lineWidth);
title({'Differences in means', ['Permutation Test p-Value = ' num2str(p_diffm_perm)]})
xlabel('Sample 1 mean - Sample 2 mean')
ylabel('Number of Permutations')
legend('Null/Perm Dist', 'Observed Value', 'Location', 'NorthEast');
set(findall(gcf,'-property','FontSize'),'FontSize',fontSize)
saveas(gcf,'PermTestDiffM.png','png')
