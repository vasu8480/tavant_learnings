
---
## **1️⃣ GIT**


**1. `git merge` vs `git rebase`**
* **Rebase**

  * Re-applies commits from one branch onto another.
  * Creates a **linear history**.
  * No merge commits.
  * Cleaner for long-lived feature branches.

* **Merge**

  * Combines branches and adds a **merge commit**.
  * Preserves **full history** (parallel development lines).
  * Good for integrating big features where context matters.


  ### 📊 Comparison Table

  | Aspect       | Rebase                                              | Merge                                      |
  | ------------ | --------------------------------------------------- | ------------------------------------------ |
  | History      | Linear, clean                                       | Non-linear, keeps all commits              |
  | Commit ID    | Rewritten (new hashes)                              | Preserved (original commits kept)          |
  | Merge Commit | Not created                                         | Created                                    |
  | Use Case     | Clean project history, small feature branch         | Large team collaboration, preserve context |
  | Risk         | Can rewrite history (dangerous if branch is public) | Safe, no history rewriting                 |


  ### 🖥️ Commands & Examples

  **Rebase**

  ```bash
  # Move your branch commits on top of main
  git checkout feature
  git rebase main
  ```

  * Takes commits from `feature` and reapplies them on top of `main`.
  * Keeps history **linear**.

  **Merge**

  ```bash
  # Merge feature branch into main
  git checkout main
  git merge feature
  ```

  * Creates a **merge commit** that records the integration.
  * History shows branching + merging.

  ### ✅ Rule of Thumb

  * **Rebase** → Use for **local/feature branches** before pushing (clean history).
  * **Merge** → Use when **collaborating** and you want to keep all commit context.

---

**2. Fast-forward vs three-way merge**

  **Three-way Merge**
* Happens when the target branch (e.g. `main`) is **direct ancestor** of the feature branch.
* Git just **moves the branch pointer forward** to the new commit(s).
* **No merge commit** is created.
* Results in **linear history**.

  ✅ Example:

  ```bash
  git checkout main
  git merge feature
  ```

  If `main` has not moved since `feature` branched, Git will just move `main` pointer forward.

 **Three-way Merge**

* Happens when branches have **diverged** (both have new commits).
* Git uses the **two branch tips + their common ancestor** = 3 commits → "three-way".
* Creates a **new merge commit** to join histories.
* Preserves full context of parallel development.

✅ Example:

```bash
git checkout main
git merge feature
```

If `main` and `feature` both have commits since diverging, Git creates a merge commit.

  ## 📊 **Comparison Table**

  | Aspect       | Fast-forward Merge              | Three-way Merge                |
  | ------------ | ------------------------------- | ------------------------------ |
  | Condition    | No new commits on target branch | Both branches have new commits |
  | Merge Commit | Not created                     | Created                        |
  | History      | Linear, simple                  | Non-linear, shows branching    |
  | Use Case     | Short-lived feature branch      | Long-lived branches, team work |


  ## 🖥️ Visual (using `git log --graph`)

  **Fast-forward**

  ```
  A---B---C (main, feature)
  ```

  (main just moved forward → clean line)

  **Three-way**

  ```
        D---E (feature)
      /
  A---B---C (main)
          \
            F (merge commit)
  ```

  ---

  ## ✅ Rule of Thumb

  * **Fast-forward** → Good for small feature branches; keeps history clean.
  * **Three-way** → Use when you need to preserve parallel development context.

---

