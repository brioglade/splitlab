% Splitlab Configureation GUI helper function
%% Find SAC files
h.panel(7) = uipanel('Units','pixel','Title','Find files for earthquakes',...
    'Position',[133 100 425 305], 'BackgroundColor', [224   223   227]/255, 'Visible','off');



uicontrol('Parent',h.panel(7),'Units','pixel',...
    'Style','text',...
    'Position',[60 265 200 20],...
    'String', 'Seismic data directory',...
    'HorizontalAlignment','left');
eqdata21 = uicontrol('Parent',h.panel(7),'Units','pixel',...
    'Style','Edit',...
    'BackgroundColor','w',...
    'Position',[60 250 270 20],...
    'ToolTipString','Seismic data directory' ,...
    'String', config.datadir,...
    'Tag','SL_datadirUICONTROL',...
    'Callback', 'config.datadir=get(gcbo,''String''); set(findobj(''type'',''UIcontrol'', ''Tag'',''SL_datadirUICONTROL''), ''STRING'',config.datadir)');
eqdata20 = uicontrol('Parent',h.panel(7),'Units','pixel',...
    'Style','Pushbutton',...
    'Position',[335 250 25 20],...
    'cdata', icon.folder,...
    'ToolTipString','Browse',...
    'Userdata',eqdata21,...
    'Callback','tmp2=uigetdir(config.datadir);if isstr(tmp2), config.datadir=tmp2; set(findobj(''type'',''UIcontrol'', ''Tag'',''SL_datadirUICONTROL''), ''STRING'',config.datadir);end,clear tmp*');




% field descriptions text
uicontrol('Parent',h.panel(7),'Units','pixel',...
    'Style','text',...
    'Position',[60 220 200 20],...
    'String', 'File search string:',...
    'HorizontalAlignment','Left');
uicontrol('Parent',h.panel(7),'Units','pixel',...
    'Style','text',...
    'HorizontalAlignment','Left',...
    'Position',[60 190 200 20],...
    'String', 'Offset [sec]:');

uicontrol('Parent',h.panel(7),'Units','pixel',...
    'Style','text',...
    'Position',[60 160 200 20],...
    'String', ['Tolerance [' char(177) ' sec]:'],...
    'HorizontalAlignment','Left');
uicontrol('Parent',h.panel(7),'Units','pixel',...
    'Style','text',...
    'Position',[60 130 100 20],...
    'String', 'File name format:',...
    'HorizontalAlignment','Left');
% uicontrol('Parent',h.panel(7),'Units','pixel',...
%     'Style','text',...
%     'Position',[60 105 100 20],...
%     'String', 'Travel Times:',...
%     'HorizontalAlignment','Left');
%% edit fields
h.find(1) = uicontrol('Parent',h.panel(7),'Units','pixel',...
    'Style','Edit',...
    'BackgroundColor','w',...
    'Position',[160 225 100 20],...
    'String', config.searchstr,...
    'FontName','FixedWidth',...
    'Callback','config.searchstr=get(gcbo,''String'');');
h.find(3) = uicontrol('Parent',h.panel(7),'Units','pixel',...
    'Style','edit',...
    'BackgroundColor','w',...
    'Position',[160 195 100 20],...
    'String',num2str(config.offset),...
    'ToolTipString','Offset in seconds relative to hypotime',...
    'Callback','config.offset = str2num(get(gcbo,''String''));');


                         
h.find(2) = uicontrol('Parent',h.panel(7),'Units','pixel',...
    'Style','Edit',...
    'BackgroundColor','w',...
    'Position',[160 165 100 20],...
    'String', num2str(config.searchdt),...
    'FontName','FixedWidth',...
    'tooltip', 'search tolerance relative to hypotime',...
    'Callback','config.searchdt=str2num(get(gcbo,''String''));');

%% File format:
str = {'RDSEED' 'miniSEED' 'RHUM-RUM' 'SEISAN', 'YYYY.JJJ.hh.mm.ss.stn.sac.e' 'YYYY.MM.DD-hh.mm.ss.stn.sac.e' 'YYYY.MM.DD.hh.mm.ss.stn.E.sac' '*.e; *.n; *.z' 'stn.YYMMDD.hhmmss.e' 'YYYY_MM_DD_hhmm_stnn.sac.e'};
val = strmatch(config.FileNameConvention, str);
h.find(3) = uicontrol('Parent',h.panel(7),'Units','pixel',...
    'Style','popupmenu',...
    'BackgroundColor','w',...
    'Position',[160 135 200 20],...
    'Value',  val,...
    'String', str,...
    'tooltip', 'search tolerance relative to hypotime',...
    'Callback',...
    ['tmpstr = get(gcbo,''String'');tmpval = get(gcbo,''Value'');'...
    'config.FileNameConvention=char(tmpstr(tmpval));',...
    'if tmpval==5;'...% use last letter
    '  config.UseHeaderTimes=1;'...
    '  set(findobj(''Tag'',''UseFileNameTimes'') ,''Value'',0);'...
    '  set(findobj(''Tag'',''UseHeaderTimes'') ,''Value'',1);'...
    'end;'...
    'clear tmp*']...
    );




