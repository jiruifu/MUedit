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
for k = 1:length(matFiles)
    disp(matFiles(k).name);
    fullPath = fullfile(selectedDir, matFiles(k).name);
    disp(fullPath);
    % [path, filename, ext] = fileparts(fullPath);
    %TODO: add codes
    new_data = prepareSignal(fullPath);
    disp('The output file after reformatting has been saved');

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