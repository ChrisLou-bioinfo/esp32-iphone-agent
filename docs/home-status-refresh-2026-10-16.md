# Home status refresh

Source: `c12039631ee46c22c83da36fa0c4af0a43d6daa3`. The source checkout had only untracked `ios/fastlane/`, which was left untouched. Implementation used the isolated `codex/home-refresh` worktree.

Pulling down the Agent list or releasing a tap/drag on its character refreshes readiness. Existing character expressions remain available. Requests are coalesced while refreshing and for two seconds afterward.

Refresh reads fresh board status and signal strength, reconnecting to the remembered board when needed. It preserves pairing, shows progress and actionable failures, and clears stale failure text when fresh status arrives. Model readiness remains the existing local validation state; this gesture does not run a model inference test.

Validation: signed iOS device build succeeded; whitespace checks passed. Installation was attempted, but CoreDevice reported the user's iPhone unavailable. Physical gesture behavior and installation remain unverified for this change.
