# Ship

Full readiness check before merging to main. Runs review + CI check and only merges if both pass.

## Steps

### 1. Code Review
Run the full review (same as /review):
- Read all lib/ and spec/ files
- Check architecture, Ruby quality, gem conventions, tests, error handling
- If any CRITICAL issues found: list them and abort. Do not merge until fixed.

### 2. CI Check
Run the CI check (same as /ci):
- If CI is red or in progress: show status and abort.
- Only continue if all jobs are green.

### 3. Merge
If review has no CRITICAL issues AND CI is green:
- Merge to main using safe merge flow (same as /merge)
- Delete the branch

## Output format

```
=== REVIEW ===
[findings or "No critical issues found"]

=== CI ===
[job status]

=== RESULT ===
✅ Merged to main  /  ❌ Aborted — [reason]
```

## Philosophy

This command exists so nothing broken ever lands on main. A single /ship tells you exactly where you stand and either ships cleanly or tells you exactly what to fix.
