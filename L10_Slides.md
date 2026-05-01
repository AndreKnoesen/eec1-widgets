---
marp: true
theme: eng6
paginate: true
---

<!-- _class: title -->

# Lecture 10
## Strings and Characters

**ENG 6: Engineering Problem Solving with Applied AI** | Spring 2026 | André Knoesen

---

## Where We Are

![Course arc diagram for Lecture 10](media/l10_course_arc.svg)
- L1–L9: Variables → Arrays → Branches → OOP → Applied Math → GUIs
- **Today (L10):** Strings — create, measure, build, compare, and parse text
- **Lab this week:** Mini-Project 5

<div style="border: 2px dashed #888; border-radius: 14px; padding: 0.4rem 0.8rem; background: #f9f9f9; font-size: 0.82em; margin: 0.3rem 0;">
<strong>Parse</strong> — read structured text and extract meaningful pieces from it. Example: splitting <code>"timestamp,X_accel,Y_accel"</code> into its three column names.
</div>

---

<!-- _class: section -->

# Strings as a Data Type

---

## Text in MATLAB

```matlab
name = "Knoesen";
tf1  = isstring(name)        % true
c    = class(name)           % 'string'
tf2  = isStringScalar(name)  % true  — exactly one string, not an array
```

<div style="border: 2px dashed #888; border-radius: 14px; padding: 0.5rem 1rem; background: #f9f9f9; font-size: 0.88em; margin: 0.4rem 0;">
A <strong><span style="color:#cc0000;">string</span></strong> is created with <code>"double quotes"</code>. It stores text as a first-class MATLAB data type.
</div>

<div style="border: 2px dashed #888; border-radius: 14px; padding: 0.5rem 1rem; background: #f9f9f9; font-size: 0.88em; margin: 0.4rem 0;">
MATLAB's string API is large — <code>isstring</code>, <code>ischar</code>, <code>isStringScalar</code>, <code>iscellstr</code>, and many more type checks; plus dedicated string functions for searching, splitting, formatting, and more. The full list is in MATLAB documentation under <strong>"Text and Strings."</strong> This lecture covers the essential subset.
</div>

---

## String Arrays

Strings follow the same array rules as numbers:

```matlab
channels = ["X Accel", "Y Accel", "Z Accel"];   % 1×3 string array
channels(2)       % "Y Accel"
channels(end)     % "Z Accel"
channels([1 3])   % ["X Accel", "Z Accel"]
```

*(MATLAB also accepts spaces as separators — `["X Accel" "Y Accel"]` is valid — but always use commas to keep intent unambiguous.)*

Three different measurements:

```matlab
sz = size(channels)          % [1 3]   — 1 row, 3 columns (same as numeric)
nl = strlength(channels)     % [7 7 7] — characters inside each string
n  = numel(channels)         % 3       — how many elements in the array
```

<span style="color:#cc0000; font-weight:bold;">`strlength`</span>, not `length` — `length(channels)` returns 3 (the array dimension), not character counts.

---

<!-- _class: section -->

# Building and Transforming Strings

---

## Case and Whitespace

```matlab
s  = "  Z Accel  ";
lo = lower(s)               % "  z accel  "
up = upper(s)               % "  Z ACCEL  "
tr = strtrim(s)             % "Z Accel"
```

<div style="border: 2px dashed #888; border-radius: 14px; padding: 0.4rem 0.8rem; background: #f9f9f9; font-size: 0.82em; margin: 0.3rem 0;">
<strong>Whitespace</strong> — any character that renders as blank: regular space <code>' '</code>, tab <code>'\t'</code>, newline <code>'\n'</code>. <code>strtrim</code> removes whitespace from the <strong>leading and trailing ends only</strong> — whitespace inside the string is unchanged. Normalizing internal whitespace requires <code>replace</code> — covered in the Replacing Content slide.
</div>

Inspect individual characters:

```matlab
t   = "Lab3A";
tfl = isletter(t)              % [1 1 1 0 1]  — true at letter positions
tfs = isspace(t)               % [0 0 0 0 0]  — true at space positions
tfd = isstrprop(t, "digit")    % [0 0 0 1 0]  — true at digit position
```

---

## Concatenation

