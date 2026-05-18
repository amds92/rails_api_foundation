# Check CI Status

Check the GitHub Actions CI status for the current branch.

## Steps

1. Get current branch: `git branch --show-current`
2. List recent runs: `gh run list --branch $(git branch --show-current) --limit 5`
3. Get the latest run ID and view details: `gh run view <run_id>`
4. If failing, get the exact error: `gh run view <run_id> --log-failed`

## Output format

Show a clear summary:

```
Branch: <branch-name>
Status: ✅ GREEN / ❌ RED / 🟡 IN PROGRESS

Jobs:
  ✅ test (Ruby 3.2)
  ✅ test (Ruby 3.3)
  ✅ lint (RuboCop)
```

If any job is failing, show the exact failure lines extracted from the log — no noise, just the errors.

If CI is still running, say so and give an estimate based on typical run time (~1 min).
