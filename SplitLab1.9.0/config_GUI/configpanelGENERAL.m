% Splitlab Configureation GUI helper function

%% GENERAL
%========================================================================

h.panel(6) = uipanel('Units','pixel','Title','General',...
    'Position',pos + [0 230 0 -230], 'BackgroundColor', [224   223   227]/255 );
h.eqdata(19) = uicontrol('Parent',h.panel(6),'Units','pixel',...
    'Style','Edit',...
    'BackgroundColor','w',...
    'Position',[50 140 170 20],...
    'ToolTipString','Name of the Project',...
    'String', config.project,...
    'Callback', ['config.project = get(gcbo, ''String'');',...
    'if length(config.project)<4||~strcmp(config.project(end-3:end),''.pjt'');',...
    '  config.project = [config.project ''.pjt''];',...
    '  set(gcbo,''String'',config.project);end'] );
h.eqdata(20) = uicontrol(...
        'Parent',h.panel(6),'Units','pixel',...
        'Style','Pushbutton',...
        'Position',[230 140 90 20],... 
        'ToolTipString',sprintf('Create New Project from defaults set in ''SL_defaultconfig.m'''),...
        'String', 'New Project',...
        'Callback', 'pjtlist = getpref(''Splitlab'',''History'') , setpref(''Splitlab'',''History'', {''new_project.pjt'',pjtlist{1:end}}) , splitlab');

h.eqdata(21) = uicontrol('Parent',h.panel(6),'Units','pixel',...
    'Style','Edit',...
    'BackgroundColor','w',...
    'Position',[50 100 170 20],...
    'ToolTipString','Seismic data directory' ,...
    'String', config.datadir,...
    'Tag','SL_datadirUICONTROL',...
    'Callback', 'config.datadir=get(gcbo,''String''); set(findobj(''type'',''UIcontrol'', ''Tag'',''SL_datadirUICONTROL''), ''STRING'',config.datadir)');
h.eqdata(20) = uicontrol('Parent',h.panel(6),'Units','pixel',...
    'Style','Pushbutton',...
    'Position',[15 100 25 20],...
    'cdata', icon.folder,...
    'ToolTipString','Browse',...
    'Userdata',h.eqdata(21),...
    'Callback','tmp2=uigetdir(config.datadir);if isstr(tmp2), config.datadir=tmp2; set(findobj(''type'',''UIcontrol'', ''Tag'',''SL_datadirUICONTROL''), ''STRING'',config.datadir);end,clear tmp*');

uicontrol('Parent',h.panel(6),'Units','pixel',...
    'Style','text',...
    'Position',[230 95 110 20],...
    'String', 'Seismic data directory',...
    'HorizontalAlignment','left');



h.eqdata(23) = uicontrol('Parent',h.panel(6),'Units','pixel',...
    'Style','Edit',...
    'BackgroundColor','w',...
    'Position',[50 70 170 20],...
    'ToolTipString','Output directory',...
    'String', config.savedir,...
    'Callback', 'config.savedir=get(gcbo,''String'');');

h.eqdata(22) = uicontrol('Parent',h.panel(6),'Units','pixel',...
    'Style','Pushbutton',...
    'Position',[15 70 25 20],...
    'cdata', icon.folder,...
    'ToolTipString','Browse',...
    'Userdata',h.eqdata(23),...
    'Callback',['if exist(config.savedir)==7, tmp1=config.savedir;else, tmp1=config.datadir;end;',...
    'tmp=uigetdir(tmp1,''Please select output directory'');',...
    'if isstr(tmp),  if ~isdir(tmp), mkdir(tmp),end; config.savedir=tmp;',...
    'set(get(gcbo,''Userdata''), ''String'',config.savedir);end, clear tmp*' ]);

uicontrol('Parent',h.panel(6),'Units','pixel',...
    'Style','text',...
    'Position',[230 65 100 20],...
    'String', 'Output directory',...
    'HorizontalAlignment','left');

ic = icon.back;
ic(:,:,1)=rot90(ic(:,:,1));
ic(:,:,2)=rot90(ic(:,:,2));
ic(:,:,3)=rot90(ic(:,:,3));
h.eqdata(20) = uicontrol('Parent',h.panel(6),'Units','pixel',...
    'Style','Pushbutton',...
    'Position',[130 90 15 10],...
    'cdata', ic,...
    'ToolTipString','Copy directory path',...
    'Userdata',[h.eqdata(21) h.eqdata(23)],...
    'Callback','tmpUD=get(gcbo,''UserData''); config.savedir=get(tmpUD(1),''String''); set(tmpUD(2),''String'',config.savedir),clear tmp*');




