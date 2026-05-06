---
marp: true
theme: eng6
paginate: true
---

<!-- _class: title -->

# Lecture 11
## Loops

**ENG 6: Engineering Problem Solving with Applied AI** | Spring 2026 | André Knoesen

---

## Where We Are

![Course arc diagram for Lecture 11](media/l11_course_arc.svg)
- L1–L10: Variables → Arrays → Branches → OOP → Applied Math → GUIs → Strings
- **Today (L11):** Loops — `while`, `for`, nested loops, `break`/`continue`
- In MP5, callbacks ran code *when something happened* — today's loops run code *when you want it to repeat*
- **Lab this week:** Group Project — collect smartphone accelerometer data for walking, running, and jumping

---

## Where We Are

- L1–L10: Variables → Arrays → Branches → OOP → Applied Math → GUIs → Strings
- **Today (L11):** Loops — `while`, `for`, nested loops, `break`/`continue`
- **Lab this week:** Group Project — collect smartphone accelerometer data for walking, running, and jumping

<div style="border: 2px dashed #888; border-radius: 14px; padding: 0.4rem 0.8rem; background: #f9f9f9; font-size: 0.82em; margin: 0.3rem 0;">
<strong>Group Project:</strong> collect smartphone sensor data for walking, running, and jumping; write a batch analysis script that loops over all recordings and computes metrics for each. Today's Activity 2 is that loop — save it as your starter code.
</div>

---

## Today's Plan

| Topic | What You'll Learn |
|---|---|
| While loops | The core concept — what makes a loop a loop |
| For loops | The counted iteration — and how they differ from while |
| **Activity 1** | Three ways to write the same computation — which wins? |
| Break & continue | Controlling flow inside a loop |
| **Activity 2** | The Group Project batch processing loop — built today |

---

<!-- _class: section -->

# While Loops

---

## What Is a Loop? (The Core Idea)

Without a loop, processing 1,000 samples requires writing the same line 1,000 times:

```matlab
process(data(1));
process(data(2));
process(data(3));
% ... 997 more lines
```

With a loop — one block, repeated as many times as needed:

```matlab
for i = 1:1000
    process(data(i));
end
```

---

## While Loop: Anatomy

```matlab
n = 0;                    % initialize before the loop
while n < 5               % condition checked at top of each iteration
    disp(n);              % body executes if condition is true
    n = n + 1;            % update — must bring condition closer to false
end
disp('done');
```

> "What does this print?"

---

## While Loop: Anatomy

```matlab
n = 0;                    % initialize before the loop
while n < 5               % condition checked at top of each iteration
    disp(n);              % body executes if condition is true
    n = n + 1;            % update — must bring condition closer to false
end
disp('done');
```

> "What does this print?"

**(a)** `0 1 2 3 4` — *hands up*

---

## While Loop: Anatomy

```matlab
n = 0;                    % initialize before the loop
while n < 5               % condition checked at top of each iteration
    disp(n);              % body executes if condition is true
    n = n + 1;            % update — must bring condition closer to false
end
disp('done');
```

> "What does this print?"

**(a)** `0 1 2 3 4` &nbsp;&nbsp;&nbsp;&nbsp; **(b)** `0 1 2 3 4 5` — *hands up*

---

## While Loop: Anatomy

```matlab
n = 0;                    % initialize before the loop
while n < 5               % condition checked at top of each iteration
    disp(n);              % body executes if condition is true
    n = n + 1;            % update — must bring condition closer to false
end
disp('done');
```

> "What does this print?"

**(a)** `0 1 2 3 4` &nbsp;&nbsp;&nbsp;&nbsp; **(b)** `0 1 2 3 4 5` &nbsp;&nbsp;&nbsp;&nbsp; **(c)** infinite output — *hands up*

---

## Condition Check: Before Every Iteration

```matlab
n = 0;
while n < 5               % ← checked here, before disp runs
    disp(n);
    n = n + 1;
end
disp('done');
```

Answer: **(a)** — prints `0 1 2 3 4`, then `done`

- When `n = 4`: condition `4 < 5` is true → body runs → `n` becomes 5
- When `n = 5`: condition `5 < 5` is **false** → loop exits → 5 is **never printed**
- **Key:** the condition is checked **before** the body runs, every time

---

## The Infinite Loop

