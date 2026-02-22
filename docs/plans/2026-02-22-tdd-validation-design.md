# Design: TDD Validation for Legion

**Date**: 2026-02-22
**Status**: Approved
**Approach**: A — Split Responsibilities (Centurion writes tests, Vigil executes test plan)

## Problem

Vigil currently performs a code review + existing test run, but never **executes the test plan** that Tribunus generates. If there are no pre-existing tests, Vigil just "notes it and increases code review scrutiny." The verification criteria in Tribunus's plans are treated as a checklist to eyeball, not as test scenarios to actually run.

## Design Decisions

| Decision | Choice |
|----------|--------|
| Agent architecture | Enhance Vigil (no new agent) |
| Manual test handling | Non-blocking — present as recommendation after VERIFIED |
| Test writing | Yes — Centurion writes tests when missing |
| Plan format | Add `## Test Plan` section to Tribunus output |
| Test quality | Vigil reviews test quality (no trivial assertions) |

## Changes Required

### 1. Tribunus (`agents/tribunus.md`)

Add a `## Test Plan` section to the plan output format, after `## Verification Criteria`:

```markdown
## Test Plan

### Automated Tests
| # | Scenario | Type | Command | Expected Result |
|---|----------|------|---------|-----------------|
| T1 | User logout clears session | unit | `npm test -- --grep "logout"` | Test passes, session cookie removed |
| T2 | API returns 401 after logout | integration | `curl -X POST /api/logout && curl /api/me` | Second call returns 401 |

### Manual Tests
| # | Scenario | Steps | Expected Result |
|---|----------|-------|-----------------|
| M1 | Logout button visible in header | Open /dashboard, check top-right | Button labeled "Log Out" appears |

### Test Requirements
- [ ] Centurion must write unit tests for: [list specific functions/modules]
- [ ] Centurion must write integration tests for: [list specific flows]
```

**Rules for Tribunus**:
- Every plan step must have at least one test scenario (automated or manual)
- If a step genuinely can't be tested automatically, mark it as `manual` with clear steps
- Test commands must be concrete (actual CLI commands, not pseudocode)
- Test Requirements must specify which test files Centurion should create

### 2. Centurion (`agents/centurion.md`)

**EXECUTE phase** — add test writing as a deliverable:
- After implementing feature code, write test files specified in `## Test Plan > Test Requirements`
- Follow existing project test patterns (framework, file naming, directory structure)
- If no test framework exists, report as a blocker rather than silently skipping

**VERIFY phase** — run own tests before reporting:
- Run written tests, capture results

**Report format** — add new sections:
```
STATUS: COMPLETE | BLOCKED | PARTIAL
CHANGES: [file]: [what changed]
TESTS WRITTEN: [test file]: [what it covers]
TEST RESULTS: [pass/fail summary from running tests]
VERIFICATION: [what you checked]
BLOCKERS: [if any]
```

**Key rule**: If the plan's Test Requirements say "write tests for X" and Centurion doesn't write them, that's a blocker — report it, don't silently skip.

### 3. Vigil (`agents/vigil.md`)

**New phase order**:
```
1. Plan Compliance      (existing)
2. TEST PLAN EXECUTION  (NEW)
3. Code Quality         (existing)
4. Regressions          (existing)
```

**Test Plan Execution phase**:
1. Read the Test Plan from Tribunus's plan (provided by Legatus in prompt)
2. For each **Automated Test** scenario:
   - Run the command specified in the plan
   - Compare actual output to expected result
   - Record PASS/FAIL with actual output
3. For each **Manual Test** scenario:
   - Collect into a `MANUAL VERIFICATION RECOMMENDED` list
4. Check **Test Requirements**:
   - Verify Centurion actually wrote the test files specified
   - If test files are missing → FAILED
5. **Test Quality Review**:
   - Read test files Centurion wrote
   - Verify tests are meaningful (assert real behavior, not trivial `expect(true).toBe(true)`)
   - If test quality too low → FAILED with specific feedback
6. Run the **full test suite** (if project has one)

**Updated verdicts**:
- **VERIFIED**: All automated tests pass, test quality OK. May include `MANUAL VERIFICATION RECOMMENDED` section with manual test steps.
- **FAILED**: Any automated test fails, required test files missing, or test quality too low. Each failure includes `file:line`, `issue`, and `specific fix instruction`.

### 4. Legatus (orchestration)

**When spawning Vigil**: Include the full `## Test Plan` section from Tribunus's plan in the prompt (not just verification criteria).

**After Vigil returns**:
- **VERIFIED (no manual items)**: Done. Report success to user.
- **VERIFIED (with manual items)**: Present manual test steps to user as a recommendation, then mark complete:
  ```
  All automated tests pass. Manual verification recommended:
  - M1: Open /dashboard, verify logout button in top-right
  - M2: Click logout, verify redirect to /login
  ```
- **FAILED**: Existing fix cycle — spawn Centurion to fix, re-verify (max 3 cycles).

### 5. No Changes Needed

- Hooks (`hooks.json`, scripts)
- Settings (`settings.json`)
- Other agents (Praetor, Quaestor, Augur, Scriba)
- Skills (legion, plan, deep-work, verify, brainstorm — they invoke the agents whose prompts change)

## Files to Modify

| File | Change |
|------|--------|
| `agents/tribunus.md` | Add Test Plan section to output format, add rules for test scenarios |
| `agents/centurion.md` | Add test writing to EXECUTE phase, test results to report format |
| `agents/vigil.md` | Add Test Plan Execution phase, test quality review, update verdicts |
| `agents/legatus.md` | Pass test plan to Vigil, handle manual verification recommendations |

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Tribunus generates vague test commands | Medium | Tests can't be executed | Clear rules in prompt: "concrete CLI commands, not pseudocode" |
| Centurion skips test writing | Low | Vigil catches it as FAILED | Explicit rule: skipping = blocker |
| Vigil test quality review too strict | Low | False FAILED verdicts | Guidelines: meaningful assertions, not perfection |
| Projects with no test framework | Medium | Can't write tests | Centurion reports as blocker, Vigil adjusts expectations |