```matlab
sensor = "IMU";
run    = "03";

s1 = sensor + "_" + run          % "IMU_03"   (+ operator)
s2 = append(sensor, "_", run)    % "IMU_03"   (explicit — handles arrays too)
```

<div style="border: 2px dashed #888; border-radius: 14px; padding: 0.5rem 1rem; background: #f9f9f9; font-size: 0.88em; margin: 0.4rem 0;">
<code>strcat</code> also concatenates but has a quirk with char vectors — use <code>+</code> or <code>append</code> for predictable results with strings. <em>Char vectors introduced in the Comparing and Searching section.</em>
<br><br>
Mixing numbers into strings: <code>"Samples: " + n</code> works, but MATLAB chooses the number format — use <code>num2str(n)</code> for controlled output (see the Numbers ↔ Text slide).
</div>

---

## Numbers ↔ Text

```matlab
n = 500;   dt = 0.01;   duration = n * dt;   % 5.0

% Number → text
raw   = "Duration: " + num2str(duration)                  % "Duration: 5"
label = "Duration: " + num2str(duration, "%.1f") + " s"  % "Duration: 5.0 s"
fmt   = sprintf("Run %02d of %d", 3, 10)                 % "Run 03 of 10"

% Text → number
val1 = str2double("3.14")    % 3.1400
val2 = str2double("abc")     % NaN    — invalid input returns NaN, not an error
```

<div style="border: 2px dashed #888; border-radius: 14px; padding: 0.5rem 1rem; background: #f9f9f9; font-size: 0.85em; margin: 0.3rem 0;">
<strong>Format codes</strong> — <code>%</code> marks the conversion, followed by optional width/precision and a type character:<br>
<code>%d</code> integer &nbsp;·&nbsp; <code>%f</code> fixed-point &nbsp;·&nbsp; <code>%.1f</code> 1 decimal place &nbsp;·&nbsp; <code>%.2f</code> 2 decimal places &nbsp;·&nbsp; <code>%e</code> scientific &nbsp;·&nbsp; <code>%02d</code> integer padded to 2 digits
</div>

---

<!-- _class: activity -->

# Activity 1: Building Strings

**Teams of 3–4 | 20 min working + 5 min debrief**

Write three functions that construct formatted strings from structured data.

> Open the Handout — Activity 1. On your own first — write your predicted output for each test case before discussing with your team.

---

## Activity 1 — Debrief

> "Raise your hand if `reportLine` produced a different format than the specification on the first try."

---

## Activity 1 — Discussion

**Discussion anchors:**
- Where did `num2str` format codes matter — what happened without `"%.1f"`?
- Which concatenation pattern did your team use — `+`, `append`, or `sprintf`? Is there a case where one is clearly better?
- What problem does `strtrim` in `sensorLabel` prevent?

**Teaching point:** Formatting is a contract between your code and the human reading the output. A missing decimal place or extra space is not cosmetic — it is a broken specification.

---

<!-- _class: section -->

# Comparing and Searching

---

## char — What It Is and When You'll Encounter It

<div style="border: 2px dashed #888; border-radius: 14px; padding: 0.5rem 1rem; background: #f9f9f9; font-size: 0.88em; margin: 0.3rem 0;">
<strong>ASCII</strong> (American Standard Code for Information Interchange) — assigns a number to every character: <code>'A'</code> = 65, <code>'a'</code> = 97, <code>'0'</code> = 48, space = 32. A <strong><span style="color:#cc0000;">char vector</span></strong> (<code>'single quotes'</code>) stores text as a numeric array of these codes — arithmetic on char operates on the numbers, not the letters.
</div>

**Where you will see char:** documentation, older textbooks, some built-in return values, and legacy code

**When char makes sense to write:**
- ASCII arithmetic: `'A' + 1` → `66` → `char(66)` → `'B'`
- Interfacing with an older function that explicitly requires char input

Write new code with `"double quotes"`. If you receive a char, convert it to string with `string(c)` — char in, string out. String functions such as `strcmp`, `contains`, and `strtrim` accept both types.

---

## char Arithmetic in Action