```matlab
n = 0;
while n < 5
    disp(n);
    % forgot n = n + 1
end
```

- Missing the update → condition never becomes false → runs forever
- <span style="color:#cc0000; font-weight:bold;">Ctrl+C</span> stops a runaway loop in MATLAB

**Safety counter pattern — always add a maximum iteration guard:**

```matlab
n = 0;  max_iter = 1000;  iter = 0;
while n < 5 && iter < max_iter
    n = n + 1;
    iter = iter + 1;
end
```

---

## Real Scenario: Log Until N Samples

<div style="border: 2px dashed #888; border-radius: 14px; padding: 0.4rem 0.8rem; background: #f9f9f9; font-size: 0.82em; margin: 0 0 0.4rem 0;">
<strong><code>mobiledev</code></strong> — MATLAB object that connects to your smartphone running MATLAB Mobile (used in MP3–MP5). <strong><code>accellog(m)</code></strong> retrieves the accelerometer samples the phone has logged so far — each row is one time-stamped <em>[t, x, y, z]</em> reading. The row count grows as the phone continues logging.
</div>

```matlab
m = mobiledev;
m.Logging = 1;           % phone starts recording accelerometer data
target = 100;

while size(accellog(m), 1) < target   % rows logged so far < 100?
    pause(0.1);          % wait 100 ms, then check again
end

m.Logging = 0;           % stop recording
data = accellog(m);      % retrieve the full dataset
```

- The sample count grows over time — the loop keeps checking until enough rows arrive
- `for` would require knowing the final count upfront — impossible in real-time logging
- **Lab connection:** in the Group Project lab session, use this pattern to collect data until you have enough samples for each activity

---

## The Counting Pattern

```matlab
count = 0;               % initialize outside the loop
while some_condition
    % ... do work ...
    count = count + 1;   % appears in almost every loop
end
fprintf("Processed %d items\n", count);
```

- `count = count + 1` is the most common single line in all of programming
- Works for any counter: samples collected, events detected, iterations elapsed

<div style="border: 2px dashed #888; border-radius: 14px; padding: 0.5rem 1rem; background: #f9f9f9; font-size: 0.88em; margin: 0.4rem 0;">
MATLAB does <strong>not</strong> have <code>n++</code> — always write <code>n = n + 1</code>. This trips up everyone arriving from C or Python.
</div>

---

## While Loop: Check Your Model

```matlab
k = 1;
while k < 10
    k = k * 2;
end
disp(k)
```

> "What does `k` equal after this runs?"

---

## While Loop: Check Your Model

```matlab
k = 1;
while k < 10
    k = k * 2;
end
disp(k)
```

> "What does `k` equal after this runs?"

**(a)** 8 — *hands up*

---

## While Loop: Check Your Model

```matlab
k = 1;
while k < 10
    k = k * 2;
end
disp(k)
```

> "What does `k` equal after this runs?"

**(a)** 8 &nbsp;&nbsp;&nbsp;&nbsp; **(b)** 16 — *hands up*

---

## While Loop: Check Your Model

```matlab
k = 1;
while k < 10
    k = k * 2;
end
disp(k)
```

> "What does `k` equal after this runs?"

**(a)** 8 &nbsp;&nbsp;&nbsp;&nbsp; **(b)** 16 &nbsp;&nbsp;&nbsp;&nbsp; **(c)** 10 — *hands up*

---

## While Loop: Check Your Model

```matlab
k = 1;
while k < 10
    k = k * 2;
end
disp(k)
```

> "What does `k` equal after this runs?"

**(a)** 8 &nbsp;&nbsp;&nbsp;&nbsp; **(b)** 16 &nbsp;&nbsp;&nbsp;&nbsp; **(c)** 10 &nbsp;&nbsp;&nbsp;&nbsp; **(d)** infinite — *hands up*

---

## Reading a Loop Trace

```matlab
k = 1;
while k < 10
    k = k * 2;
end
disp(k)
```

Answer: **(b)** — `k = 16`

| k before check | `k < 10`? | body runs? | k after |
|---|---|---|---|
| 1 | true | yes | 2 |
| 2 | true | yes | 4 |
| 4 | true | yes | 8 |
| 8 | true | yes | 16 |
| 16 | **false** | **no** | — |