**3. What is a Merge Conflict?**

  * A **merge conflict** happens when **two branches change the same line(s)** in a file or when one branch deletes a file while the other modifies it.
  * Git cannot auto-decide which version to keep → developer must resolve manually.

  ---

  ## 📌 **Common Scenarios**

  1. Same line modified in both branches.
  2. One branch deletes a file, another edits it.
  3. File renamed in one branch, edited in another.

  ---

  ## 🖥️ **Example**

  ```bash
  # main branch
  echo "Hello from main" > app.txt
  git add app.txt && git commit -m "main change"

  # feature branch
  git checkout -b feature
  echo "Hello from feature" > app.txt
  git add app.txt && git commit -m "feature change"

  # Merge feature into main
  git checkout main
  git merge feature
  ```

  👉 Conflict occurs because both branches edited the same line in `app.txt`.

  ---

  ## ⚡ **Conflict Markers**

  Git marks conflicts in the file:

  ```txt
  <<<<<<< HEAD
  Hello from main
  =======
  Hello from feature
  >>>>>>> feature
  ```

  * `HEAD` = current branch (main)
  * `=======` = separator
  * After `>>>>>>>` = incoming branch (feature)

  ---

  ## 🛠️ **Steps to Resolve**

  1. Open conflicted file(s).
  2. Edit manually → choose one version OR combine both.

    ```txt
    Hello from main and feature
    ```
  3. Mark conflict as resolved:

    ```bash
    git add app.txt
    git commit   # finalizes merge
    ```

  ---

  ## 📊 **Key Commands**

  * Show conflicts:

    ```bash
    git status
    ```
  * Abort merge (if you want to retry):

    ```bash
    git merge --abort
    ```
  * Use merge tool (optional):

    ```bash
    git mergetool
    ```

  ---

  ## ✅ Rule of Thumb

  * Resolve conflicts early → smaller branches = fewer conflicts.
  * Use **`git pull --rebase`** to minimize merge commits/conflicts.
  * Always test after resolving conflicts (possible hidden bugs).

---

**4. What is `--no-ff`?**

* By default, Git performs a **fast-forward merge** if possible (just moves branch pointer, no merge commit).
* **`--no-ff`** forces Git to **always create a merge commit**, even when a fast-forward is possible.
* Keeps the **feature branch history explicit**.

---

  ## 🖥️ **Command Example**

  ```bash
  git checkout main
  git merge --no-ff feature
  ```

  * Creates a merge commit even if `main` hasn’t diverged.
  * Useful for **tracking feature completion** in history.

  ---

  ## 📊 **Why Use `--no-ff`?**

  * Preserves a **logical grouping** of commits from a feature branch.
  * Makes it **clear in history** which commits belong to which feature.
  * Useful in **team projects** and **release management**.

  ---

  ## 🖼️ **Visual Example**

  **Without `--no-ff` (fast-forward)**:

  ```
  A---B---C (main)
            \
            D---E (feature)
  # After merge → linear: A---B---C---D---E (main)
  ```

  **With `--no-ff`**:

  ```
  A---B---C--------M (main)
            \      /
            D---E (feature)
  # M = merge commit preserving feature branch
  ```

  ---

  ## ✅ **Rule of Thumb**

  * **Use fast-forward** → small, short-lived branches.
  * **Use `--no-ff`** → feature branches you want explicitly recorded in history.

---

**5. What is `git cherry-pick`?**

* `git cherry-pick` applies a **specific commit from one branch onto another branch**.
* Useful when you **want a single commit’s change** without merging the whole branch.


  ## 🖥️ **Command Example**

  ```bash
  # Switch to the target branch
  git checkout main

  # Apply a specific commit from feature branch
  git cherry-pick <commit-hash>
  ```

  * `<commit-hash>` = the commit you want to apply.
  * Creates a **new commit on the current branch** with the same changes.

  ---

  ## 📊 **Use Cases**

  * Bug fixes: Apply a fix from a feature branch to `main` without merging the full branch.
  * Selective updates: Pick only certain commits for release or hotfix.
  * Avoids unnecessary merge commits for unrelated changes.

  ---

  ## ⚡ **Notes**

  * Conflicts can happen if the same code changed in both branches → resolve like a normal merge conflict.
  * Multiple commits can be picked at once:

  ```bash
  git cherry-pick <commit1> <commit2> <commit3>
  ```

  * Or a range of commits:

  ```bash
  git cherry-pick <commitA>^..<commitB>
  ```

  ---

  ## ✅ **Rule of Thumb**

  * Use cherry-pick for **isolated commits** that need to go into another branch.
  * Avoid overusing it → can **create duplicate commits** and clutter history if done excessively.