<pre style="background:#f0f0f0; color:#111; padding:0.7rem 1rem; border-radius:4px; border-left:4px solid #bbb; font-size:0.82rem; line-height:1.45; overflow:visible;">function encoded = shiftLetters(s, n)
% Shift every lowercase letter n positions forward in the alphabet (wraps a–z).
%
% Inputs:
%   s - 1x1  string  input text
%   n - 1x1  double  number of positions to shift
%
% Outputs:
%   encoded - 1x1  string  encoded text
<strong style="color:#cc0000;">c       = char(s);</strong>                           % string → char for arithmetic
mask    = (c &gt;= 'a') &amp; (c &lt;= 'z');
c(mask) = char(mod(c(mask) - 'a' + n, 26) + 'a'); % shift each letter
<strong style="color:#cc0000;">encoded = string(c);</strong>                         % char → string to return
end</pre>

<div style="border: 2px dashed #888; border-radius: 14px; padding: 0.4rem 0.8rem; background: #f9f9f9; font-size: 0.82em; margin: 0.3rem 0;">
<code>string</code> arithmetic (<code>s + n</code>) shifts array elements, not letters. <code>char(s)</code> exposes ASCII codes — <code>c(mask) - 'a' + n</code> shifts each letter by position, and <code>mod(..., 26)</code> wraps past <code>'z'</code> back to <code>'a'</code>. Return to <code>string</code> with <code>string(c)</code>.
</div>

---

## Comparing Text with `==`

*Applying `==` to a char vector — to reveal a surprise:*

```matlab
a = 'hello';
b = 'hello';
result = (a == b)
```

> "What does `result` contain?"

---

## Comparing Text with `==`

*Applying `==` to a char vector — to reveal a surprise:*

```matlab
a = 'hello';
b = 'hello';
result = (a == b)
```

> "What does `result` contain?"

**(a)** `true` — one logical value — *hands up*

---

## Comparing Text with `==`

*Applying `==` to a char vector — to reveal a surprise:*

```matlab
a = 'hello';
b = 'hello';
result = (a == b)
```

> "What does `result` contain?"

**(a)** `true` — one value &nbsp;&nbsp;&nbsp;&nbsp; **(b)** `[1 1 1 1 1]` — a logical array — *hands up*

---

## Use `strcmp`, Not `==`

Because char stores text as **ASCII numbers**, `==` compares each position separately — the result is an array, not a yes/no:

```matlab
a = 'hello';   b = 'hello';
result = (a == b)   % [1 1 1 1 1]  — five answers, not one

if (a == b)         % MATLAB evaluates: if [1 1 1 1 1]
end                 % only true when ALL positions match AND lengths are equal
                    % throws an error when lengths differ
```

Use <span style="color:#cc0000; font-weight:bold;">`strcmp`</span> — it asks "are these the same text?" and works safely on **both** char and string:

```matlab
tf = strcmp(a, b)   % true
```

For string type (`"double quotes"`), `==` does return a scalar `true`/`false` — but `strcmp` is the safe habit regardless of type.

---

## Exact Comparison

```matlab
sensor = "Z Accel";

tf1 = strcmp(sensor, "Z Accel")     % true   exact, case-sensitive
tf2 = strcmpi(sensor, "z accel")    % true   exact, ignore case
tf3 = matches(sensor, "Z Accel")    % true   scales to arrays and pattern lists
```

<div style="display:flex; gap:1.5rem; align-items:flex-start; margin-top:0.4rem;">
<div style="flex:1; background:#f0f0f0; padding:0.6rem 0.8rem; border-left:4px solid #002855; font-size:0.82em;">

**Choosing:**
`strcmp` — standard, always safe
`strcmpi` — user input or file data
`matches` — multiple patterns at once

</div>
<div style="flex:1;">

```matlab
% matches against a list:
s  = "Z Accel";
tf = matches(s, ["Z Accel", "Z Axis"])
% true
```

</div>
</div>

---

## Partial Matching

```matlab
label = "X Axis Acceleration";

tf1 = contains(label, "Axis")                     % true
tf2 = contains(label, "axis", IgnoreCase=true)    % true
tf3 = startsWith(label, "X")                      % true
tf4 = endsWith(label, "tion")                     % true
```

All four work on string arrays — the result has the same shape as the input:

```matlab
channels = ["X Accel", "Y Accel", "Z Accel", "Resultant"];
mask = contains(channels, "Accel")   % [true true true false]
```

