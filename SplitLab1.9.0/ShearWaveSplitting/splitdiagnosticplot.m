function splitdiagnosticplot(SG, SH, QT, ...
                             extime,...
                             w,...
                             incli,...
                             strikes,...
                             sampling,...
                             gamma,...  %angle between SG and Initial polarisation
                             phiRC, dtRC, Cmatrix, corFSrc, QTcorRC,SG_SH_corRC,...
                             phiSC, dtSC, Ematrix, corFSsc, QTcorSC,SG_SH_corSC,...
                             phiEV, dtEV,...
                             LevelSC, LevelRC, LevelEV,...
                             splitoption, Qvector, bestfilter,...
                             allFasts,allDelays)

global thiseq config


maxtime = (size(Ematrix,2)-1) * config.StepsDT * thiseq.dt;
Synfig  = findobj('Name', 'Diagnostic Viewer','Type','figure');

if isempty(Synfig)
    S = get(0,'Screensize');
    Synfig = figure('Name', 'Diagnostic Viewer',...
                    'Renderer',        'painters',...
                    'Color',           'w',...
                    'NumberTitle',     'off',...
                    'MenuBar',         'none',...
                    'PaperType',       config.PaperType,...
                    'PaperOrientation','landscape',...
                    'PaperUnits',      'centimeter',...
                    'Position',        [.01*S(3) .1*S(4) .98*S(3) .75*S(4)]);
else
    figure(Synfig)
    clf
    set(Synfig,'PaperOrientation','landscape',...
        'PaperType', config.PaperType)
end

orient landscape
colormap(gray)

fontsize = get(gcf,'FactoryAxesFontsize')-1;
titlefontsize = fontsize+2;

%%
[axH, axRC, axSC, axSeis] = splitdiagnosticLayout(Synfig);
splitdiagnosticSetHeader(axH, ...
                         phiRC, dtRC, phiSC, dtSC, phiEV, dtEV,...
                         strikes, thiseq.inipol,incli,...
                         splitoption,bestfilter,gamma);
                    
                     
%%
switch splitoption
    case 'Minimum Energy'
        Ematrix   = Ematrix(:,:,1);
        optionstr ='Minimum Energy';
        phi       = phiSC(1);
        dphi      = phiSC(2);
        strike    = strikes(2);
        dt        = dtSC(1);
        Level     = LevelSC;
        Maptitle  = 'Energy Map of T';
        allFasts  = allFasts(:,[1 2]);
        allDelays = allDelays(:,[1 2]);

    case 'Eigenvalue: min(lambda1 * lambda2)'
        Ematrix   = Ematrix(:,:,2);
        optionstr ='Minimum \lambda1 * \lambda2';
        phi       = phiEV(1);
        dphi      = phiEV(2);
        strike    = strikes(3);
        dt        = dtEV(1);
        Level     = LevelEV;
        Maptitle  = 'Map of Eigenvalues \lambda1 * \lambda2';
        allFasts  = allFasts(:,[1 3]);
        allDelays = allDelays(:,[1 3]);

    case 'Eigenvalue: min(lambda2 / lambda1)'
        Ematrix   = Ematrix(:,:,2);
        optionstr = 'Minimum   \lambda2 / \lambda1';
        phi       = phiEV(1);
        dphi      = phiEV(2);
        strike    = strikes(3);
        dt        = dtEV(1);
        Level     = LevelEV;
        Maptitle  = 'Map of Eigenvalues \lambda2 / \lambda1';
        allFasts  = allFasts(:,[1 3]);
        allDelays = allDelays(:,[1 3]);
        
    case 'Eigenvalue: max(lambda1 / lambda2)'
        Ematrix   = Ematrix(:,:,2);
        optionstr = 'Maximum   \lambda1 / \lambda2';
        phi       = phiEV(1);
        dphi      = phiEV(2);
        strike    = strikes(3);
        dt        = dtEV(1);
        Level     = LevelEV;
        Maptitle  = 'Map of Eigenvalues \lambda1 / \lambda2';
        allFasts  = allFasts(:,[1 3]);
        allDelays = allDelays(:,[1 3]);
 
    case 'Eigenvalue: min(lambda2)'
        Ematrix   = Ematrix(:,:,2);
        optionstr ='Minimum  \lambda2';
        phi       = phiEV(1);
        dphi      = phiEV(2);
        strike    = strikes(3);
        dt        = dtEV(1);
        Level     = LevelEV;
        Maptitle  = 'Map of Eigenvalue \lambda2';
        allFasts  = allFasts(:,[1 3]);
        allDelays = allDelays(:,[1 3]);

    case 'Eigenvalue: max(lambda1)'
        Ematrix   = Ematrix(:,:,2);
        optionstr = 'Maximum  \lambda1';
        dphi      = phiEV(2);
        phi       = phiEV(1);
        strike    = strikes(3);
        dt        = dtEV(1);
        Level     = LevelEV;
        Maptitle  = 'Map of Eigenvalue \lambda1';
        allFasts  = allFasts(:,[1 3]);
        allDelays = allDelays(:,[1 3]);
