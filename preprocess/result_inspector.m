% MATLAB script to sort all .mat files under a specific directory
% 
clc
clear
% Prompt the user to select a directory
selectedDir = uigetdir('', 'Select a Directory Containing .mat Files');

% Check if the user selected a directory
if isequal(selectedDir, 0)
    disp('No directory selected. Exiting.');
    return;
end

% Get all .mat files in the selected directory
matFiles = dir(fullfile(selectedDir, '*.mat'));

% Check if there are any .mat files in the directory
if isempty(matFiles)
    disp('No .mat files found in the selected directory.');
    return;
end

% Sort the .mat files by name
[~, sortedIndices] = sort({matFiles.name});
matFiles = matFiles(sortedIndices);
result_bad = cell(1, 0);
result_good = cell(1, 0);
% Display the sorted filenames
disp('Sorted .mat files:');
n = 1;
m = 1;
for k = 1:length(matFiles)
    disp(matFiles(k).name);
    fullPath = fullfile(selectedDir, matFiles(k).name);
    disp(fullPath);
    %TODO: add codes
    data_to_test = load(fullPath);
    ref_signal = data_to_test.ref_signal;
    figure();
    plot(ref_signal);
    title(["Reference Signal of:", matFiles(k).name]);
    pause(5);
    close;
    spike_to_test = data_to_test.spikes_seg;
    num_MU = size(spike_to_test, 1);
    for i =1:num_MU
        spike = spike_to_test(i, :);
        figure()
        plot(spike);
        title(["Spike for MU: ", i]);
        pause(2)
        close;
    end
    disp(["Finished loading: ", matFiles(k).name]);
    prompt = "Do you satisfy the segment of this data(Y/N)?";   
    decision = input(prompt, 's');
    if lower(decision) == 'n'
        result_bad{1, n} = matFiles(k).name;
        n = n + 1;
    elseif lower(decision) == 'y'
        result_good{1, m} = matFiles(k).name;
        m = m+1;
    end
    
end

% Optional: Save the sorted list to a .txt file
saveList = input('Would you like to save the sorted list to a .txt file? (y/n): ', 's');
if lower(saveList) == 'y'
    fileID = fopen(fullfile(selectedDir, 'sorted_mat_files.txt'), 'w');
    for k = 1:length(matFiles)
        fprintf(fileID, '%s\n', matFiles(k).name);
    end
    fclose(fileID);
    disp(['Sorted list saved to ', fullfile(selectedDir, 'sorted_mat_files.txt')]);
end