---

## Finding Positions

```matlab
header = "timestamp,X_accel,Y_accel,Z_accel";
idx    = strfind(header, ",")   % [10 18 26]  — position of every comma
```

`strfind` returns indices — use it when you need to know *where* something appears, not just *whether* it appears.

For most filtering tasks the logical functions `contains` / `startsWith` / `endsWith` are what is needed and also more readable. Reach for `strfind` when the position itself matters.

---

<!-- _class: activity -->

# Activity 2: char Indexing

**Personal | 8 min — do not discuss yet.**

Write `isPalindrome(s)` — return `true` if `s` reads the same forwards and backwards, ignoring case.

Before writing the function body: predict the result for `"racecar"`, `"hello"`, and `"Level"`.

---

## Activity 2 — Debrief

> "Raise your hand if `isPalindrome("Level")` returned the correct answer on the first try."

---

## Activity 2 — Discussion

**Discussion anchors:**
- What does `c(end:-1:1)` return — and why does this work on a char vector but not directly on a string scalar?
- Why apply `lower` before converting to char, not after reversing?
- What would `s == s(end:-1:1)` do if `s` were a string instead of a char vector?

**Teaching point:** A char vector is a numeric array with a character display — `c(end:-1:1)` is the same reversal idiom used on any array. String scalars do not support element-by-element subscripting the same way, which is exactly why the `char` conversion is the right tool here.

---

<!-- _class: section -->

# Extracting, Replacing, and Splitting

---

## Extracting Parts

`extractBefore`, `extractAfter`, and `extractBetween` locate a boundary pattern in a string and return the text on one side — or between two boundaries. Use them to pull structured information out of filenames, header fields, or data labels.

```matlab
filename = "sensor_2026-04-25_run03.csv";

before  = extractBefore(filename, "_run")                % "sensor_2026-04-25"
after   = extractAfter(filename, "sensor_")              % "2026-04-25_run03.csv"
between = extractBetween(filename, "sensor_", "_run03")  % "2026-04-25"
```

The result type matches the input; all three accept string arrays and process each element.

---

## Replacing Content

`replace` substitutes every occurrence of a pattern with new text. Use it to normalize inconsistent separators, fix encoding artifacts, or clean up whitespace. `strrep` does the same and works on both char and string.

```matlab
raw = "X-Accel";
s1  = replace(raw, "-", " ")    % "X Accel"
s2  = strrep(raw, "-", "_")     % "X_Accel"
```

Replace with `""` to remove text, or fix internal whitespace:

```matlab
s3 = replace("Z  Accel", "  ", " ")             % "Z Accel"   double→single space
s4 = replace("remove  extra  spaces", "  ", " ") % "remove extra spaces"
```

`replace` works element-wise on string arrays.

---

## Splitting and Joining

`split` divides a string at a delimiter and returns the pieces as a string array — the inverse of concatenation. `join` re-assembles a string array into one string with a chosen separator.

```matlab
header = "timestamp,X_accel,Y_accel,Z_accel";
cols   = split(header, ",")
% ["timestamp"; "X_accel"; "Y_accel"; "Z_accel"]  — column vector

n      = numel(cols)         % 4

joined = join(cols, " | ")   % "timestamp | X_accel | Y_accel | Z_accel"
```

`split` returns a **column** vector of strings by default. Transpose with `'` when a row is needed.

---

<!-- _class: activity -->

# Activity 3: Parsing Structured Text

**Teams of 3–4 | 20 min working + 5 min debrief**

Extract and normalize information embedded in structured text strings.

> Open the Handout — Activity 3. On your own first — write your predicted output before discussing with your team.

---

## Activity 3 — Debrief

> "Raise your hand if your date extraction gave a different result than expected on the first try."

---

## Activity 3 — Discussion

**Discussion anchors:**
- When you `split` the header string, what type and shape is the result?
- In what order did you apply `lower` and `replace` for normalization — and why does order matter?
- What breaks if the delimiter in the filename changes from `_` to `-`?

**Teaching point:** Parsing converts brittle text into structured data. Every `split` and `extractBetween` assumes a fixed format. If the format changes, the parser breaks. Good parsers make their format assumptions explicit.

---

## When String Operations Stack Up

