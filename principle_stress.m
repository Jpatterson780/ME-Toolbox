%% 3D Principle Stress Calculator

% Contributors: Josh Patterson

% Code Version 1.2

% Last Updated 11/1/2018

% Mohr's Circle Code portion orginally created by Dr. Robert Sorem -
% slightly modified as to fit this code


%% Initialization
clear; close all; clc;

%% Gather Data

% User inputs sigma and tau values
sigx=input('Input sigma x:  '); 
sigy=input('Input sigma y:  '); 
sigz=input('Input sigma z:  '); 
tauyz=input('Input tau yz:  '); 
tauxz=input('Input tau xz:  '); 
tauxy=input('Input tau xy:  ');
%prompt='Input the units:  ';
UnitLabel=input('Input the units:  ', 's');

%% Calculation

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
for i = 1:3
    if Sigma(i) < .00001
        Sigma(i) = 0;
    end
end

%% Results

% Pre-Allocate matrices for the sake of calculation speed
PSvLabel = {'','',''};
TMvLabel = {'','',''};
SIvLabel = {'','',''};

% Display a table of desired values
results=table(Sigma(1),Sigma(2),Sigma(3),tauMax(1),sigAvg(1),...
    'VariableNames',{'Sigma1','Sigma2','Sigma3','TauMax','SigmaAvg'});
fprintf('\n\n\nResults: \n\n');
disp(results);
disp('');
disp('');

% Plot Mohr's Cirle - Edited version from Dr. Robert Sorem

% Create Data Lables
TauMaxLabel(1) = {'\tau_{13,max}'}; 
TauMaxLabel(2) = {'\tau_{12,max}'}; 
TauMaxLabel(3) = {'\tau_{23,max}'};
TauMinLabel(1) = {'\tau_{13,min}'}; 
TauMinLabel(2) = {'\tau_{12,min}'}; 
TauMinLabel(3) = {'\tau_{23,min}'};
SigmaLabel(1) = {'\sigma_1'}; 
SigmaLabel(2) = {'\sigma_2'}; 
SigmaLabel(3) = {'\sigma_3'};
SigmaAVGLabel(1) = {'\sigma_{13,avg}'}; 
SigmaAVGLabel(2) = {'\sigma_{12,avg}'}; 
SigmaAVGLabel(3) = {'\sigma_{23,avg}'};
InvariantLabel(1) = {'I_1'}; 
InvariantLabel(2) = {'I_2'}; 
InvariantLabel(3) = {'I_3'};

% Set the plot colors
PColor(1) = 'b';    % blue
PColor(2) = 'r';    % red
PColor(3) = 'm';    % magenta

% Set the center and radius of the largest circle
RadiusMax = tauMax(1);
CenterMax = sigAvg(1);

% Setting up the plot
hold on
axis normal
xmax = 2.25;
xmin = -1.25;
ymax = 1.25;
ymin = -1.25;
ylim([ymin*RadiusMax, ymax*RadiusMax])
xlim([CenterMax+xmin*RadiusMax, CenterMax+xmax*RadiusMax])
plot([CenterMax+ymin*RadiusMax, CenterMax+ymax*RadiusMax],[0, 0],'k-') % line through tau=0
plot([0, 0],[CenterMax+xmin*RadiusMax, CenterMax-xmin*RadiusMax],'k-') % line through sigma=0
grid on;
set(gca,'YDir', 'reverse'); % define the y-axis as positive downward

% Plot the Mohr's Circles and label the plot
for i = 1:3
    % Plot the Circles and the markers    
    c_handle = circle([sigAvg(i),0],tauMax(i),100,'-k');
    set(c_handle,'Color',PColor(i),'LineWidth',2)
    plot(sigAvg(i),0,'ko','MarkerFaceColor',PColor(i))   % Center
    plot(sigAvg(i),tauMax(i),'ko','MarkerFaceColor',PColor(i))   % Tau_max
    plot(sigAvg(i),-tauMax(i),'ko','MarkerFaceColor',PColor(i))  % Tau_min (negative)
    plot(sigAvg(i), 0, 'ko','MarkerFaceColor','black')   % sigma_1
    % Annotate graph
    text(sigAvg(i),tauMax(i)+0.055*tauMax(1),TauMaxLabel(i),...
         'HorizontalAlignment','center','FontSize',18,'Color', PColor(i)) % Tau Max
    text(sigAvg(i),-(tauMax(i)+0.105*tauMax(1)),TauMinLabel(i),...
         'HorizontalAlignment','center','FontSize',18,'Color', PColor(i)) % Tau Min
    text(Sigma(i)+0.1*tauMax(1),tauMax(1)/12,SigmaLabel(i),...
         'HorizontalAlignment','center','FontSize',18)  % Principal Stresses
end

% Create Legend
for j = 1:3
    PSvLabel(j) = strcat(SigmaLabel(j), {' = '}, num2str(Sigma(j)),...
        {' '},UnitLabel);
    TMvLabel(2*j-1) = strcat(TauMaxLabel(j), {' = '}, num2str(tauMax(j)),...
        {' '},UnitLabel);
    TMvLabel(2*j) = strcat({'   '},SigmaAVGLabel(j), {' = '},...
        num2str(sigAvg(j)), {' '},UnitLabel);
    SIvLabel(j) = strcat(InvariantLabel(j), {' = '}, num2str(Iarr(j)),...
        {' '},UnitLabel);
end
text(Sigma(1)+0.3*tauMax(1),(-0.35)*tauMax(1),PSvLabel,...
    'EdgeColor', [0 0 0],'HorizontalAlignment','left',...
    'Margin',5,'LineWidth',2,'FontSize',16, 'BackgroundColor', 'w')
text(Sigma(1)+0.3*tauMax(1),(0.6)*tauMax(1),TMvLabel,...
    'EdgeColor', [0 0 0],'HorizontalAlignment','left',...
    'Margin',5,'LineWidth',2,'FontSize',16, 'BackgroundColor', 'w')
text(Sigma(1)+0.3*tauMax(1),(-0.9)*tauMax(1),SIvLabel,...
    'EdgeColor', [0 0 0],'HorizontalAlignment','left',...
    'Margin',5,'LineWidth',2,'FontSize',16, 'BackgroundColor', 'w')

% Label axes and set the plot size
XLabelS = strcat('\sigma (', UnitLabel, ')');
YLabelT = strcat('\tau (', UnitLabel, ')');
set(gca,'LineWidth',2,'FontSize',24,'FontWeight','normal','FontName','Times')
set(get(gca,'XLabel'),'String',XLabelS,'FontSize',24,'FontWeight','bold','FontName','Times')
set(get(gca,'YLabel'),'String',YLabelT,'FontSize',24,'FontWeight','bold','FontName','Times')
scrsize = get(0,'ScreenSize');
set(gcf,'Position',[100 100 1200 800])
daspect ([1 1 1]);
hold off



