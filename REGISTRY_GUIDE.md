# Julia General Registry Guide

This guide follows the recommended Julia workflow:

1. **Register first** with Registrator
2. **Tag after the registry PR is merged** (preferably via TagBot)

This avoids re-tagging if the registration PR needs additional changes.

## ✅ Pre-registration Checklist

- Public GitHub repository
- `LICENSE` file present
- `Project.toml` has valid `name`, `uuid`, `version`, `authors`, and `[compat]`
- Tests pass locally
- README is clear and in English for General registry users

## 🚀 Recommended Registration Workflow

### Step 1: Push your latest changes

```bash
git add -A
git commit -m "Prepare for registry"
git push origin main
```

### Step 2: Run local checks before registration

```julia
using Pkg
Pkg.activate(".")
Pkg.instantiate()
Pkg.test()
```

### Step 3: Register with Registrator (do not tag yet)

Create a GitHub comment on the commit you want to register:

```
@JuliaRegistrator register
```

Registrator will open a PR against `JuliaRegistries/General`.

### Step 4: Address review feedback if needed

If changes are requested:

1. Commit fixes to your repository
2. Trigger Registrator again from the updated commit
3. Confirm the new registry PR is green

### Step 5: Wait for merge

General registry has an automatic waiting period for new packages (typically around 3 days), then maintainers merge if all checks pass.

### Step 6: Tag the release after merge (preferred: TagBot)

After the registry PR is merged, create the Git tag/release for that exact registered commit/version.

Using TagBot is recommended because it automates this step and keeps tags aligned with merged registry metadata.

## 🤖 TagBot Setup (Recommended)

Add `.github/workflows/TagBot.yml` (if not already present) based on the official template from TagBot docs.

At minimum, TagBot needs:
- `GITHUB_TOKEN`
- Trigger on `issue_comment` and/or scheduled run

Reference: https://github.com/JuliaRegistries/TagBot

## ⚠️ Common Problems

### UUID collision
Generate a new UUID:

```julia
using UUIDs
uuid4()
```

Then update `Project.toml`.

### Missing compat bounds
Add all direct dependencies to `[compat]` in `Project.toml`.

### Tests failing in CI
Fix tests locally with `Pkg.test()` before re-running Registrator.

### Repository not accessible
Ensure the repository is public and the URL in `Project.toml` is correct.

## 📚 References

- Registrator: https://github.com/JuliaRegistries/Registrator.jl
- General registry guidelines: https://github.com/JuliaRegistries/General
- TagBot: https://github.com/JuliaRegistries/TagBot
- Julia package creation guide: https://pkgdocs.julialang.org/dev/creating-packages/

## ✅ Final Checklist

Before commenting `@JuliaRegistrator register`:

- [ ] README is in English (or includes an English primary version)
- [ ] Tests pass locally (`Pkg.test()`)
- [ ] Repository is public
- [ ] `Project.toml` is complete and valid
- [ ] No placeholder UUID

After the General PR is merged:

- [ ] Create tag/release for the merged registered version (or let TagBot do it)

