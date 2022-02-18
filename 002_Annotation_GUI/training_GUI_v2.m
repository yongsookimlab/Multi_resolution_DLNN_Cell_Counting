
clear
%username = inputdlg('User Name?');
username{1} = 'UREE';
[file,path] = uigetfile;
[~,name,~] = fileparts(file);
name = [date, '_', username{1}, '_', name, '.mat'  ];
load([path,file]);

cell_type = {'Neuron(GM) (1)';'Neuron(WM) (2)';'Trash (3)'};


ii = 801;
if ~exist("yes_no_ansers")
    yes_no_ansers = zeros(length(training_set),1);
end
s.figure = figure('MenuBar','none','Name','Gui01','NumberTitle','off','Position',[20,100,1500,500]);

plot_three_window(training_set(ii));


Txt = uicontrol('Style', 'Text','Position',[220,20,60,20]);
set(Txt, "String", strcat(num2str(ii), "/", num2str(length(training_set))));

s.b1 = uicontrol('Style','PushButton','String',cell_type{1},'Position',[1375,120,100,20],...
    'CallBack',' yes_no_ansers(ii) = 1; ii = ii+1;  plot_three_window(training_set(ii)); set(Txt, "String", strcat(num2str(ii), "/", num2str(length(training_set))));');
s.b2 = uicontrol('Style','PushButton','String',cell_type{2},'Position',[1375,100,100,20],...
    'CallBack',' yes_no_ansers(ii) = 2; ii = ii+1;  plot_three_window(training_set(ii)); set(Txt, "String", strcat(num2str(ii), "/", num2str(length(training_set))));');
s.b3 = uicontrol('Style','PushButton','String',cell_type{3},'Position',[1375,80,100,20],...
    'CallBack',' yes_no_ansers(ii) = 3; ii = ii+1;  plot_three_window(training_set(ii)); set(Txt, "String", strcat(num2str(ii), "/", num2str(length(training_set))));');
s.b4 = uicontrol('Style','PushButton','String','back','Position',[1375,50,100,20],...
    'CallBack',' ii = ii-1;  plot_three_window(training_set(ii)); set(Txt, "String", strcat(num2str(ii), "/", num2str(length(training_set)))); ');
s.b5 = uicontrol('Style','PushButton','String','save','Position',[1375,30,100,20],...
    'CallBack',' save(name ,"yes_no_ansers"); ');



set(s.figure,'KeyPressFcn',{@pb_kpf ,s});
set(s.b1,'KeyPressFcn',{@pb_kpf ,s});
set(s.b2,'KeyPressFcn',{@pb_kpf ,s});
set(s.b3,'KeyPressFcn',{@pb_kpf ,s});
set(s.b4,'KeyPressFcn',{@pb_kpf ,s});
set(s.b5,'KeyPressFcn',{@pb_kpf ,s});


function pb_kpf(varargin)
switch varargin{1,2}.Character
    case '1'
        evalin('base','yes_no_ansers(ii)=1;');
        evalin('base','ii = ii+1;');
    case '2'
        evalin('base','yes_no_ansers(ii)=2;');
        evalin('base','ii = ii+1;');
    case '3'
        evalin('base','yes_no_ansers(ii)=3;');
        evalin('base','ii = ii+1;');
end
evalin('base','plot_three_window(training_set(ii));');
evalin('base','set(Txt, "String", strcat(num2str(ii), "/", num2str(length(training_set))));');
end


