% class_files.m  --  MiniProject 6: Class Sensor Dataset
%
% Run once at the start of your lab session.
% Downloads all class .mat recordings to your MATLAB Drive and
% creates the variable 'files' (Nx1 string array of local paths).
%
% Usage:
%   run("class_files.m")
%   run("mp6_part4.m")

% ---------------------------------------------------------------
% Configuration -- set by TA before posting
% ---------------------------------------------------------------
REPO_RAW  = "https://aknoesen.github.io/eec1-widgets/";
LOCAL_DIR = fullfile(userpath, "MiniProject6", "data");
% ---------------------------------------------------------------

%% Create local folder
if ~exist(LOCAL_DIR, "dir")
    mkdir(LOCAL_DIR);
end

%% Fetch manifest (list of filenames, one per line)
fprintf("Fetching file list ...\n");
manifest_local = fullfile(LOCAL_DIR, "manifest.txt");
websave(manifest_local, REPO_RAW + "manifest.txt");

fid   = fopen(manifest_local, "r");
raw   = textscan(fid, "%s");
fclose(fid);
names = string(raw{1});
n     = numel(names);
fprintf("  %d recordings in class dataset.\n\n", n);

%% Download recordings (skips files already present)
fprintf("Downloading recordings ...\n");
files = strings(n, 1);

for k = 1:n
    dest = fullfile(LOCAL_DIR, names(k));
    if ~isfile(dest)
        websave(dest, REPO_RAW + "data/" + names(k));
    end
    files(k) = dest;
    if mod(k, 25) == 0 || k == n
        fprintf("  %d / %d\n", k, n);
    end
end

%% Summary
fprintf("\nReady.  ''files'' contains %d entries:\n", n);
activities = extractBefore(names, "_");
for act = ["walk", "run", "jump"]
    fprintf("  %-6s  %d files\n", act, sum(activities == act));
end
fprintf("\nNext step:  run(""mp6_part4.m"");\n");
