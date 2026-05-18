# Code Review

Perform a full code review of the rails_api_foundation gem.

## Steps

1. Read all files in `lib/rails_api_foundation/` and `lib/generators/`
2. Read all specs in `spec/`
3. Check `rails_api_foundation.gemspec`

## What to evaluate

**Architecture**
- Separation of concerns — is logic in the right place?
- No business logic in controllers or generators
- Service objects used correctly
- No circular dependencies between modules

**Ruby quality**
- Idiomatic Ruby (no unnecessary complexity)
- Proper use of modules and concerns
- Frozen string literals present
- No monkey patching

**Gem conventions**
- Gemspec complete and correct
- require_paths correct
- Dependencies justified and minimal

**Tests**
- Every public class/module has a spec
- Tests cover happy path and failure cases
- No Rails/ActiveRecord constants in unit specs (use doubles)
- Meaningful assertions, not just "does not raise"

**Error handling**
- Exceptions caught at the right level
- Error messages useful for debugging
- No swallowed exceptions

## Output format

Group findings by severity:

### CRITICAL — must fix before shipping
### CONCERN — should fix soon
### NITPICK — optional improvements

End with a one-line overall verdict.
