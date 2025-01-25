

%%
function new_data=prepareSignal(fullname, num_grid, gridname, muscle)
% Load the HDEMG signal, remove the empty channel, and reshape to
% n_channels by n_samples

    dataset = load(fullname);
    [path, fname, ext] = fileparts(fullname);
    ref_signal = dataset.ref_signal;
    norm_ref_signal = normalize_ref_signal(ref_signal);
    dataset.norm_ref_signal = norm_ref_signal;
    emg_signal = dataset.SIG;
    empty_idx = cellfun(@isempty, emg_signal);
    signal_refine = cell2mat(emg_signal(~empty_idx));
    fs = dataset.fsamp;
    size_emg = size(signal_refine);
    n_channel = size_emg(1);
    force_path = dataset.norm_ref_signal;
    ref_signal = dataset.norm_ref_signal;
    if nargin == 1
        % The default HDEMG grid is the 8mm IED 13by5 grid and the default
        % number of grid is 1
        num_grid = 1;
        gridname = "GR08MM1305";
        muscle = "not defined";
    end
    
    ngrid = num_grid;
    grid = gridname;
    
    signal = struct("data", signal_refine, "fsamp", fs, ... 
        "nChan", n_channel, "ngrid", num_grid, "gridname", gridname, 'muscle', muscle, 'target', ref_signal, 'path', force_path);
    new_data = signal;
    dataName = fullname;
    dataset.signal = signal;
    save(dataName, "-struct", "dataset");
    disp('The output file after reformatting has been saved');
end

