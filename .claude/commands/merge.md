# Safe Merge to Main

Merge the current branch to main safely — only if CI is green.

## Steps

1. Get current branch: `git branch --show-current`
   - If already on main, abort and say so.

2. Check CI status with `gh run list --branch <branch> --limit 1`
   - If no runs exist: abort, say "no CI runs found for this branch"
   - If still running: abort, say "CI still in progress — wait and retry"
   - If failing: show the failures and abort. Do NOT merge.

3. If CI is green:
   ```sh
   git checkout main
   git pull origin main
   git merge --no-ff <branch> -m "Merge branch '<branch>'"
   git push origin main
   git push origin --delete <branch>
   git branch -d <branch>
   ```

4. Confirm success: show the new commit on main with `git log --oneline -3`

## Rules

- Never merge if CI is red or unknown
- Never force push to main
- Always use --no-ff to preserve branch history
- Delete the branch after merge (remote + local)
