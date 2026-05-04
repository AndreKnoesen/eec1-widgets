% L11_Lab_DataCollection.m
% ENG 6 Spring 2026 — Group Project Lab: Accelerometer Data Collection
%
% Collects 20 seconds of smartphone accelerometer data for three activities:
%   walking, running, jumping
% Saves three files: walk_<id>.mat, run_<id>.mat, jump_<id>.mat
% Each file contains one variable: data — an N×4 matrix [Ax, Ay, Az, t]
%
% Run time: ~5 min per team. Upload files to the shared class folder when done.

clc;
fprintf("========================================\n");
fprintf("  ENG 6 — Group Project Data Collection \n");
fprintf("========================================\n\n");

fprintf("Before you start:\n");
fprintf("  1. Open MATLAB Mobile on one team member's phone\n");
fprintf("  2. Connect it to this MATLAB session (same Wi-Fi)\n");
fprintf("  3. The phone holder will perform each activity —\n");
fprintf("     hold the phone in your hand, portrait orientation\n\n");

input("Press Enter when your phone is connected and ready: ", "s");

% --- Connect to phone ---
fprintf("\nConnecting to phone...\n");
m = mobiledev;
fprintf("Connected. Sample rate: %.0f Hz\n\n", m.SampleRate);

% --- Student identifier (prevents filename collisions in the shared folder) ---
first   = strtrim(input("First name:    ", "s"));
last    = strtrim(input("Last name:     ", "s"));
section = strtrim(input("Lab section:   ", "s"));
id = lower(first) + "_" + lower(last) + "_" + lower(section);
fprintf("\nFiles will be saved as: walk_%s.mat, run_%s.mat, jump_%s.mat\n\n", id, id, id);

% --- Collection parameters ---
activities = ["walk",    "run",     "jump"   ];
labels     = ["Walking", "Running", "Jumping"];
duration   = 20;   % seconds per recording

% --- Record each activity ---
for k = 1:3

    fprintf("------------------------------------------\n");
    fprintf("  Activity %d of 3: %s\n", k, labels(k));
    fprintf("------------------------------------------\n");

    if k == 1
        fprintf("Walk at a normal pace, continuous and steady.\n");
    elseif k == 2
        fprintf("Run at a moderate pace — enough to be clearly different from walking.\n");
    else
        fprintf("Jump repeatedly in place, about one jump per second.\n");
    end

    fprintf("Duration: %d seconds\n", duration);
    fprintf("Keep the phone in your hand throughout — do not pocket it.\n\n");

    input("Press Enter when the phone holder is ready to start: ", "s");

    % Clear any previous log data
    discardlogs(m);

    % Start recording
    m.Logging = 1;
    fprintf("Recording: ");
    for s = duration:-1:1
        fprintf("%d ", s);
        pause(1);
    end
    m.Logging = 0;
    fprintf("\n");

    % Retrieve data: accellog returns [t, x, y, z]
    raw = accellog(m);

    if isempty(raw)
        fprintf("WARNING: No data received for %s. Check phone connection and re-run the script.\n\n", labels(k));
        break;
    end

    % Rearrange to [Ax, Ay, Az, t] — format expected by the batch analysis loop
    data = [raw(:,2), raw(:,3), raw(:,4), raw(:,1)];

    % Save
    filename = activities(k) + "_" + id + ".mat";
    save(filename, "data");

    n_samples = size(data, 1);
    t_span    = data(end,4) - data(1,4);
    fprintf("Saved: %s  |  %d samples  |  %.1f s  |  %.0f Hz\n\n", ...
            filename, n_samples, t_span, n_samples / t_span);

end

% --- Done ---
fprintf("==========================================\n");
fprintf("  Collection complete!\n");
fprintf("==========================================\n\n");

fprintf("Files saved in your current MATLAB folder:\n");
for k = 1:3
    fprintf("  %s_%s.mat\n", activities(k), id);
end

fprintf("\nNext step — upload to the shared class folder:\n");
fprintf("  Your TA will post the folder path in the course chat.\n");
fprintf("  Upload all three files before leaving lab.\n\n");

fprintf("The batch analysis loop you wrote in Lecture 11 will process\n");
fprintf("these files — and your classmates' — in Lecture 12.\n");
