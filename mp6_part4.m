% mp6_part4.m  --  MiniProject 6: Derive and Evaluate Your Classifier
%
% Run after completing Problems 1-3 and running class_files.m.
% Copy the entire output block and paste it into the Canvas quiz.
%
% Usage:
%   run("class_files.m")     % defines 'files'
%   run("mp6_part4.m")

T = buildResultsTable(files, 0);   % threshold=0; decision boundaries derived below
fprintf("Total recordings: %d\n\n", height(T));

% --- Step 1: Examine the feature distributions by activity ---
fprintf("=== PEAK ACCELERATION BY ACTIVITY (m/s^2) ===\n");
for act = ["walk", "run", "jump"]
    rows = T(T.activity == act, :);
    fprintf("%-6s  n=%3d  mean=%5.2f  std=%4.2f  min=%5.2f  max=%5.2f\n", ...
        act, height(rows), mean(rows.peak), std(rows.peak), ...
        min(rows.peak), max(rows.peak));
end

% --- Step 2: Set decision boundaries from the data ---
% Place each boundary at the midpoint between adjacent class means.
walk_mean = mean(T(T.activity == "walk", :).peak);
run_mean  = mean(T(T.activity == "run",  :).peak);
jump_mean = mean(T(T.activity == "jump", :).peak);

thresh_wr = (walk_mean + run_mean)  / 2;
thresh_rj = (run_mean  + jump_mean) / 2;

fprintf("\n=== DECISION BOUNDARIES ===\n");
fprintf("  walk | run  boundary:  %.2f m/s^2\n", thresh_wr);
fprintf("  run  | jump boundary:  %.2f m/s^2\n", thresh_rj);

% --- Step 3: Classify every recording ---
predicted = strings(height(T), 1);
for i = 1:height(T)
    if     T.peak(i) < thresh_wr,  predicted(i) = "walk";
    elseif T.peak(i) < thresh_rj,  predicted(i) = "run";
    else,                           predicted(i) = "jump";
    end
end

% --- Step 4: Evaluate accuracy ---
fprintf("\n=== CLASSIFICATION ACCURACY ===\n");
n_total   = height(T);
n_correct = sum(predicted == T.activity);
fprintf("Overall:  %d / %d  (%.1f%%)\n", n_correct, n_total, 100*n_correct/n_total);
for act = ["walk", "run", "jump"]
    mask = T.activity == act;
    nc   = sum(predicted(mask) == act);
    fprintf("  %-6s  %d / %d  (%.1f%%)\n", act, nc, sum(mask), 100*nc/sum(mask));
end

% --- Step 5: Find your own recordings ---
my_name = "firstname_lastname";   % REPLACE with your name, all lowercase, underscore
my_rows = T(contains(T.filename, my_name), :);
fprintf("\n=== MY RECORDINGS ===\n");
for i = 1:height(my_rows)
    p = my_rows.peak(i);
    if     p < thresh_wr,  pred = "walk";
    elseif p < thresh_rj,  pred = "run";
    else,                  pred = "jump";
    end
    result = "correct";
    if pred ~= my_rows.activity(i), result = "MISCLASSIFIED"; end
    fprintf("  %-6s  peak=%5.2f  predicted=%-6s  %s\n", ...
        my_rows.activity(i), p, pred, result);
end

fprintf("\n=== Paste everything above into the Canvas quiz. ===\n");