`k = 16` is the first value that **fails** the condition — the loop exits with `k = 16`

---

<!-- _class: section -->

# For Loops

---

## For Loop: The Counted Iteration

```matlab
for i = 1:5
    disp(i);
end
```

`for` is a while loop where the counter is managed automatically:

```matlab
% Equivalent while loop:
i = 1;
while i <= 5
    disp(i);
    i = i + 1;
end
```

- `1:5` produces `[1 2 3 4 5]` — loop variable takes each value in turn
- Body executes once per value; no manual increment needed
- `for` is not magic — it is convenient syntax for a counted while loop

---

## For Loop: Iterating Over Arrays

```matlab
signals = ["X", "Y", "Z", "Resultant"];   % 1×4 string array

for k = 1:length(signals)
    fprintf("Processing: %s\n", signals(k));   % same indexing as any array
end
```

- `signals(k)` returns the k-th string — standard `()` indexing, same as numeric arrays
- `length(signals)` returns 4 — same `length` you use on any array

```matlab
% Iterate directly over values (clean for fixed small sets)
for val = [1.5, 3.2, 7.8]
    fprintf("Value: %.2f\n", val);
end
```

In MP projects: almost always use `1:length(x)` or `1:size(data,1)`.

---

## Nested Loops: How Many Iterations?

```matlab
count = 0;
for row = 1:3
    for col = 1:4
        count = count + 1;
    end
end
disp(count)
```

> "What does `count` equal after this runs?"

---

## Nested Loops: How Many Iterations?

```matlab
count = 0;
for row = 1:3
    for col = 1:4
        count = count + 1;
    end
end
disp(count)
```

> "What does `count` equal after this runs?"

**(a)** 7 — *hands up*

---

## Nested Loops: How Many Iterations?

```matlab
count = 0;
for row = 1:3
    for col = 1:4
        count = count + 1;
    end
end
disp(count)
```

> "What does `count` equal after this runs?"

**(a)** 7 &nbsp;&nbsp;&nbsp;&nbsp; **(b)** 12 — *hands up*

---

## Nested Loops: How Many Iterations?

```matlab
count = 0;
for row = 1:3
    for col = 1:4
        count = count + 1;
    end
end
disp(count)
```

> "What does `count` equal after this runs?"

**(a)** 7 &nbsp;&nbsp;&nbsp;&nbsp; **(b)** 12 &nbsp;&nbsp;&nbsp;&nbsp; **(c)** 3 — *hands up*

---

## Nested Loops: How Many Iterations?

```matlab
count = 0;
for row = 1:3
    for col = 1:4
        count = count + 1;
    end
end
disp(count)
```

> "What does `count` equal after this runs?"

**(a)** 7 &nbsp;&nbsp;&nbsp;&nbsp; **(b)** 12 &nbsp;&nbsp;&nbsp;&nbsp; **(c)** 3 &nbsp;&nbsp;&nbsp;&nbsp; **(d)** 4 — *hands up*

---

## The Inner Loop Completes First

```matlab
count = 0;
for row = 1:3
    for col = 1:4
        count = count + 1;
    end
end
disp(count)
```

Answer: **(b)** — `count = 12`

- `row = 1` → col runs 1, 2, 3, 4 → 4 increments
- `row = 2` → col runs 1, 2, 3, 4 → 4 increments
- `row = 3` → col runs 1, 2, 3, 4 → 4 increments
- Total: 3 × 4 = **12**

The inner loop is like the seconds hand on a clock — it completes a full revolution before the outer loop (the minute hand) advances by one.

---

## When to Use While vs. For

| Use `while` when... | Use `for` when... |
|---|---|
| You don't know how many iterations in advance | You know the count or range in advance |
| Stopping depends on incoming data or a computed result | Iterating over a fixed array or index range |
| Sensor logging until a threshold is met | Processing each column of a data matrix |
| Real-time collection: Group Project lab data collection | Batch processing known files: Group Project analysis loop |

<div style="border: 2px dashed #888; border-radius: 14px; padding: 0.4rem 0.8rem; background: #f9f9f9; font-size: 0.82em; margin: 0.3rem 0;">
<strong>Good rule:</strong> if you can write <code>for i = 1:N</code> with a concrete N, use <code>for</code>. If you find yourself writing <code>while true</code> with a <code>break</code> — ask whether a proper <code>while condition</code> is cleaner.
</div>