formats = {'.ai','.eps','.fig','.jpg','.pdf','.ps','.png', '.tiff'};
val     =  strmatch(config.exportformat, formats);
h.eqdata(22) = uicontrol(...
    'Parent',h.panel(6),'Units','pixel',...
    'Style','PopupMenu',...
    'Position',[157 40 70 20],...
    'Value', val, ...
    'BackgroundColor','w',...
    'String', formats,...
    'ToolTipString','Figure export format',...
    'Callback', ['tmp1 = get(gcbo,''Value'');', ...
    'tmp2 = get(gcbo,''String'');',...
    'config.exportformat = char(tmp2(tmp1));',...
    'clear tmp1 tmp2;']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~ispc %for PCs files are opened with Matlabs "winopen" function
    uicontrol(...
        'Parent',h.panel(6),'Units','pixel',...
        'Style','Pushbutton',...
        'Position',[340 70 80 22],...
        'String', 'Open with',...
        'Userdata',formats,...
        'Callback', ...
        ['defaults = getpref(''Splitlab'',''Associations'');', ...
        'answer = inputdlg(defaults(:,1),  ''Enter program to open format'' ,1, defaults(:,2));',...
        'if isempty(answer); answer=defaults(:,2);end;',...
        'setpref(''Splitlab'',''Associations'',defaults);',...
        'if ~isequal(answer,defaults(:,2)); helpdlg(''Preferences succesfully saved!'',''Preferences''); end;',...
        '%clear answer defaults new;']);
end
uicontrol(...
    'Parent',h.panel(6),'Units','pixel',...
    'String',num2str(config.exportresolution),...
    'Style','Edit',...
    'BackgroundColor','w',...
    'ToolTipString','Resolution of saved files in DPI',...
    'Position',[340 39 40 22],...
    'Callback', 'config.exportresolution = str2num(get(gcbo,''String''));');
uicontrol(...
    'Parent',h.panel(6),'Units','pixel',...
    'String','DPI',...
    'Style','Text',...
    'HorizontalAlignment','left',...
    'Position',[385 39 30 18],...
    'Callback', 'config.exportresolution = str2num(get(gcbo,''String''));');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

uicontrol('Parent',h.panel(6),'Units','pixel',...
    'Style','text',...
    'Position',[230 35 100 20],...
    'String', 'Image output format',...
    'HorizontalAlignment','left');

str = {'A4','A3','A5','usletter','uslegal'};
val =strmatch( config.PaperType, str,'exact');
uicontrol(...
    'Parent',h.panel(6),'Units','pixel',...
    'Style','PopupMenu',...
    'Position',[60 40 90 20],...
    'String', str,...
    'Value',val,...
    'BackgroundColor','w',...
    'Callback', ['tmp1 = get(gcbo,''Value'');', ...
    'tmp2 = get(gcbo,''String'');',...
    'config.PaperType = char(tmp2(tmp1));',...
    'clear tmp1 tmp2;']);

axes( 'parent',h.panel(6), 'Units','pixel','position', [340 115 72 47])
image(icon.logo)
axis off


%%

strings = {['Station latitude [' char(186) ']'] , 'Station Northing [m]';
           ['Station longitude [' char(186) ']'], 'Station Easting [m]';
           ['Location Units: [' char(186) ']']  , 'Location Units: [m]'};
k=strcmp(config.studytype,'Reservoir')+1;
h.Units=uicontrol('Parent',h.panel(6),'Units','pixel',...
    'Style','text',...
    'Position',[230 10 150 15],...
    'String', strings{3,k},...
    'HorizontalAlignment','Left');



uicontrol('Parent',h.panel(6),'Units','pixel',...
    'Style','text',...
    'Position',[50 10 150 15],...
    'String', 'Study Type',...
    'HorizontalAlignment','Left');



typestring = {'Teleseismic','Regional','Reservoir'};
val         = strmatch(config.studytype, typestring);
if isempty(val)
    disp(['Current studytype "' config.studytype '" is not supported!'])
    config.studytype = typestring{1};
    disp(['Defaulting to "' config.studytype  '"'])
    val=1;
end
h.Type = uicontrol('Parent',h.panel(6),'Units','pixel',...
    'Style','PopupMenu',...
    'BackgroundColor','w',...
    'Position',[127 10 100 20],...
    'String',typestring ,...
    'Value', val,...
    'UserData',strings,...
    'CallBack',...
    ...
    ['tmp1=1+ (get(gcbo,''Value'') == 3);'...
    'tmp2=get(gcbo,''String'');',...
    'config.studytype=char(tmp2(get(gcbo,''Value'')));',...
    ' tmpUD=get(gcbo,''UserData'');',...
    ' set(tmpUD{1},{''string''},  tmpUD{2}(:,tmp1));'...
    ' if tmp1==2, set(tmpUD{3},''Visible'',''off'');     else;  set(tmpUD{3},''Visible'',''on''); end;  '...
    ' if tmp1==2, set(tmpUD{4},''Enable'',''off'');      else;  set(tmpUD{4},''Enable'',''on''); end;  '...
    'clear tmp*']);





%% Comment
h.panel(8) = uipanel('Units','pixel','Title','Comments',...
    'Position',[133 5 425 210], 'BackgroundColor', [224   223   227]/255 );

x = 60;
y = 190;
w = 60;
v = 20;


uicontrol('Parent',h.panel(8),'Units','pixel',...
    'Style','Edit',...
    'Position',[30 10 340 180],...
    'String', config.comment,...
    'BackgroundColor','w',...
    'Max',999,...
    'HorizontalAlignment','Left',...
    'Callback','config.comment=get(gcbo, ''String'');')


% EOF %