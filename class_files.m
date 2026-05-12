% class_files.m  --  MiniProject 6: Class Sensor Dataset
%
% Run once at the start of your lab session.
% Unpacks the class dataset (data.zip, downloaded from Canvas) into
% your MATLAB Drive and defines the variable 'files' (Nx1 string
% array of local file paths).
%
% PREREQUISITE: download data.zip from Canvas and save it to your
% MATLAB Drive root (the same folder this script lives in).
%
% Usage:
%   run("class_files.m")
%   run("mp6_part4.m")

% ---------------------------------------------------------------
% Configuration
% ---------------------------------------------------------------
LOCAL_DIR = fullfile(userpath, "MiniProject6");
DATA_DIR  = fullfile(LOCAL_DIR, "data");
% ---------------------------------------------------------------

if ~exist(LOCAL_DIR, "dir")
    mkdir(LOCAL_DIR);
end

%% Unpack data.zip (skip if already extracted)
if ~isfolder(DATA_DIR) || isempty(dir(fullfile(DATA_DIR, "*.mat")))
    % Look for data.zip in MATLAB Drive root, then current directory
    candidates = [ string(fullfile(userpath, "data.zip"))
                   string(fullfile(pwd,      "data.zip")) ];
    zip_local = "";
    for c = candidates(:).'
        if isfile(c)
            zip_local = c;
            break;
        end
    end
    if zip_local == ""
        error(["Could not find data.zip. Download it from the Canvas " ...
               "MiniProject 6 assignment page and save it to your " ...
               "MATLAB Drive root, then re-run this script."]);
    end
    fprintf("Unpacking %s ...\n", zip_local);
    unzip(zip_local, LOCAL_DIR);
end

%% Build the file list (full local paths)
info  = dir(fullfile(DATA_DIR, "*.mat"));
files = strings(numel(info), 1);
for k = 1:numel(info)
    files(k) = string(fullfile(info(k).folder, info(k).name));
end

%% Summary
fprintf("\nReady.  ''files'' contains %d entries:\n", numel(files));
activities = extractBefore(string({info.name}), "_");
for act = ["walk", "run", "jump"]
    fprintf("  %-6s  %d files\n", act, sum(activities == act));
end
fprintf("\nNext step:  run(""mp6_part4.m"");\n");