---

<!-- _class: activity -->

# Activity 1: Three Ways to Write the Same Loop

**Teams of 3–4 | 20 min working + 5 min debrief**

Implement the resultant formula three different ways. Measure performance. Decide when each approach is appropriate.

> Open the Handout — Activity 1. Write your prediction before running each task.

---

## Activity 1 — Debrief

> "Raise your hand if your vectorized version was faster than your `for` loop by more than 10×."

---

## Activity 1 — Discussion

**Discussion anchors:**
- What does MATLAB do differently in the vectorized case that makes it so much faster than a loop?
- All three implementations should produce identical `R` — if any pair returned `isequal` = false, where was the error?
- Give one concrete example from this course where a loop is unavoidable — where step `i` depends on the result from step `i−1`.

**Teaching point:** The loop isn't wrong — it's sometimes the only tool that fits. The skill is knowing which situation you're in: a computation that vectorizes cleanly, or one where each step depends on the last.

---

<!-- _class: section -->

# Break, Continue, and Early Exit

---

## Break: Exit Early

```matlab
% Find the first sample exceeding threshold — stop as soon as found
threshold = 15;
first_idx = -1;

for i = 1:length(R)
    if R(i) > threshold
        first_idx = i;
        break;           % exit the loop immediately
    end
end
fprintf("First event at index %d\n", first_idx);
```

- <span style="color:#cc0000; font-weight:bold;">`break`</span> exits the **innermost** loop only
- Without `break`: scans the entire array even after finding the answer
- Use case: searching for the first event, stopping early on a condition

---

## Continue: Skip an Iteration

```matlab
% Process samples — skip any that are NaN (bad sensor readings)
clean_count = 0;
for i = 1:length(R)
    if isnan(R(i))
        continue;        % skip this iteration, jump to next i
    end
    clean_count = clean_count + 1;
    % ... process R(i) ...
end
fprintf("%d clean samples processed\n", clean_count);
```

- <span style="color:#cc0000; font-weight:bold;">`continue`</span> skips the rest of the current iteration, jumps to the next
- Use case: filtering out bad or invalid data without stopping the loop
- `continue` skips one pass; `break` exits entirely — these are different

---

## How Many Times Does fprintf Run?

```matlab
for file_idx = 1:3
    for sample_idx = 1:length(R)
        if R(sample_idx) > 25      % suspiciously high — bad data?
            break;                 % only exits the inner loop
        end
    end
    fprintf("Finished file %d\n", file_idx);
end
```

> "How many times does `fprintf` run?"

---

## How Many Times Does fprintf Run?

```matlab
for file_idx = 1:3
    for sample_idx = 1:length(R)
        if R(sample_idx) > 25
            break;
        end
    end
    fprintf("Finished file %d\n", file_idx);
end
```

> "How many times does `fprintf` run?"

**(a)** 0 — *hands up*

---

## How Many Times Does fprintf Run?

```matlab
for file_idx = 1:3
    for sample_idx = 1:length(R)
        if R(sample_idx) > 25
            break;
        end
    end
    fprintf("Finished file %d\n", file_idx);
end
```

> "How many times does `fprintf` run?"

**(a)** 0 &nbsp;&nbsp;&nbsp;&nbsp; **(b)** 1 — *hands up*

---

## How Many Times Does fprintf Run?

```matlab
for file_idx = 1:3
    for sample_idx = 1:length(R)
        if R(sample_idx) > 25
            break;
        end
    end
    fprintf("Finished file %d\n", file_idx);
end
```

> "How many times does `fprintf` run?"

**(a)** 0 &nbsp;&nbsp;&nbsp;&nbsp; **(b)** 1 &nbsp;&nbsp;&nbsp;&nbsp; **(c)** 3 — *hands up*

---

## How Many Times Does fprintf Run?

```matlab
for file_idx = 1:3
    for sample_idx = 1:length(R)
        if R(sample_idx) > 25
            break;
        end
    end
    fprintf("Finished file %d\n", file_idx);
end
```

> "How many times does `fprintf` run?"

**(a)** 0 &nbsp;&nbsp;&nbsp;&nbsp; **(b)** 1 &nbsp;&nbsp;&nbsp;&nbsp; **(c)** 3 &nbsp;&nbsp;&nbsp;&nbsp; **(d)** depends on data — *hands up*