%% check buttons:
uicontrol('Parent',h.panel(7),'Units'  ,'pixel',...
    'Style'    ,'checkbox',...
    'Value'    ,config.showstats,...
    'Position' ,[270 230 140 20],...
    'String'   , 'Show statistic plot',...
    'Tag',      'ShowStatsCheck',...
    'Callback' ,'config.showstats=get(gcbo,''Value'');set(findobj(''Tag'',''ShowStatsCheck'') ,''Value'',config.showstats)');


%% Radio buttons
uicontrol('Parent',h.panel(7),'Units'  ,'pixel',...
    'Style'    ,'radiobutton',...
    'Value'    ,~config.UseHeaderTimes,...
    'Position' ,[60 65 240 20],...
    'String'   ,'Extract file times from filename',...
    'Tag','UseFileNameTimes',...
    'Callback' ,'config.UseHeaderTimes=~get(gcbo,''Value''); set(findobj(''Tag'',''UseHeaderTimes'') ,''Value'',0)');

uicontrol('Parent',h.panel(7),'Units'  ,'pixel',...
    'Style'    ,'radiobutton',...
    'Value'    ,config.UseHeaderTimes,...
    'Position' ,[60 45 240 20],...   
    'Tag','UseHeaderTimes',...
    'String'   ,'Extract file times from SAC-header (slow)',...
    'Callback' ,'config.UseHeaderTimes=get(gcbo,''Value''); set(findobj(''Tag'',''UseFileNameTimes'') ,''Value'',0)');




%% buttons
uicontrol('Parent',h.panel(7),'Units','pixel',...
    'Style','Pushbutton',...
    'Position',[10 10 195 25],...
    'String', 'Automatically associate SAC-files',...
    'Tooltip','Associate 3-components SAC files to catalogue',...
    'Callback',['[tmpeq, success]=SL_assignFilesAuto(eq);',...
                'if success ,'...
                '    tmp = questdlg([''Associated '' num2str(length(tmpeq)) '' earthquakes! ''], ''Info'', ''Accept'', ''Dismiss'', ''Accept'');',...
                '    if strcmp(tmp, ''Dismiss''); clear tmp*; return; else; eq = tmpeq; end;',...
                '    if config.showstats,         SL_showeqstats,                       end;',...
                '    tmp = findobj(''String'', ''Manually associate SAC-files''); set(tmp,''Enable'',''off'');',...
                'end;  clear tmp*']);

uicontrol('Parent',h.panel(7),'Units','pixel',...
    'Style','Pushbutton',...
    'Position',[220 10 195 25],...
    'String', 'Manually associate SAC-files',...
    'Tooltip','Associate 3-components SAC files to catalogue',...
    'Callback',[ 'F=list(fullfile(config.datadir, config.searchstr));',...
                'manual_eq =  SL_assignFilesManual( eq, F);',...
                'if ~isempty(manual_eq), eq=manual_eq; clear manual_eq;',...
                'if ~config.showstats, ',...
                '    helpdlg([''Associated '' num2str(length(manual_eq)) '' earthquakes! ''], ''Info'');',...
                'else,',...
                '  if ~isempty(eq) , SL_showeqstats,end;',...
                'end; end;',...
                'tmp = findobj(''String'', ''Automatically associate SAC-files'');',...
                'set(tmp,''Enable'',''off''); clear tmp']);


uicontrol('Parent',h.panel(7),'Units','pixel',...
    'Style','Pushbutton',...
    'Position',[60 95 295 25],...
    'String', 'Import all settings from SAC header',...
    'Tooltip',' ',...
    'Callback',['[success, tmpconf, tmpeq]=SL_dir2pjt(config);',...
                'if success ,'...
                '  config=tmpconf;',...
                '  eq=tmpeq;',...
                '  if config.showstats,         SL_showeqstats,                       end;',...
                '  splitlab;',...
                'end;  clear tmp*']);


%% Export
h.panel(9) = uipanel('Units','pixel','Title','Export (optional)',...
    'Position',[133 5 425 85], 'BackgroundColor', [224   223   227]/255, 'Visible','off');
uicontrol('Parent',h.panel(9),'Units','pixel',...
    'Style','Pushbutton',...
    'Position',[110 5 200 20],...
    'String', 'Cut and save as SAC',...
    'Tooltip','Cut 3-components SAC files at common time intervals and save new files',...
    'Callback','cutandsaveasSAC');
uicontrol('Parent',h.panel(9),'Units'  ,'pixel',...
    'Style'    ,'text',...
    'Position' ,[10 35 400 30],...
    'String'   , ['Cut the three SAC files to their common time window. '...
    'These new SAC files can then be used in external programms. Not neccesary for SplitLab']);