---

**6. What is `git stash`?**

* Temporarily **saves uncommitted changes** (both staged and unstaged) so you can switch branches **without committing unfinished work**.
* Acts like a **clipboard for your working directory**.

---

  ## 🖥️ **Basic Commands**

  | Command                   | Action                                     |
  | ------------------------- | ------------------------------------------ |
  | `git stash`               | Save changes to stash (default)            |
  | `git stash save "msg"`    | Save changes with a message                |
  | `git stash list`          | Show all stashed changes                   |
  | `git stash pop`           | Apply the latest stash and remove it       |
  | `git stash apply <stash>` | Apply a specific stash without removing it |
  | `git stash drop <stash>`  | Delete a specific stash                    |
  | `git stash clear`         | Remove all stashes                         |

  ---

  ## 🖥️ **Example Workflow**

  ```bash
  # 1. Save current changes
  git stash

  # 2. Switch branch
  git checkout main

  # 3. Work on main branch, then return
  git checkout feature

  # 4. Apply previous stash
  git stash pop
  ```

  * After `pop`, your **working directory is restored** to the stashed state.

  ---

  ## 📊 **Use Cases**

  * Switching branches mid-work without committing incomplete changes.
  * Temporarily saving work before pulling/rebasing to avoid conflicts.
  * Trying multiple experiments without cluttering history.

  ---

  ## ⚡ **Notes**

  * Stashes are **stacked** → last stashed change is first applied (`LIFO`).
  * Can stash **only staged or only unstaged changes** using flags:

    ```bash
    git stash -k    # Keep staged changes, stash unstaged
    git stash -p    # Stash interactively (per hunk)
    ```
  * Stash can also include **untracked files**:

    ```bash
    git stash -u
    ```

  ---

  ✅ **Rule of Thumb**

  * Use `git stash` to **pause work safely** without committing.
  * Always **clean up stashes** to avoid clutter (`git stash list` + `git stash drop`).

---

**8. What is `git reset`?**

* Moves the **HEAD** (current branch pointer) to a specific commit.
* Can **modify staged and working directory changes**, depending on the mode.
* Powerful but **rewrites history**, so risky on public branches.

  ---

  ## 🖥️ **Modes of `git reset`**

  | Mode                  | Effect on Staged Changes | Effect on Working Directory | Notes                                     |
  | --------------------- | ------------------------ | --------------------------- | ----------------------------------------- |
  | `--soft`              | Keep                     | Keep                        | Moves HEAD only; useful to redo commits   |
  | `--mixed` *(default)* | Unstage                  | Keep                        | HEAD moves, staged changes are unstaged   |
  | `--hard`              | Remove                   | Remove                      | Discards everything; irreversible locally |

  ---

  ## 🖥️ **Basic Commands & Examples**

  ```bash
  # Move HEAD to previous commit, keep changes staged
  git reset --soft HEAD~1

  # Move HEAD, unstage changes but keep working dir intact
  git reset HEAD~1

  # Move HEAD, discard staged and working directory changes
  git reset --hard HEAD~1
  ```

  * `HEAD~1` → previous commit, `HEAD~2` → two commits back, etc.

  ---

  ## 📊 **Use Cases**

  * **Soft:** Amend the last commit without losing work.
  * **Mixed:** Unstage files accidentally added to commit.
  * **Hard:** Discard all local changes and reset branch to a known state.

  ---

  ## ⚡ **Notes**

  * Never `--hard reset` on **shared/public branches** → rewrites history.
  * Combine with **`git reflog`** to recover lost commits:

  ```bash
  git reflog
  git reset --hard <commit-hash>
  ```

  ---

  ✅ **Rule of Thumb**

  * **Soft:** tweak commits
  * **Mixed:** unstage changes
  * **Hard:** throw away everything locally