---

## Break Scope: One Level Deep

```matlab
for file_idx = 1:3
    for sample_idx = 1:length(R)
        if R(sample_idx) > 25
            break;                 % exits inner loop only
        end
    end
    fprintf("Finished file %d\n", file_idx);  % outer loop continues
end
```

Answer: **(c)** — `fprintf` runs **exactly 3 times**, regardless of data

- `break` exits the *inner* loop — control returns to the **outer** loop's next iteration
- The outer loop is not affected by `break` in the inner loop
- To exit *all* loops: set a flag variable and check it in each loop's condition

---

## When Is a Loop Unavoidable?

Vectorized operations cannot replace a loop when **each step depends on the previous result:**

```matlab
% Cumulative sum — loop version
running_total = 0;
for i = 1:length(x)
    running_total = running_total + x(i);
    totals(i) = running_total;
end

% MATLAB built-in — same logic wrapped for you
totals = cumsum(x);
```

- `cumtrapz` from MP4 dead reckoning follows the same pattern: step `i` needs step `i-1`'s result
- **Rule:** if the computation at step `i` needs the result from step `i-1`, you need a loop
- Built-ins like `cumsum` and `cumtrapz` wrap those loops internally

---

<!-- _class: activity -->

# Activity 2: The Group Project Batch Processing Loop

**Teams of 3–4 | 23 min working + 7 min debrief**

Build the multi-file processing loop that forms the backbone of Group Project batch analysis. Leave with working code saved to your Group Project folder.

**Step 1 — generate the data files (run once before starting):**

```matlab
websave("SyntheticData.m", "https://aknoesen.github.io/eec1-widgets/SyntheticData.m");
SyntheticData
```

> Open the Handout — Activity 2. After Task 3, save a copy to your Group Project folder before continuing.

---

## Activity 2 — Debrief

> "Raise your hand if your loop successfully loaded all three files and produced three peak values."

---

## Activity 2 — Discussion

**Discussion anchors:**
- What is `results(i)` for a file that was skipped with `continue` — and why is that a potential bug in the summary?
- `results = zeros(1, length(files))` appears before the loop. What happens if you remove it? Why does preallocating matter?
- In the Group Project, the loop body might call methods on a `SensorDataAnalyzer` object. Sketch in words what that loop body would look like.

**Teaching point:** The loop structure is fixed — initialize, iterate, body, end. Only the body changes for different analyses. Every Group Project batch task uses this same four-line skeleton.

---

<!-- _class: section -->

# Wrap-Up

---

## What You Can Do Now + Lab Bridge

**You can now:**
- Write `while` loops that run until a condition changes
- Write `for` loops that count through arrays and index ranges
- Use `break` to exit early when you find what you need
- Use `continue` to skip invalid or uninteresting data
- Identify when a loop is unavoidable vs. replaceable with a vectorized operation

**In this week's lab:** collect your Group Project accelerometer data — use the `while` logging pattern (`while size(accellog(m),1) < target`) to capture enough samples for each activity.

**Activity 2 today:** the `for` loop over a string array of filenames is your batch analysis skeleton — it processes the files you collect in lab. Save it before you leave.

**Coming in L12:** you'll design a results structure — replacing the plain `results` array with named fields (`results(i).peak`, `results(i).activity`) to keep everything about each recording in one place.

---

## Decision Framework: Choosing Your Loop

| Situation | Tool |
|---|---|
| Iterate a fixed number of times or over a known array | `for` |
| Keep going until a condition changes | `while` |
| Stop the moment you find what you need | `break` inside either |
| Skip invalid or uninteresting data | `continue` inside either |
| Compute running totals or cumulative quantities | `cumsum`, `cumtrapz` (loops internally) |
| Apply the same analysis to many files | `for` over a cell array of filenames |

---

## Before Next Class

- Complete **RA #22** in ZyBooks before L12 — topic: **Structures**
- **Save your Activity 2 loop** — it becomes the skeleton for Group Project batch analysis
- **L12 preview:** structures organize the results your loop produces into named, extensible records — one entry per activity, with a name, a timestamp, and any fields you need

---

*ENG 6 Spring 2026 | Lecture 11 | Loops*
