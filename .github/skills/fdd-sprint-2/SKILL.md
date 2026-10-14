---
name: fdd-sprint-2
description: Execute the next minimal implementation step under Flow Driven Development after verifying the spec gate, Docker-first validation path, and .env-based DB source-of-truth.
disable-model-invocation: true
argument-hint: "Describe the feature path and the concrete task to execute"
---
Execute the user's request under Flow Driven Development.

Before doing any work, apply these rules:

1. Treat [document/flow.llm.md](../../document/flow.llm.md) as the primary low-token execution contract for Flow Driven Development.
2. Treat [document/flow.md](../../document/flow.md) as the full engineer-oriented reference when more detail or rationale is needed.
3. Treat [copilot-instructions.md](../copilot-instructions.md) as the workspace-level always-on ruleset.
4. Treat [document/spec/.current-spec.md](../../document/spec/.current-spec.md) as the single source of truth for the current target spec.
5. If [document/spec/.current-spec.md](../../document/spec/.current-spec.md) is missing, unreadable, or does not point to a valid spec folder, stop immediately and tell the user to run the appropriate `FDD Focus` command first.
6. If the task involves F3CMS architecture, terminology, process, or feature continuation, treat the files under [document](../../document) as the primary source of truth instead of making generic framework assumptions.
7. After reading [document/spec/.current-spec.md](../../document/spec/.current-spec.md), read the resolved target spec's `history.md` first, then use its `plan.md` and `check.md` to determine the next step. Do not restart from `idea.md` unless the documents show the earlier stages are incomplete.
8. If the task involves validation, smoke scripts, PHP script execution, workflow verification, or post-change runtime checks, prefer the project's existing Docker environment before local PHP.
9. If the task involves database verification, use the database connection credentials defined in `.env` as the default source of truth. Do not guess, hardcode, or substitute credentials when `.env` already provides the validation target.

Required execution order:

1. Read [document/spec/.current-spec.md](../../document/spec/.current-spec.md) first.
2. If the pointer file is missing or invalid, stop immediately instead of guessing a spec.
3. State which files you need to read from the resolved target spec and which validation environment you will use.
4. Identify the current flow stage from the resolved `history.md` before proposing or making changes.
5. If you detect drift between the resolved `history.md`, `plan.md`, `check.md`, and current code, point it out before changing direction.
6. Keep the work to the smallest valid next step unless the user explicitly asks for a broader scope.
7. When validation is needed, prefer existing Docker compose services, container paths, smoke scripts, and existing verification routes.
8. After finishing, state whether the resolved target spec's `history.md`, `plan.md`, or `check.md` should be updated.

Stage gate decision rule:

- This command must not start implementation unless all of the following gate checks pass:
  1. [document/spec/.current-spec.md](../../document/spec/.current-spec.md) resolves to a valid spec folder.
  2. The resolved spec includes `history.md`, `plan.md`, and `check.md`.
  3. The current stage is valid and the docs are internally consistent with one another.
  4. There is no blocking drift between the spec documents and the current codebase that prevents the next implementation step.
  5. The next step is a minimal, executable action that matches the plan and can be validated.
- If any gate check fails, stop in documentation/analysis mode and update the relevant spec file before code changes.
- Only when the gate passes may the agent begin the smallest implementation step, followed by validation.
- If the gate passes but work still requires verification, prefer Docker-first validation and `.env`-based database verification.

Response expectations:

- Start by confirming which spec folder was resolved from [document/spec/.current-spec.md](../../document/spec/.current-spec.md).
- Then summarize the current stage and the concrete next step.
- If relevant, mention the Docker-based validation path you will use.
- If relevant, mention that database verification is based on `.env`.
- If the gate has not passed, explicitly say so and stop in doc/spec mode; do not begin generic implementation.
- If the gate has passed, begin the smallest valid implementation step and report the result.

User task:

{{input}}