---

**9. Git Fetch vs Git Pull**

  | Feature     | `git fetch`                                    | `git pull`                                   |
  | ----------- | ---------------------------------------------- | -------------------------------------------- |
  | Action      | Downloads commits and updates remote refs      | Downloads + merges/rebases changes           |
  | Working Dir | No changes to local files                      | Updates local files automatically            |
  | Safety      | Safe; doesn’t modify local work                | Can overwrite local changes if not careful   |
  | Use Case    | Inspect remote changes before merging          | Update branch to latest remote state quickly |
  | Control     | High; you decide when/how to integrate changes | Low; automatically integrates changes        |

  ---

  ## 🖥️ **Examples**

  **`git fetch`**

  ```bash
  git fetch origin
  git log HEAD..origin/main   # see what’s new on remote
  git merge origin/main      # merge manually if ready
  ```

  **`git pull`**

  ```bash
  git pull origin main
  ```

  * Equivalent to `git fetch` + `git merge` (default).
  * Can also use rebase instead of merge:

  ```bash
  git pull --rebase origin main
  ```

  ---

  ## 📊 **Key Notes**

  * **Fetch** → safe for reviewing remote updates before merging.
  * **Pull** → fast way to update your branch, but risk overwriting local changes.
  * Use `git pull --rebase` to **keep history linear** and avoid unnecessary merge commits.

  ---

  ✅ **Rule of Thumb**

  * **Fetch** → when you want to review changes safely.
  * **Pull** → when you are ready to integrate remote changes immediately.

---

**10. Rebasing vs Merging**

  | Aspect    | Merge                                        | Rebase                                      |
  | --------- | -------------------------------------------- | ------------------------------------------- |
  | History   | Preserves all commits + creates merge commit | Linearizes commits; no merge commits        |
  | Commit ID | Original commits preserved                   | Commit hashes rewritten                     |
  | Conflicts | Resolved once at merge                       | Resolved per commit during rebase           |
  | Use Case  | Combining feature branches safely            | Keeping history clean before merging        |
  | Safety    | Safe for public/shared branches              | Risky on public branches (rewrites history) |

  ---

  ## 🖥️ **Examples**

  **Merge**

  ```bash
  git checkout main
  git merge feature
  ```

  * Creates a **merge commit** combining `feature` into `main`.

  **Rebase**

  ```bash
  git checkout feature
  git rebase main
  ```

  * Moves `feature` commits **on top of main** → linear history.
  * After rebase, fast-forward merge can be done without extra merge commit:

  ```bash
  git checkout main
  git merge feature
  ```

  ---

  ## 📊 **Visual Example**

  **Merge (non-linear)**

  ```
        D---E (feature)
      /
  A---B---C (main)
          \
            M (merge commit)
  ```

  **Rebase (linear)**

  ```
  A---B---C---D'---E' (feature rebased on main)
  ```

  ---

  ## ✅ **Rule of Thumb**

  * **Rebase** → local feature branches, keep history clean.
  * **Merge** → shared branches, preserve full context and commit history.

---

**11. What is `git rebase -i`?**

