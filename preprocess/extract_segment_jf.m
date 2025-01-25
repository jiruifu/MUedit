function fileName_new = extract_segment_jf(fileName_refine, si, ei, segment_id)
if nargin == 0
    [fileName_refine, path] = uigetfile('*FastICA*.mat');
    data = load(fileName_refine);
else
    fileName_toload = fileName_refine;
    data = load(fileName_toload);
end
fileName_refine = fileName_refine;
disp(["The input filename is", fileName_refine])

ref_signal = data.ref_signal;
if nargin < 4
    SIG_t = data.SIG{2};
    % plot and get data segments
    figure();
    subplot(2,1,1)
    plot(ref_signal,'k','LineWidth',1)
    grid on
    subplot(2,1,2)
    plot(SIG_t(1,:),'r','LineWidth',1)
    title("The plot of reference and HDEMG signal")
    grid on
    pause(3)
    close
    [A,B] = ginput(2);
    si = A(1);
    ei = A(2);
%     si = 1;
    si = ceil(si);
    ei = floor(ei);
    segment_id = 1;
end

if si < 1
   si = 1;
end
if ei > length(ref_signal)
   ei = length(ref_signal);
end
    
% trim SIG, IPTs, 
for k = 2:length(data.SIG(:))
    data.SIG{k} = data.SIG{k}(si:ei);
end

for mi = 1:length(data.MUPulses)
    MUPulses_t = data.MUPulses{mi};
    MUPulses_t(MUPulses_t<si) = [];
    MUPulses_t(MUPulses_t>ei) = [];
    data.MUPulses{mi} = MUPulses_t-si+1;
end

% update the data length
data.IPTs = data.IPTs(:, si:ei);
force_seg = ref_signal(si:ei);
data.ref_signal = ref_signal(si:ei);
data.SIGlength = length(data.ref_signal)/data.fsamp;
data.stopSIGInt = data.SIGlength;
data.spikes_seg = data.spikes(:, si:ei);
data.full_spikes = data.spikes;
data = rmfield(data, 'spikes');

IPTs = data.IPTs;
MUPulses = data.MUPulses;
figure();
plot(IPTs(1, :));
hold on;
plot(MUPulses{1}, IPTs(1, MUPulses{1}), 'ro')
title(["The plot of IPT and Index of Spike for MU 1 and segment", segment_id]);
pause(3)
close
if exist('DecompsRuns', 'var')
    DecompRuns = DecompsRuns;
end

% Normalize the ref_signal
ref_signal_smoothed = force_seg';
ref_signal_norm = (ref_signal_smoothed - min(ref_signal_smoothed)) / (max(ref_signal_smoothed) - min(ref_signal_smoothed));
data.normForce = ref_signal_norm;

% construct name
[filepath, name, ext] = fileparts(fileName_refine); 
disp(["Path is:", filepath])
disp(["Name is:", name])
disp(["extension is:", ext])
if isempty(filepath)
    filepath = pwd;
end
% fileName_new = [filepath, '[s', name, '_seg' ext];
% fileName_new = ['s', fileName_refine];
fileName_new = [filepath, ['\s', name '-seg' ext]];
disp(["The filename after first adjustument is ", fileName_new])
% fileName_all = [fileName_new{:}]

save(fileName_new, '-struct', 'data');
disp(["The output filename after running this function is", fileName_new])
% save(['s', fileName_refine], 'SIG','IED','DecompRuns','DecompStat','description','discardChannelsVec', ...
%     'origRecMode','ProcTime','SIGFileName','SIGFilePath','SIGlength', ...
%     'startSIGInt','stopSIGInt','PNR','Cost','IPTs','MUIDs','MUPulses','fsamp','ref_signal');
% close all;
end