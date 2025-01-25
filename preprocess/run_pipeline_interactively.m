% MATLAB script to sort .mat files in a designated directory and process
% the
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
% Display the sorted filenames
disp('Sorted .mat files:');
num_mat = length(matFiles);
new_file_name_container = cell(num_mat, 1);
spike_array_container = cell(num_mat, 2);
data_w_spike_container = cell(num_mat, 2);
for k = 1:length(matFiles)
    disp(matFiles(k).name);
    fullPath = fullfile(selectedDir, matFiles(k).name);
    disp(fullPath);
    %TODO: add codes
    [new_file_name, new_spike_array, new_dataset] = add_spikes_jf(fullPath);
    newpath = new_file_name;
    segments2 = split_contractions_jf(newpath);
    new_file_name_container{k, 1} = new_file_name;
    spike_array_container{k, 1} = new_spike_array;
    spike_array_container{k, 2} = fullPath;
    data_w_spike_container{k, 1} = new_dataset;
    data_w_spike_container{k, 2} = fullPath;
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