end


if strcmpi(config.studytype,'Teleseismic')
    yystr= {'E ', 'N '}; 
    if strcmp(config.inipoloption,'fixed')
        B        = mod(           thiseq.bazi,  90);  % backazimuth lines
	else
        B        = mod(           thiseq.inipol, 90); 
    end
    
    % to shift phis interval from 0...180 back to -90...90
    if phi > 90
        phi = -180 + phi;
    elseif phi < -90
        phi = 180 - phi;
    end
    
    if phiRC(1) > 90
        phiRC(1) = -180 + phiRC(1);
    elseif phiRC(1) < -90
        phiRC(1) = 180 - phiRC(1);
    end
    
    if phiSC(1) > 90
        phiSC(1) = -180 + phiSC(1);
    elseif phiSC(1) < -90
        phiSC(1) = 180 - phiSC(1);
    end
    
    if phiEV(1) > 90
        phiEV(1) = -180 + phiEV(1);
    elseif phiEV(1) < -90
        phiEV(1) = 180 - phiEV(1);
    end    
    
else
    if strcmp(config.inipoloption, 'fixed')
        B     = mod(thiseq.bazi,90); %backazimuth lines
        yystr = {'T ', 'Q '};
    else
        B     = mod(gamma,90);       %backazimuth lines
        yystr = {'SH', 'SG'};
    end
end


%% x-values for seismogram plots
s = size(QTcorRC, 1);     %selection length
t = (0:(s-1))*sampling;


%%  Rotation-Correlation Method  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fast/slow seismograms
axes(axRC(1))
sumFS1 = sum(abs( corFSrc(:,1) -corFSrc(:,2)));
sumFS2 = sum(abs(-corFSrc(:,1) -corFSrc(:,2)));
if ( sumFS1 < sumFS2 )
    sig = 1;
else
    sig = -1;
end
m1 = max(abs( corFSrc(:,1)));
m2 = max(abs( corFSrc(:,2)));
plot(t, sig*corFSrc(:,2)/m2, 'r-', t, corFSrc(:,1)/m1, 'b--', 'LineWidth',1);
xlim([t(1) t(end)])
title(['Fast (..) & shifted Slow (-)'], 'FontSize', titlefontsize);
set(gca,'Ytick' , [-1 0 1])
ylabel('Rotation-Correlation', 'FontSize', titlefontsize)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Corrected seismograms
axes(axRC(2))
plot(t, QTcorRC(:,2) ,'r-', t, QTcorRC(:,1),'b--', 'LineWidth',1);
title(['corrected Q (..) & T (-)'], 'FontSize', titlefontsize);
xlim([t(1) t(end)])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Surface Particle motion
axes(axRC(3))
hold on

% errorwedge
pts = linspace(strikes(1)-phiRC(2), strikes(1)+phiRC(2), 10) /180*pi;
Y_ew = cos(pts);
X_ew = sin(pts);

% strike line
X = sind(strikes(1));
Y = cosd(strikes(1));

% particle motions
N = max(abs([SG_SH_corRC(:); SG(w); SH(w)]));   % normalisation factor
XX1 = SG_SH_corRC(:,2)/N;                       % particle motion X after
YY1 = SG_SH_corRC(:,1)/N;                       % particle motion Y after
XX2 = SH(w)/N;                                  % particle motion X before
YY2 = SG(w)/N;                                  % particle motion Y before

[XX1, YY1] = rot2D(XX1, YY1, -phi);             % rotate particle motions
[XX2, YY2] = rot2D(XX2, YY2, -phi);             % about phi so it plots correct

% plotting
line([-1.5 1.5], [0 0],'Color',[1 1 1]*.8, 'LineWidth',0.01)  
line([0 0], [-1.5 1.5],'Color',[1 1 1]*.8, 'LineWidth',0.01)
fill ([-X_ew fliplr(X_ew) ], [-Y_ew fliplr(Y_ew) ], [1 1 1]*.9 ,'LineStyle','none' ) % error wedge
plot( [-X X], [-Y Y], 'k:' ,...                 % black dotted strike line
      XX1   , YY1   , 'r-',...                  % particle motion after
      XX2   , YY2   , 'b--', 'LineWidth',1);    % particle motion before
                         
