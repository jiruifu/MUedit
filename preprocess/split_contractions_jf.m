function segList = split_contractions_jf(fileName)
%% split data into contractions
if 0
    trialList = get_file_folder_list('./G*/G*', 1);
    trialCnt = length(trialList);
    for ti = 1:trialCnt
        fileList = split_contractions(trialList{ti});
    end
end
% segment into each contraction
if nargin == 0
    [fileName, filePath] = uigetfile('.mat');
    fileName_full = [filePath, fileName];
else
    [filePath, fileName, fileExt] = fileparts(fileName);
    if ~isempty(filePath)
        fileName_full = [filePath, '\', fileName, fileExt];
    else
        filePath = pwd;
        fileName_full = [filePath, '\', fileName, fileExt];
    end
end
disp(fileName_full)
%% S1. load data
fileName_raw = fileName_full;
% fileName_full = [fileName_full{:}];
data = load(fileName_full, 'ref_signal');
ref_signal_sm = smooth(data.ref_signal, 1000);
signal_len = length(ref_signal_sm);

%% S2. get segments based on force/torque signal
segments = get_segments_from_refsignal_jf(data.ref_signal);
segments_n = segments;
segList = cell(1, 1);

%% S3. refine segments for long break between contractions
gap_duration = mean(segments_n(2:3, 1) - segments_n(1:2, 2))./2048;
% get middle point if gap is less than 40 seconds
if gap_duration < 40
    mid_1 = round((segments(1, 2) + segments(2, 1))/2);
    mid_2 = round((segments(2, 2) + segments(3, 1))/2);
    segments_n(1, 1) = segments(1,1) - 10*2048;
    segments_n(1, 2) = mid_1;
    segments_n(2, 1) = mid_1;
    segments_n(2, 2) = mid_2;
    segments_n(3, 1) = mid_2;
    segments_n(3, 2) = segments(3,2) + 10*2048;
else
    % expand the segment by 10 seconds
    for i = 1:size(segments_n, 1)
        segments_n(i, 1)= segments_n(i,1) - 10*2048;
        segments_n(i, 2)= segments_n(i,2) + 10*2048;
    end
end
segments_n(segments_n<1) = 1;
segments_n(segments_n>signal_len) = signal_len;

% plot the segments
fig = figure();
plot(data.ref_signal);
hold on;
plot(segments_n(:, 1), data.ref_signal(segments_n(:, 1)), '*')
plot(segments_n(:, 2), data.ref_signal(segments_n(:, 2)), 'o');
set(findall(fig,'-property','LineWidth'),'LineWidth',2);
title([fileName, "with extension"])
figName = [filePath, '\f_', fileName, '_segments.png'];
figName_str = figName;
disp(["The figure has been saved as", figName_str])
saveas(fig, figName_str);
pause(2);
close;

%% extract segments and save to files
num_seg = 0;
for si = 1:size(segments, 1)
    num_seg = num_seg + 1;
    % extract contraction data
    seg_si = segments_n(si, 1);
    seg_ei = segments_n(si, 2);
    fileName_new = extract_segment_jf(fileName_raw, seg_si, seg_ei, num_seg);

    % rename data file
    % ['SG', num2str(si), '.mat']
    fileName_seg = replace(fileName_new, 'seg.mat', ['SG', num2str(si), '.mat']);
    disp(["The new file name:",fileName_seg])
    movefile(fileName_new, fileName_seg);
    disp(["After segmenting the data, the file has been resaved to", fileName_seg])
    % segments_n(si, :) = [seg_si, seg_ei];
    segList{si, 1} = fileName_seg;
    segList{si, 2} = [seg_si, seg_ei];
    segList{si, 3} = fileName_full;
end
end