* `git rebase -i` allows you to **edit, reorder, squash, or drop commits** interactively.
* Useful for **cleaning up commit history** before merging to main branches.
* Only recommended for **local branches** (history rewriting).

  ---

  ## 🖥️ **Command Example**

  ```bash
  git checkout feature
  git rebase -i HEAD~3
  ```

  * Opens an editor showing the last 3 commits:

  ```
  pick 1a2b3c Commit message 1
  pick 2b3c4d Commit message 2
  pick 3c4d5e Commit message 3
  ```

  ### 🔹 **Key Actions**

  | Command  | Effect                              |
  | -------- | ----------------------------------- |
  | `pick`   | Keep the commit as-is               |
  | `reword` | Edit commit message only            |
  | `edit`   | Modify commit content               |
  | `squash` | Combine commit into previous one    |
  | `fixup`  | Like squash, but discard commit msg |
  | `drop`   | Remove the commit entirely          |

  ---

  ## 🛠️ **Example: Squash Commits**

  Change the second commit from `pick` → `squash`:

  ```
  pick 1a2b3c Initial commit
  squash 2b3c4d Fix typo
  pick 3c4d5e Add feature X
  ```

  * Git will combine the first two commits into one and allow you to edit the combined commit message.

  ---

  ## 📊 **Use Cases**

  * Clean up messy feature branch before merge.
  * Combine multiple small commits into a single logical commit.
  * Correct commit messages or remove irrelevant commits.

  ---

  ## ⚡ **Notes**

  * Only rebase **unshared branches** → avoid rewriting public history.
  * Can be combined with **`git push --force`** to update remote branch after rebase.

  ---

  ✅ **Rule of Thumb**

  * Use interactive rebase to **polish commit history** and make it **linear and meaningful** before merging.

---
**12. What is `git reflog`?**

* `git reflog` tracks **all movements of HEAD** (branch pointers), including commits, resets, rebases, and checkouts.
* Useful for **recovering lost commits** or finding previous branch states.
* Works **even if commits are “orphaned”** (not visible in normal log).

  ---

  ## 🖥️ **Command Example**

  ```bash
  # Show HEAD history
  git reflog
  ```

  Output example:

  ```
  1a2b3c HEAD@{0}: commit: Added feature X
  2b3c4d HEAD@{1}: checkout: moving from main to feature
  3c4d5e HEAD@{2}: commit: Fixed bug
  ```

  ---

  ## 🛠️ **Recover Lost Commits**

  ```bash
  # Reset branch to a previous state from reflog
  git reset --hard HEAD@{2}
  ```

  * HEAD@{2} = the state 2 moves ago.
  * Handy after accidental `git reset --hard` or rebase mistakes.

  ---

  ## 📊 **Use Cases**

  * Undo accidental resets or reverts.
  * Find lost commits after a force push.
  * Trace your own branch movement history.

  ---

  ## ⚡ **Notes**

  * Reflog is **local only** → not shared with remote.
  * Entries eventually expire (default 90 days for unreachable commits).

  ---

  ✅ **Rule of Thumb**

  * Always check `git reflog` when you feel like you **lost commits**—it’s a lifesaver for recovery.

---

**13. Key Difference**

* **`git revert`** → Safely undo changes by creating a **new commit** that reverses a previous commit.
* **`git reset`** → Moves branch pointer to a previous commit; can **rewrite history** and optionally discard changes.

  ---

  ## 📊 **Comparison Table**

  | Feature  | `git revert`                          | `git reset`                           |
  | -------- | ------------------------------------- | ------------------------------------- |
  | Action   | Creates a new commit to undo a change | Moves HEAD to a previous commit       |
  | History  | Preserves commit history              | Rewrites history (can remove commits) |
  | Safety   | Safe for public/shared branches       | Risky on shared branches              |
  | Use Case | Undo a commit in a **public branch**  | Clean up local commits before push    |
  | Modes    | N/A                                   | `--soft`, `--mixed`, `--hard`         |

  ---

  ## 🖥️ **Examples**

  **Git Revert**

  ```bash
  # Revert a single commit
  git revert <commit-hash>
  ```

  * Creates a **new commit** that undoes the changes of `<commit-hash>`.
  * Safe to push to remote.

  **Git Reset**

  ```bash
  # Soft reset: move HEAD, keep staged and working changes
  git reset --soft HEAD~1

  # Mixed reset (default): unstage changes, keep working directory
  git reset HEAD~1

  # Hard reset: discard everything and move HEAD
  git reset --hard HEAD~1
  ```

  * **Risky if branch is shared** (rewrites history).

  ---

  ## ✅ **Rule of Thumb**

  * **Use `revert`** → Public branch, keep history intact.
  * **Use `reset`** → Local cleanup, before pushing.

