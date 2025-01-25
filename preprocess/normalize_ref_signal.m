function norm_ref_signal = normalize_ref_signal(ref_signal)
%% generate segments based on the force profile
% this is designed for three repeated contractions
% the default output is 3*2 matrix
% the output can be extended to 6*2 by shift the orginal 3*2 matrix to left
% and right by random number of data points;

size_ref_signal = size(ref_signal);
if size_ref_signal(1) ~= 1
    ref_signal = ref_signal';
    num_samples = size(ref_signal, 2);
else
    num_samples = size(ref_signal, 2);
end

% ref_signal = smooth(ref_signal, 100)';
% 
% %% get reference signal (torque/force profile)
% Force_base = mean([ref_signal(1:4096), ref_signal(end-4096:end)]);
% Force_mean = mean(ref_signal);
% if Force_mean < Force_base
%     ref_signal = -ref_signal;
% end
% Force_raw = ref_signal;
% Force_raw = smooth(Force_raw, 100);
% dlen = length(Force_raw);
% Force_normal = (Force_raw-min(Force_raw));
% Force_scaler = max(Force_normal);
% Force_normal = Force_normal./Force_scaler;
% Force_normal = smooth(Force_normal);

% segments_t = segments_f;
ref_signal = (ref_signal-min(ref_signal));
ref_signal = ref_signal./max(ref_signal);
% ref_signal = Force_normal;
fig = figure();
plot(ref_signal);
title("The plot of reference signal with starting and end points")
hold on;
box off;
pause(5);
close;
if size(ref_signal, 1) ~= 1
    ref_signal = ref_signal';
end
norm_ref_signal = ref_signal;
disp('Normalization of reference signal is done!');
end