Real CSV header — column names are inconsistent, units attached, separators vary:

```
"Timestamp(s), X_Accel[m/s2], Y-Accel [m/s2], z accel(m/s2)"
```

Goal: `["timestamp", "x_accel", "y_accel", "z_accel"]`

```matlab
raw  = "Timestamp(s), X_Accel[m/s2], Y-Accel [m/s2], z accel(m/s2)";

cols = strtrim(split(raw, ","));                              % split fields
cols = lower(cols);                                           % lowercase
cols = replace(cols, ["(s)", "(m/s2)", "[m/s2]"], "");         % strip known units
cols = strtrim(replace(replace(cols, "-", "_"), " ", "_"));  % fix separators
% → ["timestamp", "x_accel", "y_accel", "z_accel"]
```

Every function here is from today. It works — for this exact set of unit formats. What if someone writes `[m/s^2]` instead? Or `(M/S²)`? The `replace` list grows with every new variant.

---

## Beyond `replace` — Regular Expressions

`replace` handles *known* patterns. Real-world text has *unknown* patterns — the next level up is regex.

<div style="border: 2px dashed #888; border-radius: 14px; padding: 0.5rem 1rem; background: #f9f9f9; font-size: 0.88em; margin: 0.3rem 0;">
A <strong><span style="color:#cc0000;">regular expression</span></strong> is a pattern-matching mini-language built into nearly every programming environment. One pattern replaces dozens of <code>replace</code> calls. In MATLAB: <code>regexp</code> finds matches; <code>regexprep</code> substitutes them.
</div>

**Live demo — AI writes the regex:**

LSM6DS3 (ST) — the IMU family used in iPhones. Paste from View Source on `st.com/en/mems-and-sensors/lsm6ds3.html`:

```matlab
% st.com/en/mems-and-sensors/lsm6ds3.html → View Source → copy table rows
html = "<td>Accelerometer full-scale range: ±2 g, ±4 g, ±8 g, ±16 g</td>" + ...
       "<td>Gyroscope full-scale range: ±125, ±250, ±500, ±1000, ±2000 dps</td>" + ...
       "<td>Supply voltage: 1.71 V – 3.6 V</td>";
```

*Prompt to AI:* "Write MATLAB code to extract all numerical measurement values with units from this HTML string"

**Regular expressions are not part of this course.** Two things to know:
- They exist, they are powerful, and you will encounter them in practice
- **AI writes excellent regex** — describe what you need in plain English; it returns working code and explains every part of the pattern

---

## What You Can Do Now + Lab Bridge

**You can now:**
- Create and index string arrays · measure with `strlength` and `numel`
- Transform text: `lower`, `upper`, `strtrim`, `isletter`, `isspace`
- Concatenate with `+` and `append` · format numbers with `num2str` and `sprintf`
- Compare with `strcmp`, `strcmpi`, `matches`, `contains`, `startsWith`, `endsWith`
- Extract, replace, and split structured text with `extractBetween`, `replace`, `split`
- Convert with `char(s)` for ASCII arithmetic, `string(c)` to return to string

**In MP5:** dropdown values are strings — `strcmp` routes callbacks; `+` and `num2str` build axis labels and titles; `split` and `contains` parse any data file that has a header row.

**Next lecture:** Loops — strings and loops together enable batch processing of multiple files and datasets.

---

## String Operations — Reference

<div style="font-size: 0.82em;">

| Task | Function |
|---|---|
| Type check | `isstring`, `ischar`, `isStringScalar` |
| Measure length | `strlength` |
| Case / trim | `lower`, `upper`, `strtrim` |
| Character test | `isletter`, `isspace`, `isstrprop` |
| Concatenate | `+`, `append` |
| Number → text | `num2str`, `sprintf` |
| Text → number | `str2double` |
| Exact compare | `strcmp`, `strcmpi`, `matches` |
| Partial test | `contains`, `startsWith`, `endsWith` |
| Find position | `strfind` |
| Extract | `extractBefore`, `extractAfter`, `extractBetween` |
| Replace | `replace`, `strrep` |
| Split / join | `split`, `join` |
| Convert to char / codes | `char`, `double` |

</div>

---

*ENG 6 Spring 2026 | Lecture 10 | Strings and Characters*