---
**14. What is a Git Tag?**

* A **tag** marks a specific commit in Git as important.
* Commonly used for **releases or versioning**.
* Tags are **immutable pointers** → unlike branches, they don’t move.

  ---

  ## 🖥️ **Types of Tags**

  | Tag Type    | Description                                           |
  | ----------- | ----------------------------------------------------- |
  | Lightweight | Simple pointer to a commit                            |
  | Annotated   | Full object with message, author, date, GPG signature |

  ---

  ## 🖥️ **Common Commands**

  ```bash
  # Create a lightweight tag
  git tag v1.0

  # Create an annotated tag
  git tag -a v1.0 -m "Release version 1.0"

  # List all tags
  git tag

  # Push a single tag to remote
  git push origin v1.0

  # Push all tags to remote
  git push origin --tags
  ```

  ---

  ## 📊 **Use Cases**

  * Mark a commit as a **release version**.
  * Reference a **stable point in history**.
  * Integration with **CI/CD pipelines** to trigger builds based on tags.

  ---

  ## ⚡ **Notes**

  * **Tags don’t change** once created → safe for marking releases.
  * Can delete local or remote tags if needed:

  ```bash
  git tag -d v1.0        # delete local tag
  git push origin :refs/tags/v1.0  # delete remote tag
  ```

  ---

  ✅ **Rule of Thumb**

  * Use **lightweight tags** for temporary markers or local references.
  * Use **annotated tags** for **official releases** and CI/CD pipelines.

---

**15. Git Tags: Lightweight vs Annotated**

  | Feature         | Lightweight Tag            | Annotated Tag                                               |
  | --------------- | -------------------------- | ----------------------------------------------------------- |
  | Type            | Simple pointer to a commit | Full Git object with metadata                               |
  | Metadata        | None                       | Includes tagger name, date, message, optional GPG signature |
  | Storage         | Just a ref                 | Stored as full object in Git database                       |
  | Use Case        | Temporary/local markers    | Official releases, CI/CD triggers                           |
  | Visibility      | Local only unless pushed   | Can be pushed and verified                                  |
  | Example Command | `git tag v1.0`             | `git tag -a v1.0 -m "Release v1.0"`                         |

  ---

  ## 🖥️ **Key Points**

  * **Lightweight**: acts like a branch that doesn’t move; quick and simple.
  * **Annotated**: preferred for **public releases**; contains **authorship and message**.
  * Both can be pushed to remote using `git push origin <tag>` or all tags using `git push origin --tags`.

  ---

  ## ✅ **Rule of Thumb**

  * **Use lightweight tags** → for temporary or local bookmarks.
  * **Use annotated tags** → for official versions/releases and traceability.

---
**17. Version Tags vs Branch Names**

  | Aspect       | Version Tag                            | Branch Name                                |
  | ------------ | -------------------------------------- | ------------------------------------------ |
  | Pointer Type | Fixed reference to a specific commit   | Moving pointer that advances with commits  |
  | Mutability   | Immutable (doesn’t move)               | Mutable (changes as new commits are added) |
  | Use Case     | Marking **releases or stable points**  | Ongoing development of features or fixes   |
  | Example      | `v1.0`, `v2.1`                         | `main`, `feature/login`, `bugfix/xyz`      |
  | Visibility   | Can be pushed to remote for reference  | Shared among developers for collaboration  |
  | Integration  | Triggers CI/CD pipelines or deployment | Used to develop, merge, or test features   |

  ---

  ### 🖥️ **Key Notes**

  * **Tags** = snapshot of a commit; ideal for **release versions**.
  * **Branches** = pointer to latest commit; ideal for **continuous development**.
  * Tags can be **lightweight or annotated**, branches can be **short-lived (feature)** or **long-lived (main, dev)**.

  ---

  ✅ **Rule of Thumb**

  * Use **tags** to mark **release points**.
  * Use **branches** for **day-to-day development** and collaborative work.

