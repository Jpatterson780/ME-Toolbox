%% Brittle Failure Theories Safety Factor Calculator
% Contributors: Josh Patterson
% Code Version 1.0
% Last Updated 11/8/2018

%% Initialization
clear; close all; clc;

%% Collect Data

% User inputs sigma and tau values
sigx=input('Input sigma x:  '); 
sigy=input('Input sigma y:  '); 
sigz=input('Input sigma z:  '); 
tauyz=input('Input tau yz:  '); 
tauxz=input('Input tau xz:  '); 
tauxy=input('Input tau xy:  ');
uts=input('Input the Ultimate Tensile Strength:  ');
ucs=input('Input the Ultimate Comressive Strength:  ');

%% Calculate Principle Stress

% Calculate invariants
I1= sigx + sigy + sigz;
I2 = sigx*sigy + sigy*sigz + sigx*sigz - tauxy^2 - tauyz^2 - tauxz^2; 
I3 = sigx*(sigy*sigz-tauyz^2) - tauxy*(tauxy*sigz-tauyz*tauxz)...
    + tauxz*(tauxy*tauyz-sigy*tauxz);
Iarr = [I1,I2,I3];

% Calculate A and B
A = (I1^2 - 3*I2)/9; 
B = (2*I1^3 - 9*I1*I2 + 27*I3)/54;

% Calculate angles (Check if A=0 and set phi=0 if true)
theta = acos(B/sqrt(A^3)); 
if A == 0
    phi = 0;
else
phi = (1/3)*acos((2*I1^3 - 9*I1*I2 + 27*I3)/(2*(I1^2 - 3*I2)^(3/2)));
end

% Calculate Sigma a, b, and c
siga = (I1/3) + (2/3)*sqrt(I1^2-3*I2)*cos(phi);
sigb = (I1/3) + (2/3)*sqrt(I1^2-3*I2)*cos(phi+2*pi/3);
sigc = (I1/3) + (2/3)*sqrt(I1^2-3*I2)*cos(phi+4*pi/3);

% Arrange Sigma a, b, and c to 1, 2, and 3
Sigma = sort([siga sigb sigc],'descend');

% Calculate Max Shear/Average Normal Stresses
tauMax(1) = (Sigma(1)-Sigma(3))/2;
sigAvg(1) = (Sigma(1)+Sigma(3))/2;
tauMax(2) = (Sigma(1)-Sigma(2))/2;
sigAvg(2) = (Sigma(1)+Sigma(2))/2;
tauMax(3) = (Sigma(2)-Sigma(3))/2;
sigAvg(3) = (Sigma(2)+Sigma(3))/2;

% Set Sigma values which are incredibly small to zero
absSigma = abs(Sigma);
for i = 1:3
    if absSigma(i) < .00001
        Sigma(i) = 0;
    end
end

%% Calculate MNS
mns(1) = Sigma(1)/uts;
mns(2) = -Sigma(3)/ucs;
mnsFS = 1/max(mns);

%% Calculate BCM
bcm(1) = Sigma(1)/uts;
bcm(2) = -Sigma(3)/ucs;
bcm(3) = bcm(1)+bcm(2);
bcmFS = 1/max(bcm);

%% Calculate MM
mm(1) = Sigma(1)/uts;
mm(2) = -Sigma(3)/ucs;
mm(3) = (((ucs-uts)*Sigma(1))/(ucs*uts))+mm(2);
mmFS = 1/max(mm);

%% Display Results
resultsSigma=table(Sigma(1),Sigma(2),Sigma(3),'VariableNames',{'Sigma1','Sigma2','Sigma3'});
fprintf('\n\n\nResults: \n\n');
disp(resultsSigma);
resultsI=table(I1,I2,I3,'VariableNames',{'I1','I2','I3'});
fprintf('\n\n\nResults: \n\n');
disp(resultsI);
resultsSF=table(mnsFS,bcmFS,mmFS,'VariableNames',{'MNS_SF','BCM_SF','MM_SF'});
fprintf('\n\n\nResults: \n\n');
disp(resultsSF);