% adjust plot
xlabel(['\leftarrow ' yystr{1} ' \rightarrow'], 'Fontsize', fontsize-1);
ylabel(['\leftarrow ' yystr{2} ' \rightarrow'], 'Fontsize', fontsize-1);
title(['Particle motion before (..) & after (-)'], 'FontSize', titlefontsize);
axis equal
set(gca, 'xlim', [-1.1 1.1], 'ylim', [-1.1 1.1], 'XtickLabel',[], 'YtickLabel',[])
set(gca, 'Ytick', get(gca,'Xtick'))
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Correlation Map
axes(axRC(4));
hold on;

% determine plot variables
Cmatrix(end+1,:) = Cmatrix(1,:);
Cmatrix = Cmatrix .^3;

f  = size(Cmatrix);
ts = linspace(0,maxtime,f(2));
ps = linspace(-90, 90, f(1));

maxi = max(Cmatrix(:));         % allways <=  1 since correlation coeffcient (^5)
mini = min(Cmatrix(:));         % allways >= -1
maxmin = abs(mini - maxi);      % allways between 0 and 2

w1 = maxtime*.03; w2 =3.5;
Xmark = [0    w1 0    ;    maxtime maxtime-w1 maxtime ;   0       w1   0       ;    maxtime    maxtime-w1   maxtime]';
Ymark = [B-w2 B  B+w2 ;    B-w2    B          B+w2    ;   B-w2-90 B-90 B+w2-90 ;    B-w2-90    B-90         B+w2-90]';

% plotting
[~,h] = contourf(ts, ps, -Cmatrix, -[LevelRC LevelRC].^3);
fill(Xmark,Ymark,'k');
nb_contours = ceil(( maxmin)*7);
contour(ts, ps, Cmatrix, nb_contours);
% plot([0 0]+sampling, [B B-90],'k>','markersize',5,'linewidth',1,'MarkerFaceColor','k' )
% plot([maxtime maxtime]-sampling, [B B-90],'k<','markersize',5,'linewidth',1,'MarkerFaceColor','k' )
plot( allDelays(:,1), allFasts(:,1), 'b.')                              % result markers
plot( dtRC(1),strikes(1),'bo', dtSC(1),strikes(2),'g+',  dtEV(1),strikes(3),'rx' )
line([0 config.maxSplitTime], [strikes(1) strikes(1)],'Color',[0 0 1])
line([dtRC(1) dtRC(1)],[-90 90],'Color',[0 0 1])

% adjust plot
title('Map of Correlation Coefficient', 'FontSize', titlefontsize);
set(gca, 'xMinorTick', 'on','yminorTick', 'on')
axis([0 config.maxSplitTime -90 90])
xlabel('dt [s]', 'Fontsize',fontsize-1);
ylabel('Strike', 'Fontsize',fontsize-1)
set(h,'FaceColor', [1 1 1]*.90, 'EdgeColor', 'k', 'linestyle', '-', 'linewidth', 1)
hold off




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Silver & Chan
% fast/slow seismograms
s = size(QTcorSC,1);%selection length
t = (0:(s-1))*sampling;

axes(axSC(1))
sumFS1 = sum(abs( corFSsc(:,1) -corFSsc(:,2)));
sumFS2 = sum(abs(-corFSsc(:,1) -corFSsc(:,2)));
if ( sumFS1 < sumFS2 )
    sig = 1;
else
    sig = -1;
end

m1 = max(abs( corFSsc(:,1)));
m2 = max(abs( corFSsc(:,2)));
plot(t, sig*corFSsc(:,2)/m2 ,'r-', t, corFSsc(:,1)/m1, 'b--', 'LineWidth', 1);
xlim([t(1) t(end)])
ylim([-1 1])
title(['Fast (..) & shifted Slow (-)'], 'FontSize', titlefontsize);
set(gca, 'Ytick' , [-1 0 1])
ylabel(optionstr, 'FontSize', titlefontsize)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% corrected seismograms (in Ray-system)
axes(axSC(2))
plot( t, QTcorSC(:,2) , 'r-', t, QTcorSC(:,1), 'b--', 'LineWidth',1);
title(['corrected Q (..) & T (-)'], 'FontSize', titlefontsize);
xlim([t(1) t(end)])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Surface Particle motion
axes(axSC(3))
hold on

% errorwedge
pts = linspace(strike-dphi, strike+dphi, 10) /180*pi;
Y_ew = cos(pts);
X_ew = sin(pts);

% strike line
X = sind(strike);
Y = cosd(strike);

