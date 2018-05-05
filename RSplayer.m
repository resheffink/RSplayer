function varargout = RSplayer(varargin)
% RSPLAYER MATLAB code for RSplayer.fig
%      RSPLAYER, by itself, creates a new RSPLAYER or raises the existing
%      singleton*.
%
%      H = RSPLAYER returns the handle to a new RSPLAYER or the handle to
%      the existing singleton*.
%
%      RSPLAYER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RSPLAYER.M with the given input arguments.
%hjh
%      RSPLAYER('Property','Value',...) creates a new RSPLAYER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RSplayer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RSplayer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RSplayer

% Last Modified by GUIDE v2.5 06-Mar-2018 12:59:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RSplayer_OpeningFcn, ...
                   'gui_OutputFcn',  @RSplayer_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before RSplayer is made visible.
function RSplayer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RSplayer (see VARARGIN)

% Choose default command line output for RSplayer
handles.output = hObject;

% Update handles structure
guidata(handles.output, handles);

% UIWAIT makes RSplayer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = RSplayer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
guidata(handles.output,handles);


% --- Executes on slider movement.
function Amp_Callback(hObject, eventdata, handles)
%Description:
% This function gets the Amplitude from the GUI slider and insert it to the
% globaly Variable: handles.data.CurVol.
% this variable will be used when we would like to increase or decrease the
% amplitude (or the intensity(= volume)) of the audio file.
handles.data.AmpFactor=get(hObject,'Value');
set(handles.Vol,'String',num2str(handles.data.AmpFactor));


guidata(handles.output,handles);






% --- Executes during object creation, after setting all properties.
function Amp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Amp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes on button press in Play.
function Play_Callback(hObject, eventdata, handles)
% Description:
% This function play the original audio file (located in the left side of
% the gui screen.
% it uses the global variable: handles.data.player that contain the
% original audio file.
% note: before playing the audio file the function test if the file is not
% in the middle of playing. if not then the function play the file using
% play function. if it's in the middle of the file then the function resume
% the palying of the file and does not start it from the start.
if handles.data.CurentSample>1  % Check if the file is in the middle of playing or it hasent been played
   resume(handles.data.player); % if it was in the middle the resume the playing
else
    play(handles.data.player);  % if it was in the start then start playing the file
end
guidata(handles.output,handles); % save the handles data for later use.



% --- Executes on button press in Stop.
function Stop_Callback(hObject, eventdata, handles)
% Description:
% This function stop playing the original audio file (located in the left side of
% the gui screen.
% it uses the global variable: handles.data.player that contain the
% original audio file.
stop(handles.data.player); % stop playing the audio file.
guidata(handles.output,handles); % save the handles data for later use.

% --- Executes on button press in Pause.
function Pause_Callback(hObject, eventdata, handles)
% Description:
% This function pause the playing of the original audio file (located in the left side of
% the gui screen.
% it uses the global variable: handles.data.player that contain the
% original audio file.
pause(handles.data.player); % pause the playing of the audio file
handles.data.CurentSample=get(handles.data.player, 'CurrentSample'); % save the current sample to be used when we want to resume playing.
guidata(handles.output,handles); % save the handles data for later use.


% --- Executes on button press in Load.
function Load_Callback(hObject, eventdata, handles)
% Description:
% this function let the user select the audio file he wants to use from the
% computer and initialise all the variables (AudioFile, Fs, Amplitides...)
% this function also saves the file extention (.mp3,.wav...) for the saving
% function.
% it also plot the original audio file on the graph located in the left
% side of the gui.
[FileName,PathName] = uigetfile('*.*','Please select the Audio file'); % Launches a dialog box for file selection and get the path of the file and his name.


[AudioFile,Fs]=audioread([PathName,'\',FileName]); % saves the audio file and the sampling frequency (Fs)
[path,name,ext] = fileparts(FileName); %saves the file extension - will be useful when saving the file (other 2 variables are not used beacuse we already seted them).
handles.data.ext=ext;
[Amplitudes, ChannelNum]=size(AudioFile); % Amplitudes is the audio file length, ChannelNum is the number of columns (number of channels).
if ChannelNum<=2 && ChannelNum>0 %Determine if it's a stereo or a mono sound track. Matlab only support 2 channels.
    ChannelType=ChannelNum;
else 
    errordlg('This software supports only Mono or Stereo audio files (up to 2 channels).','File is not supported');
end

handles.data.Duration=Amplitudes/Fs; % what is the length of the audio file (in seconds).
handles.data.TimeAxes = linspace(0, Amplitudes/Fs, Amplitudes); %preparing the time axis.


% initializing the data from the audio file:
handles.data.AudioFile=AudioFile; % insert the AudioFile to variable
handles.data.AudioFileRes=AudioFile; % insert the result (after editted) AudioFile to variable - in case the user wants to save the file witout editing it.
handles.data.Amplitudes=Amplitudes;
handles.data.AmplitudesRes=Amplitudes;
handles.data.DurationRes=handles.data.Duration;
handles.data.ChannelType=ChannelType;
handles.data.PathName=PathName;
handles.data.FileName=FileName;
handles.data.player=audioplayer(AudioFile,Fs); % insert the audio File for the Play, Pause and Stop functions.
handles.data.Fs=Fs;
handles.data.FsRes=Fs;
handles.data.GaussianNoise=0; % initialy set to 0 beacuse user didn't choose a noise yet.

handles.data.NFFT= 2^nextpow2(handles.data.Amplitudes); % improves the fft performance The  smallest power of two that is greater than or equal to the absolute value the audio file length;
handles.data.FreqDomain=fft(AudioFile,handles.data.NFFT); % perform the fft conv on the audio file in the length of the NFFT;
handles.data.FFTshifted=fftshift(handles.data.FreqDomain); % set the zeros after the fft to the middle.
handles.data.EqFactor=1; %default value - in case the user will not type the Frequency Factor.
handles.data.FreqAxis=linspace(0,handles.data.Fs/2,handles.data.NFFT/2+1);
handles.data.ValueSet=false;
% setting the audio file information text on the GUI left side player:
Channels=num2str(get(handles.data.player, 'NumberOfChannels'));
duration=num2str(handles.data.Duration);
handles.data.CurentSample=get(handles.data.player, 'CurrentSample');
set(handles.Fs,'string',Fs);
set(handles.channel,'string',Channels);
set(handles.duration,'string',duration);

%ploting the audio file left side graph:
axes(handles.OriginalSig);
plot(handles.data.TimeAxes,AudioFile);
xlabel('Time [sec]');
ylabel('Amp');


axes(handles.OriginalSpec);
plot(handles.data.FreqAxis,abs(handles.data.FreqDomain(1:handles.data.NFFT/2+1)));% frequencies display.
xlabel('Frequency (Hz)');
ylabel('Amp');



guidata(handles.output,handles); % saving the data for later use.

% --- Executes on button press in PlayRes.
function PlayRes_Callback(hObject, eventdata, handles)
% Description:
% This function play the editted audio file (located in the right side of
% the gui screen.
% it uses the global variable: handles.data.playerRes that contain the
% audio file after been eddited.
% note: before playing the audio file the function test if the file is not
% in the middle of playing. if not then the function play the file using
% play function. if it's in the middle of the file then the function resume
% the palying of the file and does not start it from the start.

if handles.data.CurrentSampleRes>1 % Check if the edited file is in the middle of playing or it hasent been played
   resume(handles.data.playerRes); % if it was in the middle the resume the playing
else
    play(handles.data.playerRes); % if it was in the start then start playing the edited audio file
end
guidata(handles.output,handles); % saving the data for later use.

% --- Executes on button press in StopRes.
function StopRes_Callback(hObject, eventdata, handles)
% Description:
% This function stop playing the edited audio file (located in the right side of
% the gui screen).
% it uses the global variable: handles.data.playerRes that contain the
% edited audio file.
stop(handles.data.playerRes); % stop playing the audio file.
guidata(handles.output,handles); % save the handles data for later use.

% --- Executes on button press in PauseRes.
function PauseRes_Callback(hObject, eventdata, handles)
% Description:
% This function pause the playing of the edited audio file (located in the right side of
% the gui screen).
% it uses the global variable: handles.data.playerRes that contain the
% edited audio file.
pause(handles.data.playerRes); % pause the playing of the edited audio file
handles.data.CurrentSampleRes=get(handles.data.playerRes, 'CurrentSample'); % save the current sample to be used when we want to resume playing.
guidata(handles.output,handles); % save the handles data for later use.

% --- Executes on button press in SaveRes.
function SaveRes_Callback(hObject, eventdata, handles)
% Description:
% This functions save the edited audio file and all it's information to the
% location specified by the user.
% it first check if the file extention is compatible to Matlab saving
% format. if it is => the edited audio file is saved (named by the user) in
% the location the user selected with the original file extention.
% if the extention in not compatible => pop an error message and save the
% edited file in Wav foramt.
[FileName,Path] = uiputfile('*.*','Please select the Destination for the saved file'); % getting the File name and the path from the user.
if (strcmp('.flac',handles.data.ext)||strcmp('.m4a',handles.data.ext)||strcmp('.mp4',handles.data.ext)||strcmp('.oga',handles.data.ext)||strcmp('.ogg',handles.data.ext)||strcmp('.wav',handles.data.ext)) % compare the file extention to the permitted extentions of Matlab
        path=[Path,FileName,handles.data.ext]; % setting the path with the file name and the extentions to be saved.
else
    path=[Path, FileName,'.wav']; % file extentions in not compatible => setting the extention to: .wav
    errordlg('The file format is not compatible with Matlab file saving formats. saving in mav format');
end
audiowrite(path,handles.data.AudioFileRes,handles.data.FsRes); % saving the edited file.

 guidata(hObject,handles) % save the handles data for later use.

function Vol_Callback(hObject, eventdata, handles)
% Description:
% insert the volume to the volume global variable.
handles.data.Vol=handles.data.AmpFactor;
guidata(handles.output,handles);
 

% --- Executes on button press in Apply.
function Apply_Callback(hObject, eventdata, handles)
% Description:
% when the user change the amplitude the user press the apply button and
% make the Apllypanel visible for selection: Apply to original signal or
% Apply to edited signal
if get(handles.Apply,'value') == 1 % when button is pressed the value change to one
   set(handles.ApplyPanel,'visible','on'); % make the Applypanel visible for selection
end 

guidata(handles.output,handles);
 


% --- Executes on button press in AudioTrimmer.
function AudioTrimmer_Callback(hObject, eventdata, handles)
% Description:
% in this function the user can trim a part of the audio file for other
% functions manipulations.
figure;
plot(handles.data.TimeAxes,handles.data.AudioFile);
title('Please select the start point');
[StartPoint,~]=ginput(1);
title('Please select the end point');
[EndPoint,~]=ginput(1);
close;
Audiotrim=handles.data.AudioFile((fix(handles.data.Fs*StartPoint):fix(handles.data.Fs*EndPoint)),(1:handles.data.ChannelType)); % Creating the audio segment from the relevant part.

% setting the New trim audio file data:
handles.data.FsRes=handles.data.Fs;
handles.data.AudioFileRes=Audiotrim; % settign the result audio file as the trim part.
handles.data.AmplitudesRes=length(handles.data.AudioFileRes);
handles.data.DurationRes=handles.data.AmplitudesRes/handles.data.FsRes;
handles.data.playerRes=audioplayer(handles.data.AudioFileRes,handles.data.FsRes);


%The results player modifications:
SampleRateRes=num2str(get(handles.data.playerRes, 'SampleRate'));
set(handles.SampRateRes,'string',SampleRateRes);
handles.data.ChannelRes=num2str(get(handles.data.playerRes, 'NumberOfChannels'));
set(handles.ChannelRes,'string',handles.data.ChannelRes);
handles.data.DurationRes=num2str(handles.data.DurationRes);
set(handles.DurationRes,'string',handles.data.DurationRes);
handles.data.CurrentSampleRes=get(handles.data.playerRes, 'CurrentSample');

handles.data.TimeAxesRes = linspace(0, fix(handles.data.AmplitudesRes/handles.data.FsRes), handles.data.AmplitudesRes);
axes(handles.result);
plot(handles.data.TimeAxesRes, handles.data.AudioFileRes); % edited Audio file plot vs time [in sec];
xlabel('Time [sec]');
ylabel('Amp');


handles.data.FreqAxisRes=linspace(0,handles.data.FsRes/2,handles.data.NFFT/2+1);
axes(handles.ResultSpec);
plot(handles.data.FreqAxisRes,abs(handles.data.FreqDomain(1:handles.data.NFFT/2+1)));% frequencies display.
xlabel('Frequency (Hz)');
ylabel('Amp');

guidata(handles.output,handles);

% --- Executes on button press in Move.
function Move_Callback(hObject, eventdata, handles)
% Description:
% in this function the user can trim a part of the audio file and move in
% to another part in the audio file. the result audio file will be saved in
% the AudioFileRes variable.

figure;
plot(handles.data.TimeAxes,handles.data.AudioFile);
title('Please select the start point');
[StartPoint,~]=ginput(1);
title('Please select the end point');
[EndPoint,~]=ginput(1);
close;
Audiotrim=handles.data.AudioFile((fix(handles.data.Fs*StartPoint):fix(handles.data.Fs*EndPoint)),(1:handles.data.ChannelType));% Creating the audio segment from the relevant part.

% inserting the new trim Segment:
figure;
plot(handles.data.TimeAxes, handles.data.AudioFile); % Audio file plot
title('Please select the location you want to Move the new segment');
[NewStartPoint,~] = ginput(1); % user picks the new location starting point.
close; 

if (NewStartPoint<StartPoint)
    OriginalAudio=handles.data.AudioFile;
    TillNewStart=OriginalAudio(1:(fix(handles.data.Fs*NewStartPoint)),(1:handles.data.ChannelType));
    NewStartToEnd=[OriginalAudio(fix(handles.data.Fs*NewStartPoint):fix(handles.data.Fs*StartPoint),(1:handles.data.ChannelType)); OriginalAudio(fix(handles.data.Fs*EndPoint):end,(1:handles.data.ChannelType))];
    NewAudioFile=[TillNewStart;Audiotrim;NewStartToEnd];
elseif (NewStartPoint>EndPoint)
	OriginalAudio=handles.data.AudioFile;
    TillStart=OriginalAudio(1:(fix(handles.data.Fs*StartPoint)),(1:handles.data.ChannelType));
    EndPointToNewStart=OriginalAudio(fix(handles.data.Fs*EndPoint):fix(handles.data.Fs*NewStartPoint),(1:handles.data.ChannelType));
    NewAudioFile=[TillStart;EndPointToNewStart;Audiotrim;OriginalAudio(fix(handles.data.Fs*NewStartPoint):end,(1:handles.data.ChannelType))];
end
if ((NewStartPoint<EndPoint)&&(NewStartPoint>StartPoint))
	NewAudioFile=handles.data.AudioFile;
end
handles.data.FsRes=handles.data.Fs;
handles.data.AudioFileRes=NewAudioFile;%modifying the current audio file.
handles.data.AmplitudesRes=length(handles.data.AudioFileRes);
handles.data.DurationRes=handles.data.AmplitudesRes/handles.data.FsRes;


handles.data.playerRes=audioplayer(handles.data.AudioFileRes,handles.data.FsRes);%gathering the info from the current audioFile

%The results player modifications:
SampleRateRes=num2str(get(handles.data.playerRes, 'SampleRate'));
ChannelRes=num2str(get(handles.data.playerRes, 'NumberOfChannels'));
DurationRes=num2str(handles.data.DurationRes);
handles.data.CurrentSampleRes=get(handles.data.playerRes, 'CurrentSample');
set(handles.SampRateRes,'string',SampleRateRes);
set(handles.ChannelRes,'string',ChannelRes);
set(handles.DurationRes,'string',DurationRes);

handles.data.TimeAxesRes = linspace(0, fix(handles.data.AmplitudesRes/handles.data.FsRes), handles.data.AmplitudesRes);
axes(handles.result);
plot(handles.data.TimeAxesRes, handles.data.AudioFileRes); % result Audio file plot
xlabel('Time [sec]');
ylabel('Amp');


handles.data.FreqAxisRes=linspace(0,handles.data.FsRes/2,handles.data.NFFT/2+1);
axes(handles.ResultSpec);
plot(handles.data.FreqAxisRes,abs(handles.data.FreqDomain(1:handles.data.NFFT/2+1)));% frequencies display.
xlabel('Frequency (Hz)');
ylabel('Amp');

guidata(handles.output,handles);


% --- Executes on button press in AudioCopy.
function AudioCopy_Callback(hObject, eventdata, handles)
% Description:
% in this function the user select a segment in the audio file and copy it
% to the end of the audio file.
figure;
plot(handles.data.TimeAxes,handles.data.AudioFile);
title('Please select the start point');
[StartPoint,~]=ginput(1);
title('Please select the end point');
[EndPoint,~]=ginput(1);
close;
Audiotrim=handles.data.AudioFile((fix(handles.data.Fs*StartPoint):fix(handles.data.Fs*EndPoint)),(1:handles.data.ChannelType));
NewAudioFile=[handles.data.AudioFile;Audiotrim];
handles.data.FsRes=handles.data.Fs;
handles.data.AudioFileRes=NewAudioFile; % inserting the edited file.
handles.data.AmplitudesRes=length(handles.data.AudioFileRes);
handles.data.DurationRes=handles.data.AmplitudesRes/handles.data.FsRes;


handles.data.playerRes=audioplayer(handles.data.AudioFileRes,handles.data.FsRes);% gathering the info from the current audioFile

%The results player modifications:
ChannelRes=num2str(get(handles.data.playerRes, 'NumberOfChannels'));
DurationRes=num2str(handles.data.DurationRes);
handles.data.CurrentSampleRes=get(handles.data.playerRes, 'CurrentSample');
set(handles.ChannelRes,'string',ChannelRes);
set(handles.DurationRes,'string',DurationRes);
set(handles.SampRateRes,'string',handles.data.FsRes);

handles.data.TimeAxesRes = linspace(0, fix(handles.data.AmplitudesRes/handles.data.FsRes), handles.data.AmplitudesRes);
axes(handles.result);
plot(handles.data.TimeAxesRes, handles.data.AudioFileRes); % result Audio file plot
xlabel('Time [sec]');
ylabel('Amp');

handles.data.FreqAxisRes=linspace(0,handles.data.FsRes/2,handles.data.NFFT/2+1);
axes(handles.ResultSpec);
plot(handles.data.FreqAxisRes,abs(handles.data.FreqDomain(1:handles.data.NFFT/2+1)));% frequencies display.
xlabel('Frequency (Hz)');
ylabel('Amp');

guidata(handles.output,handles);


% --- Executes on button press in Copy.
function Copy_Callback(CopyButton, eventdata, handles)
% Description:
% in this function the user select a segment from the audio file and copy
% it to a diffrent location in the audio file while the copied segment is
% not been deleted.

figure;
plot(handles.data.TimeAxes,handles.data.AudioFile);
title('Please select the start point');
[StartPoint,~]=ginput(1);
title('Please select the end point');
[EndPoint,~]=ginput(1);
close;
Audiotrim=handles.data.AudioFile(fix(handles.data.Fs*StartPoint):fix(handles.data.Fs*EndPoint),(1:handles.data.ChannelType));% Creating the audio segment from the relevant part.
Audiotrimlen=length(Audiotrim);
figure; plot(handles.data.TimeAxes, handles.data.AudioFile); % Audio file plot
title('Please select the location you want to Copy the segment you chose');
[NewStartPoint,~] = ginput(1); % user picks the starting point.
close; 
NewAudioFile=handles.data.AudioFile;
NewAudioFile(fix(handles.data.Fs*NewStartPoint):fix(handles.data.Fs*NewStartPoint)+Audiotrimlen-1,(1:handles.data.ChannelType))=Audiotrim;
handles.data.FsRes=handles.data.Fs;
handles.data.AudioFileRes=NewAudioFile; %inserting the edited audio file.
handles.data.AmplitudesRes=length(handles.data.AudioFileRes);
handles.data.DurationRes=handles.data.AmplitudesRes/handles.data.FsRes;


NewAudioInfo=audioplayer(handles.data.AudioFileRes,handles.data.FsRes);% gathering the info from the current audioFile
handles.data.playerRes=NewAudioInfo;
guidata(handles.output,handles);

%The results player modifications:
handles.data.CurrentSampleRes=get(handles.data.playerRes,'CurrentSample');
handles.data.FsRes=handles.data.Fs;
ChannelRes=num2str(get(handles.data.playerRes, 'NumberOfChannels'));
DurationRes=num2str(handles.data.DurationRes);
set(handles.SampRateRes,'string',handles.data.FsRes);
set(handles.ChannelRes,'string',ChannelRes);
set(handles.DurationRes,'string',DurationRes);

handles.data.TimeAxesRes = linspace(0, handles.data.AmplitudesRes/handles.data.FsRes, handles.data.AmplitudesRes);
axes(handles.result);
plot(handles.data.TimeAxesRes, handles.data.AudioFileRes); % result Audio file plot
xlabel('Time [sec]');
ylabel('Amp');

handles.data.FreqAxisRes=linspace(0,handles.data.FsRes/2,handles.data.NFFT/2+1);
axes(handles.ResultSpec);
plot(handles.data.FreqAxisRes,abs(handles.data.FreqDomain(1:handles.data.NFFT/2+1)));% frequencies display.
xlabel('Frequency (Hz)');
ylabel('Amp');

guidata(handles.output,handles);


% --- Executes on button press in ChangeFs.
function ChangeFs_Callback(hObject, eventdata, handles)
% Description:
% in this function the user can change the sample rate (Fs) using the Freq
% EqulizerFactor that has been entered in the gui.
handles.data.FsRes=handles.data.NewFs;
handles.data.playerRes=audioplayer(handles.data.AudioFileRes,handles.data.FsRes);
handles.data.TimeAxesRes = linspace(0, handles.data.AmplitudesRes/handles.data.FsRes, handles.data.AmplitudesRes);
handles.data.CurrentSampleRes=get(handles.data.playerRes, 'CurrentSample');
handles.data.DurationRes=handles.data.AmplitudesRes/handles.data.FsRes;
DurationRes=num2str(handles.data.DurationRes);
ChannelRes=num2str(get(handles.data.playerRes, 'NumberOfChannels'));
set(handles.SampRateRes,'string',handles.data.FsRes);
set(handles.DurationRes,'string',DurationRes);
set(handles.ChannelRes,'string',ChannelRes);

axes(handles.result);
plot(handles.data.TimeAxesRes,handles.data.AudioFileRes);
xlabel('Time [sec]');
ylabel('Amp');

handles.data.FreqAxisRes=linspace(0,handles.data.FsRes/2,handles.data.NFFT/2+1);
axes(handles.ResultSpec);
plot(handles.data.FreqAxisRes,abs(handles.data.FreqDomain(1:handles.data.NFFT/2+1)));% frequencies display.
xlabel('Frequency (Hz)');
ylabel('Amp');

guidata(hObject,handles);

% --- Executes on button press in defultFs.
function defultFs_Callback(hObject, eventdata, handles)
% Description:
% in this function the user can return the sample rate (Fs) to it's
% original value.
handles.data.FsRes=handles.data.Fs;
handles.data.playerRes=audioplayer(handles.data.AudioFileRes,handles.data.FsRes);
handles.data.TimeAxesRes = linspace(0, handles.data.AmplitudesRes/handles.data.FsRes, handles.data.AmplitudesRes);
handles.data.CurrentSampleRes=get(handles.data.playerRes, 'CurrentSample');
handles.data.DurationRes=handles.data.AmplitudesRes/handles.data.FsRes;
DurationRes=num2str(handles.data.DurationRes);
ChannelRes=num2str(get(handles.data.playerRes, 'NumberOfChannels'));
set(handles.SampRateRes,'string',handles.data.FsRes);
set(handles.DurationRes,'string',DurationRes);
set(handles.ChannelRes,'string',ChannelRes);


axes(handles.result);
plot(handles.data.TimeAxesRes,handles.data.AudioFileRes);
xlabel('Time [sec]');
ylabel('Amp');

handles.data.FreqAxisRes=linspace(0,handles.data.FsRes/2,handles.data.NFFT/2+1);
axes(handles.ResultSpec);
plot(handles.data.FreqAxisRes,abs(handles.data.FreqDomain(1:handles.data.NFFT/2+1)));% frequencies display.
xlabel('Frequency (Hz)');
ylabel('Amp');

guidata(hObject,handles);

function FsChangeFactor_Callback(hObject, eventdata, handles)
% Description:
% in this function the changed sample rate (Fs) that the user entered is
% saved.
handles.data.NewFs=str2double(get(hObject,'string'));
guidata(handles.output,handles);

function GaussianNoiseFactor_Callback(hObject, eventdata, handles)
% Description:
% in this function the Gaussian noise equlizerfactor that the user entered is
% saved.
handles.data.ValueSet=true;
handles.data.GaussianNoise=str2double(get(hObject,'string'));
guidata(hObject,handles);

% --- Executes on button press in AddGaussian.
function AddGaussian_Callback(hObject, eventdata, handles)
% Description:
% in this function the user add the gaussian noise to the audio signal
% using the equlizerfactor that has been entered.
if(handles.data.ValueSet~=true)
    errordlg('Gaussian Factor has not yet been set. Please Enter a value and then try again');
else
    handles.data.AudioFileRes=handles.data.AudioFileRes+handles.data.GaussianNoise*randn(size(handles.data.AudioFileRes));
    handles.data.FsRes=handles.data.Fs;
    handles.data.playerRes=audioplayer(handles.data.AudioFileRes,handles.data.FsRes);
    handles.data.AmplitudesRes=length(handles.data.AudioFileRes);
    handles.data.TimeAxesRes = linspace(0, handles.data.AmplitudesRes/handles.data.FsRes, handles.data.AmplitudesRes);
    handles.data.CurrentSampleRes=get(handles.data.playerRes, 'CurrentSample');
    handles.data.DurationRes=handles.data.AmplitudesRes/handles.data.FsRes;
    DurationRes=num2str(handles.data.DurationRes);
    ChannelRes=num2str(get(handles.data.playerRes, 'NumberOfChannels'));
    set(handles.SampRateRes,'string',handles.data.FsRes);
    set(handles.DurationRes,'string',DurationRes);
    set(handles.ChannelRes,'string',ChannelRes);
    axes(handles.result);
    plot(handles.data.TimeAxesRes,handles.data.AudioFileRes);
    xlabel('Time [sec]');
    ylabel('Amp');
    
    handles.data.FreqAxisRes=linspace(0,handles.data.FsRes/2,handles.data.NFFT/2+1);
    axes(handles.ResultSpec);
    plot(handles.data.FreqAxisRes,abs(handles.data.FreqDomain(1:handles.data.NFFT/2+1)));% frequencies display.
    xlabel('Frequency (Hz)');
    ylabel('Amp');
end

guidata(hObject,handles);

% --- Executes on button press in RemoveGaussian.
function RemoveGaussian_Callback(hObject, eventdata, handles)
% Description:
% in this function the user can remove the gaussian noise from the audio
% file.
[b,a]=butter(6,0.03,'low');
handles.data.AudioFileRes=filter(b,a,handles.data.AudioFileRes);
handles.data.AmplitudesRes=length(handles.data.AudioFileRes);
handles.data.playerRes=audioplayer(handles.data.AudioFileRes,handles.data.FsRes);
handles.data.TimeAxesRes = linspace(0, handles.data.AmplitudesRes/handles.data.FsRes, handles.data.AmplitudesRes);
handles.data.CurrentSampleRes=get(handles.data.playerRes, 'CurrentSample');
handles.data.DurationRes=handles.data.AmplitudesRes/handles.data.FsRes;
DurationRes=num2str(handles.data.DurationRes);
ChannelRes=num2str(get(handles.data.playerRes, 'NumberOfChannels'));
set(handles.SampRateRes,'string',handles.data.FsRes);
set(handles.DurationRes,'string',DurationRes);
set(handles.ChannelRes,'string',ChannelRes);
axes(handles.result);
plot(handles.data.TimeAxesRes,handles.data.AudioFileRes);
xlabel('Time [sec]');
ylabel('Amp');

handles.data.FreqAxisRes=linspace(0,handles.data.FsRes/2,handles.data.NFFT/2+1);
axes(handles.ResultSpec);
plot(handles.data.FreqAxisRes,abs(handles.data.FreqDomain(1:handles.data.NFFT/2+1)));% frequencies display.
xlabel('Frequency (Hz)');
ylabel('Amp');

guidata(hObject,handles);

% --- Executes on button press in OriginalApply.
function OriginalApply_Callback(hObject, eventdata, handles)
% Description:
% in this function the user can apply the amplitude change to the Original
% file.
handles.data.AudioFileRes=handles.data.AmpFactor*handles.data.AudioFile;
handles.data.AmplitudesRes=length(handles.data.AudioFileRes);
handles.data.FsRes=handles.data.Fs;
handles.data.playerRes=audioplayer(handles.data.AudioFileRes,handles.data.FsRes);
handles.data.TimeAxesRes = linspace(0, handles.data.AmplitudesRes/handles.data.FsRes, handles.data.AmplitudesRes);
handles.data.CurrentSampleRes=get(handles.data.playerRes, 'CurrentSample');
handles.data.DurationRes=handles.data.AmplitudesRes/handles.data.FsRes;
DurationRes=num2str(handles.data.DurationRes);
ChannelRes=num2str(get(handles.data.playerRes, 'NumberOfChannels'));
set(handles.SampRateRes,'string',handles.data.FsRes);
set(handles.DurationRes,'string',DurationRes);
set(handles.ChannelRes,'string',ChannelRes);
axes(handles.result);
plot(handles.data.TimeAxesRes,handles.data.AudioFileRes);
xlabel('Time [sec]');
ylabel('Amp');
set(handles.ApplyPanel,'visible','off');


handles.data.FreqAxisRes=linspace(0,handles.data.FsRes/2,handles.data.NFFT/2+1);
axes(handles.ResultSpec);
plot(handles.data.FreqAxisRes,abs(handles.data.FreqDomain(1:handles.data.NFFT/2+1)));% frequencies display.
xlabel('Frequency (Hz)');
ylabel('Amp');

guidata(hObject,handles);



% --- Executes on button press in EditedApply.
function EditedApply_Callback(hObject, eventdata, handles)
% Description:
% in this function the user can apply the amplitude change to the edited
% audio file.
handles.data.AudioFileRes=handles.data.AmpFactor*handles.data.AudioFileRes;
handles.data.AmplitudesRes=length(handles.data.AudioFileRes);
handles.data.playerRes=audioplayer(handles.data.AudioFileRes,handles.data.FsRes);
handles.data.TimeAxesRes = linspace(0, handles.data.AmplitudesRes/handles.data.FsRes, handles.data.AmplitudesRes);
handles.data.CurrentSampleRes=get(handles.data.playerRes, 'CurrentSample');
handles.data.DurationRes=handles.data.AmplitudesRes/handles.data.FsRes;
DurationRes=num2str(handles.data.DurationRes);
ChannelRes=num2str(get(handles.data.playerRes, 'NumberOfChannels'));
set(handles.SampRateRes,'string',handles.data.FsRes);
set(handles.DurationRes,'string',DurationRes);
set(handles.ChannelRes,'string',ChannelRes);
axes(handles.result);
plot(handles.data.TimeAxesRes,handles.data.AudioFileRes);
xlabel('Time [sec]');
ylabel('Amp');
set(handles.ApplyPanel,'visible','off');


handles.data.FreqAxisRes=linspace(0,handles.data.FsRes/2,handles.data.NFFT/2+1);
axes(handles.ResultSpec);
plot(handles.data.FreqAxisRes,abs(handles.data.FreqDomain(1:handles.data.NFFT/2+1)));% frequencies display.
xlabel('Frequency (Hz)');
ylabel('Amp');

guidata(hObject,handles);


% --- Executes on button press in MediumFreqBoost.
function MediumFreqBoost_Callback(hObject, eventdata, handles)
% Description:
% in this function the user can boost the medium frequency of the audio
% file.
% meduim frequency is in the range: 213 - 2048 Hz
FilteredSig=handles.data.FFTshifted;

FilteredSig(( fix(handles.data.NFFT/2)+1-2048*fix(handles.data.NFFT/handles.data.Fs)):( fix(handles.data.NFFT/2)+1+513*fix(handles.data.NFFT/handles.data.Fs)),1:handles.data.ChannelType) = (handles.data.EqFactor)*handles.data.FFTshifted(( fix(handles.data.NFFT/2)+1-2048* fix(handles.data.NFFT/handles.data.Fs)):( fix(handles.data.NFFT/2)+1+513*fix(handles.data.NFFT/handles.data.Fs)),1:handles.data.ChannelType);
FilteredSig(( fix(handles.data.NFFT/2)+1-513*fix(handles.data.NFFT/handles.data.Fs)):( fix(handles.data.NFFT/2)+1+2048*fix(handles.data.NFFT/handles.data.Fs)),1:handles.data.ChannelType) = (handles.data.EqFactor)*handles.data.FFTshifted(( fix(handles.data.NFFT/2)+1-513* fix(handles.data.NFFT/handles.data.Fs)):( fix(handles.data.NFFT/2)+1+2048*fix(handles.data.NFFT/handles.data.Fs)),1:handles.data.ChannelType);
FilteredSig=fftshift(FilteredSig);


handles.data.AudioFileRes=ifft(FilteredSig); 
handles.data.AudioFileRes=handles.data.AudioFileRes((1:handles.data.Amplitudes),(1:handles.data.ChannelType)); 

handles.data.FsRes=handles.data.Fs;
handles.data.AmplitudesRes=length(handles.data.AudioFileRes);
handles.data.DurationRes=handles.data.AmplitudesRes/handles.data.FsRes;
handles.data.TimeAxesRes = linspace(0, handles.data.AmplitudesRes/handles.data.FsRes, handles.data.AmplitudesRes);
axes(handles.result);
plot(handles.data.TimeAxesRes, handles.data.AudioFileRes); % result Audio file plot
xlabel('Time [sec]');
ylabel('Amp');
handles.data.playerRes=audioplayer(handles.data.AudioFileRes,handles.data.FsRes);% gathering the info from the current audioFile

%The results player modifications:
SampleRateRes=num2str(get(handles.data.playerRes, 'SampleRate'));
set(handles.SampRateRes,'string',SampleRateRes);
handles.data.CurrentSampleRes=get(handles.data.playerRes, 'CurrentSample');
ChannelRes=num2str(get(handles.data.playerRes, 'NumberOfChannels'));
set(handles.ChannelRes,'string',ChannelRes);
DurationRes=num2str(handles.data.DurationRes);
set(handles.DurationRes,'string',DurationRes);
handles.data.CurrentSampleRes=get(handles.data.playerRes, 'CurrentSample');


handles.data.FreqAxisRes=linspace(0,handles.data.FsRes/2,handles.data.NFFT/2+1);
axes(handles.ResultSpec);
plot(handles.data.FreqAxisRes,abs(FilteredSig(1:handles.data.NFFT/2+1)));% frequencies display.
xlabel('Frequency (Hz)');
ylabel('Amp');

guidata(hObject,handles);



% --- Executes on button press in MediumFreqReduce.
function MediumFreqReduce_Callback(hObject, eventdata, handles)
% Description:
% in this function the user can reduce the medium frequency of the audio
% file.
% meduim frequency is in the range: 213 - 2048 Hz
FilteredSig=handles.data.FFTshifted;

FilteredSig(( fix(handles.data.NFFT/2)+1-2048*fix(handles.data.NFFT/handles.data.Fs)):( fix(handles.data.NFFT/2)+1+513*fix(handles.data.NFFT/handles.data.Fs)),1:handles.data.ChannelType) = (1/handles.data.EqFactor)*handles.data.FFTshifted(( fix(handles.data.NFFT/2)+1-2048* fix(handles.data.NFFT/handles.data.Fs)):( fix(handles.data.NFFT/2)+1+513*fix(handles.data.NFFT/handles.data.Fs)),1:handles.data.ChannelType);
FilteredSig(( fix(handles.data.NFFT/2)+1-513*fix(handles.data.NFFT/handles.data.Fs)):( fix(handles.data.NFFT/2)+1+2048*fix(handles.data.NFFT/handles.data.Fs)),1:handles.data.ChannelType) = (1/handles.data.EqFactor)*handles.data.FFTshifted(( fix(handles.data.NFFT/2)+1-513* fix(handles.data.NFFT/handles.data.Fs)):( fix(handles.data.NFFT/2)+1+2048*fix(handles.data.NFFT/handles.data.Fs)),1:handles.data.ChannelType);
FilteredSig=fftshift(FilteredSig);


handles.data.AudioFileRes=ifft(FilteredSig); 
handles.data.AudioFileRes=handles.data.AudioFileRes((1:handles.data.Amplitudes),(1:handles.data.ChannelType)); 

handles.data.FsRes=handles.data.Fs;
handles.data.AmplitudesRes=length(handles.data.AudioFileRes);
handles.data.DurationRes=handles.data.AmplitudesRes/handles.data.FsRes;
handles.data.TimeAxesRes = linspace(0, handles.data.AmplitudesRes/handles.data.FsRes, handles.data.AmplitudesRes);
axes(handles.result);
plot(handles.data.TimeAxesRes, handles.data.AudioFileRes); % result Audio file plot
xlabel('Time [sec]');
ylabel('Amp');
handles.data.playerRes=audioplayer(handles.data.AudioFileRes,handles.data.FsRes);% gathering the info from the current audioFile

%The results player modifications:
SampleRateRes=num2str(get(handles.data.playerRes, 'SampleRate'));
handles.data.CurrentSampleRes=get(handles.data.playerRes, 'CurrentSample');
ChannelRes=num2str(get(handles.data.playerRes, 'NumberOfChannels'));
DurationRes=num2str(handles.data.DurationRes);
handles.CurrentSampleRes=get(handles.data.playerRes, 'CurrentSample');
set(handles.SampRateRes,'string',SampleRateRes);
set(handles.ChannelRes,'string',ChannelRes);
set(handles.DurationRes,'string',DurationRes);

handles.data.FreqAxisRes=linspace(0,handles.data.FsRes/2,handles.data.NFFT/2+1);
axes(handles.ResultSpec);
plot(handles.data.FreqAxisRes,abs(FilteredSig(1:handles.data.NFFT/2+1)));% frequencies display.
xlabel('Frequency (Hz)');
ylabel('Amp');

guidata(hObject,handles);


% --- Executes on button press in LowFreqBoost.
function LowFreqBoost_Callback(hObject, eventdata, handles)
% Description:
% in this function the user can boost the Low frequency of the audio
% file.
% Low frequency is in the range: 0 - 512 Hz
FilteredSig=handles.data.FFTshifted;

FilteredSig(( fix(handles.data.NFFT/2)+1-512*fix(handles.data.NFFT/handles.data.Fs)):( fix(handles.data.NFFT/2)+1+512*fix(handles.data.NFFT/handles.data.Fs)),1:handles.data.ChannelType) = (handles.data.EqFactor)*handles.data.FFTshifted(( fix(handles.data.NFFT/2)+1-512* fix(handles.data.NFFT/handles.data.Fs)):( fix(handles.data.NFFT/2)+1+512*fix(handles.data.NFFT/handles.data.Fs)),1:handles.data.ChannelType);

FilteredSig=fftshift(FilteredSig);


handles.data.AudioFileRes=ifft(FilteredSig); 
handles.data.AudioFileRes=handles.data.AudioFileRes((1:handles.data.Amplitudes),(1:handles.data.ChannelType)); 

handles.data.FsRes=handles.data.Fs;
handles.data.AmplitudesRes=length(handles.data.AudioFileRes);
handles.data.DurationRes=handles.data.AmplitudesRes/handles.data.FsRes;
handles.data.TimeAxesRes = linspace(0, handles.data.AmplitudesRes/handles.data.FsRes, handles.data.AmplitudesRes);
axes(handles.result); plot(handles.data.TimeAxesRes, handles.data.AudioFileRes); % result Audio file plot
xlabel('Time [sec]');
ylabel('Amp');
handles.data.playerRes=audioplayer(handles.data.AudioFileRes,handles.data.FsRes);% gathering the info from the current audioFile

%The results player modifications:
SampleRateRes=num2str(get(handles.data.playerRes, 'SampleRate'));
handles.data.CurrentSampleRes=get(handles.data.playerRes, 'CurrentSample');
ChannelRes=num2str(get(handles.data.playerRes, 'NumberOfChannels'));
DurationRes=num2str(handles.data.DurationRes);
handles.CurrentSampleRes=get(handles.data.playerRes, 'CurrentSample');
set(handles.SampRateRes,'string',SampleRateRes);
set(handles.ChannelRes,'string',ChannelRes);
set(handles.DurationRes,'string',DurationRes);

handles.data.FreqAxisRes=linspace(0,handles.data.FsRes/2,handles.data.NFFT/2+1);
axes(handles.ResultSpec);
plot(handles.data.FreqAxisRes,abs(FilteredSig(1:handles.data.NFFT/2+1)));% frequencies display.
xlabel('Frequency (Hz)');
ylabel('Amp');

guidata(hObject,handles);

% --- Executes on button press in LowFreqReduce.
function LowFreqReduce_Callback(hObject, eventdata, handles)
% Description:
% in this function the user can reduce the Low frequency of the audio
% file.
% Low frequency is in the range: 0 - 512 Hz
FilteredSig=handles.data.FFTshifted;

FilteredSig(( fix(handles.data.NFFT/2)+1-512*fix(handles.data.NFFT/handles.data.Fs)):( fix(handles.data.NFFT/2)+1+512*fix(handles.data.NFFT/handles.data.Fs)),1:handles.data.ChannelType) = (1/handles.data.EqFactor)*handles.data.FFTshifted(( fix(handles.data.NFFT/2)+1-512* fix(handles.data.NFFT/handles.data.Fs)):( fix(handles.data.NFFT/2)+1+512*fix(handles.data.NFFT/handles.data.Fs)),1:handles.data.ChannelType);

FilteredSig=fftshift(FilteredSig);


handles.data.AudioFileRes=ifft(FilteredSig); 
handles.data.AudioFileRes=handles.data.AudioFileRes((1:handles.data.Amplitudes),(1:handles.data.ChannelType)); 

handles.data.FsRes=handles.data.Fs;
handles.data.AmplitudesRes=length(handles.data.AudioFileRes);
handles.data.DurationRes=handles.data.AmplitudesRes/handles.data.FsRes;
handles.data.TimeAxesRes = linspace(0, handles.data.AmplitudesRes/handles.data.FsRes, handles.data.AmplitudesRes);
axes(handles.result);
plot(handles.data.TimeAxesRes, handles.data.AudioFileRes); % result Audio file plot
xlabel('Time [sec]');
ylabel('Amp');
handles.data.playerRes=audioplayer(handles.data.AudioFileRes,handles.data.FsRes);% gathering the info from the current audioFile.

%The results player modifications:
SampleRateRes=num2str(get(handles.data.playerRes, 'SampleRate'));
handles.data.CurrentSampleRes=get(handles.data.playerRes, 'CurrentSample');
ChannelRes=num2str(get(handles.data.playerRes, 'NumberOfChannels'));
DurationRes=num2str(handles.data.DurationRes);
handles.CurrentSampleRes=get(handles.data.playerRes, 'CurrentSample');
set(handles.SampRateRes,'string',SampleRateRes);
set(handles.ChannelRes,'string',ChannelRes);
set(handles.DurationRes,'string',DurationRes);

handles.data.FreqAxisRes=linspace(0,handles.data.FsRes/2,handles.data.NFFT/2+1);
axes(handles.ResultSpec);
plot(handles.data.FreqAxisRes,abs(FilteredSig(1:handles.data.NFFT/2+1)));% frequencies display.
xlabel('Frequency (Hz)');
ylabel('Amp');

guidata(hObject,handles);


% --- Executes on button press in HighFreqBoost.
function HighFreqBoost_Callback(hObject, eventdata, handles)
% Description:
% in this function the user can boost the High frequency of the audio
% file.
% High frequency is in the range: above 2048 Hz
FilteredSig=handles.data.FFTshifted;
FilteredSig(1:(fix(handles.data.NFFT/2)+1-2048*fix(handles.data.NFFT/handles.data.Fs)),1:handles.data.ChannelType) = (handles.data.EqFactor)*handles.data.FFTshifted(1:(fix(handles.data.NFFT/2)+1-2048* fix(handles.data.NFFT/handles.data.Fs)),1:handles.data.ChannelType);
FilteredSig(fix(handles.data.NFFT/2)+1+2048*fix(handles.data.NFFT/handles.data.Fs):handles.data.NFFT,1:handles.data.ChannelType)= (handles.data.EqFactor)*handles.data.FFTshifted(fix(handles.data.NFFT/2)+1+2048*fix(handles.data.NFFT/handles.data.Fs):handles.data.NFFT,1:handles.data.ChannelType);
FilteredSig=fftshift(FilteredSig);


handles.data.AudioFileRes=ifft(FilteredSig); 
handles.data.AudioFileRes=handles.data.AudioFileRes((1:handles.data.Amplitudes),(1:handles.data.ChannelType)); 

handles.data.FsRes=handles.data.Fs;
handles.data.AmplitudesRes=length(handles.data.AudioFileRes);
handles.data.DurationRes=handles.data.AmplitudesRes/handles.data.FsRes;

handles.data.playerRes=audioplayer(handles.data.AudioFileRes,handles.data.FsRes);% gathering the info from the current audioFile.

%The results player modifications:
SampleRateRes=num2str(get(handles.data.playerRes, 'SampleRate'));
handles.data.CurrentSampleRes=get(handles.data.playerRes, 'CurrentSample');
ChannelRes=num2str(get(handles.data.playerRes, 'NumberOfChannels'));
DurationRes=num2str(handles.data.DurationRes);
handles.CurrentSampleRes=get(handles.data.playerRes, 'CurrentSample');
set(handles.SampRateRes,'string',SampleRateRes);
set(handles.ChannelRes,'string',ChannelRes);
set(handles.DurationRes,'string',DurationRes);

handles.data.TimeAxesRes = linspace(0, handles.data.AmplitudesRes/handles.data.FsRes, handles.data.AmplitudesRes);
axes(handles.result);
plot(handles.data.TimeAxesRes, handles.data.AudioFileRes); % result Audio file plot
xlabel('Time [sec]');
ylabel('Amp');

handles.data.FreqAxisRes=linspace(0,handles.data.FsRes/2,handles.data.NFFT/2+1);
axes(handles.ResultSpec);
plot(handles.data.FreqAxisRes,abs(FilteredSig(1:handles.data.NFFT/2+1)));% frequencies display.
xlabel('Frequency (Hz)');
ylabel('Amp');

guidata(hObject,handles);



% --- Executes on button press in HighFreqReduce.
function HighFreqReduce_Callback(hObject, eventdata, handles)
% Description:
% in this function the user can reduce the High frequency of the audio
% file.
% High frequency is in the range: above 2048 Hz
FilteredSig=handles.data.FFTshifted;

FilteredSig(1:( fix(handles.data.NFFT/2)+1-2048*fix(handles.data.NFFT/handles.data.Fs)),1:handles.data.ChannelType) = (1/handles.data.EqFactor)*handles.data.FFTshifted(1:( fix(handles.data.NFFT/2)+1-2048* fix(handles.data.NFFT/handles.data.Fs)),1:handles.data.ChannelType);
FilteredSig(fix(handles.data.NFFT/2)+1+2048*fix(handles.data.NFFT/handles.data.Fs):handles.data.NFFT,1:handles.data.ChannelType)= (1/handles.data.EqFactor)*handles.data.FFTshifted(fix(handles.data.NFFT/2)+1+2048*fix(handles.data.NFFT/handles.data.Fs):handles.data.NFFT,1:handles.data.ChannelType);

FilteredSig=fftshift(FilteredSig);


handles.data.AudioFileRes=ifft(FilteredSig); 
handles.data.AudioFileRes=handles.data.AudioFileRes((1:handles.data.Amplitudes),(1:handles.data.ChannelType)); 

handles.data.FsRes=handles.data.Fs;
handles.data.AmplitudesRes=length(handles.data.AudioFileRes);
handles.data.DurationRes=handles.data.AmplitudesRes/handles.data.FsRes;
handles.data.TimeAxesRes = linspace(0, handles.data.AmplitudesRes/handles.data.FsRes, handles.data.AmplitudesRes);
axes(handles.result); plot(handles.data.TimeAxesRes, handles.data.AudioFileRes); % result Audio file plot
xlabel('Time [sec]');
ylabel('Amp');
handles.data.playerRes=audioplayer(handles.data.AudioFileRes,handles.data.FsRes);% gathering the info from the current audioFile

%The results player modifications:
SampleRateRes=num2str(get(handles.data.playerRes, 'SampleRate'));
handles.data.CurrentSampleRes=get(handles.data.playerRes, 'CurrentSample');
ChannelRes=num2str(get(handles.data.playerRes, 'NumberOfChannels'));
DurationRes=num2str(handles.data.DurationRes);
handles.CurrentSampleRes=get(handles.data.playerRes, 'CurrentSample');
set(handles.SampRateRes,'string',SampleRateRes);
set(handles.ChannelRes,'string',ChannelRes);
set(handles.DurationRes,'string',DurationRes);

handles.data.FreqAxisRes=linspace(0,handles.data.FsRes/2,handles.data.NFFT/2+1);
axes(handles.ResultSpec);
plot(handles.data.FreqAxisRes,abs(FilteredSig(1:handles.data.NFFT/2+1)));% frequencies display.
xlabel('Frequency (Hz)');
ylabel('Amp');

guidata(hObject,handles);

function EqulizerFactor_Callback(hObject, eventdata, handles)
% Description:
% in this function the BoostqReduce EqulizerFactor that has been entered by the
% user is been saved
handles.data.EqFactor=str2double(get(hObject,'string'));
guidata(hObject,handles);



% --- Executes on button press in RevPlay.
function RevPlay_Callback(hObject, eventdata, handles)
% Description:
% in this function the user can revers the Audio file.
handles.data.AudioFileRes=flipud(handles.data.AudioFile); % revers the audio file => flip the AudioFile array such that all the upper elements are switched with the bottom elements.
handles.data.FsRes=handles.data.Fs;
handles.data.AmplitudesRes=length(handles.data.AudioFileRes);
handles.data.DurationRes=handles.data.AmplitudesRes/handles.data.FsRes;
handles.data.TimeAxesRes = linspace(0, handles.data.AmplitudesRes/handles.data.FsRes, handles.data.AmplitudesRes);
axes(handles.result);
plot(handles.data.TimeAxesRes, handles.data.AudioFileRes); % revered audio file plot
xlabel('Time [sec]');
ylabel('Amp');
handles.data.playerRes=audioplayer(handles.data.AudioFileRes,handles.data.FsRes);
handles.data.CurrentSampleRes=get(handles.data.playerRes, 'CurrentSample');
SampleRateRes=num2str(get(handles.data.playerRes, 'SampleRate'));
handles.data.CurrentSampleRes=get(handles.data.playerRes, 'CurrentSample');
ChannelRes=num2str(get(handles.data.playerRes, 'NumberOfChannels'));
DurationRes=num2str(handles.data.DurationRes);
set(handles.SampRateRes,'string',SampleRateRes);
set(handles.ChannelRes,'string',ChannelRes);
set(handles.DurationRes,'string',DurationRes);

handles.data.FreqAxisRes=linspace(0,handles.data.FsRes/2,handles.data.NFFT/2+1);
axes(handles.ResultSpec);
plot(handles.data.FreqAxisRes,abs(handles.data.FreqDomain(1:handles.data.NFFT/2+1)));% frequencies display.
xlabel('Frequency (Hz)');
ylabel('Amp');

guidata(hObject,handles);


% -----------------Function Creation:--------------------------------------

% --- Executes during object creation, after setting all properties.
function Vol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Vol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% --- Executes during object creation, after setting all properties.
function Play_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Stop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Pause_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Load_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function PlayRes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PlayRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function StopRes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StopRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function PauseRes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PauseRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Apply_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Apply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% --- Executes during object creation, after setting all properties.
function SaveRes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SaveRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% --- Executes during object creation, after setting all properties.
function FsChangeFactor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FsChangeFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function GaussianNoiseFactor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GaussianNoiseFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function EqulizerFactor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EqulizerFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