% particle motions
N = max(abs([SG_SH_corRC(:); SG(w); SH(w)]));   % normalisation factor
XX1 = SG_SH_corSC(:,2)/N;                       % particle motion X after
YY1 = SG_SH_corSC(:,1)/N;                       % particle motion Y after
XX2 = SH(w)/N;                                  % particle motion X before
YY2 = SG(w)/N;                                  % particle motion Y before

[XX1, YY1] = rot2D(XX1, YY1, -phi);             % rotate particle motions
[XX2, YY2] = rot2D(XX2, YY2, -phi);             % about phi so it plots correct

% plotting
line([-1.5 1.5], [0 0],'Color',[1 1 1]*.8, 'LineWidth',0.01)  
line([0 0], [-1.5 1.5],'Color',[1 1 1]*.8, 'LineWidth',0.01)
fill ([-X_ew fliplr(X_ew) ], [-Y_ew fliplr(Y_ew) ], [1 1 1]*.9 ,'LineStyle','none' ) % error wedge
plot( [-X X], [-Y Y], 'k:' ,...                 % black dotted strike line
      XX1   , YY1   , 'r-',...                  % particle motion after
      XX2   , YY2   , 'b--', 'LineWidth',1);    % particle motion before
                         
% adjust plot
xlabel(['\leftarrow ' yystr{1} ' \rightarrow'], 'Fontsize', fontsize-1);
ylabel(['\leftarrow ' yystr{2} ' \rightarrow'], 'Fontsize', fontsize-1);
title('Particle motion before (..) & after (-)', 'FontSize', titlefontsize);
axis equal
set(gca, 'xlim', [-1.1 1.1], 'ylim', [-1.1 1.1], 'XtickLabel',[], 'YtickLabel',[])
set(gca, 'Ytick', get(gca,'Xtick'))
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Energy or Eigenvalue Map
axes(axSC(4))
hold on

% determine plot variables
Ematrix(end+1,:) = Ematrix(1,:);
f  = size(Ematrix);
ts = linspace(0,maxtime,f(2));
ps = linspace(-90,90,f(1));

maxi = max(abs(Ematrix(:)));
mini = min(abs(Ematrix(:)));
nb_contours = floor((1 - mini/maxi)*7);

% plotting
[~,h] = contourf(ts,ps,-Ematrix,-[Level Level]);            % contour maximum
fill(Xmark,Ymark,'k')                                       % fill contour
contour(ts, ps, Ematrix, nb_contours);                      % contour rest
plot( allDelays(:,2), allFasts(:,2), 'r.')                  % result markers
plot( dtRC(1),strikes(1),'bo', dtSC(1),strikes(2),'g+',  dtEV(1),strikes(3),'rx' )
line([0 config.maxSplitTime], [strike strike],'Color',[0 0 1])  % lines for result symbol
line([dt dt],[-90 90],'Color',[0 0 1])

% adjust plot
hold off
axis([0 config.maxSplitTime -90 90])
set(gca, 'xMinorTick', 'on', 'yminorTick', 'on')
xlabel('dt [s]', 'FontSize', fontsize-1);
ylabel('Strike', 'FontSize', fontsize-1)
title(Maptitle,'FontSize', titlefontsize);
set(h,'FaceColor',[1 1 1]*.90,'EdgeColor','k','linestyle','-','linewidth',1)


%% plot Initial seismograms %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
axes(axSeis(1))
t2 = (0:length(QT)-1)*sampling - extime;
xx  = [0 0 s s]*sampling;
m = max(abs( QT(:) ));
yy  = [0 0 m m ];
tmp = fill(xx, yy, [1 1 1]*.90, 'EdgeColor','None');% Selection marker
hold on
plot(t2,QT(1,:),'b--', t2,QT(2,:),'r-', 'LineWidth',1)


% phase arrivals
tt = thiseq.phase.ttimes;
A  = thiseq.Spick(1)-extime;
F  = thiseq.Spick(2)+extime;
tt = tt(A<=tt& tt<=F); %phase arrival within selection
T  = [tt;tt];
T  = T-thiseq.Spick(1);
yy = repmat(ylim',size(tt));
plot(T,yy,'m:')

hold off
xlim([t2(1) t2(end)])
yy = [ylim fliplr(ylim)];
set(tmp,'yData',yy)
set(axSeis,'Layer','Top')

if length(Qvector)>1
    axSeis(2)  = axes('Units', 'normalized', 'Position', [.80 .8 .15 .16], 'Box', 'on', 'Fontsize', fontsize-1);

    hist(Qvector,-1:.1:1)
    h = findobj(gca,'Type','patch');
    set(h,'FaceColor','k','EdgeColor','w')
    title('Batch-mode Quality histogram')
    ylabel('Count')
    xlim([-1.05 1.05])
    set(axSeis(2),'Layer','Top','XMinorTick','on')
end

