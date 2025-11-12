# Git

## **Q: What is Git and why is it used?**

### 🧠 **Overview**

* **Git** is a **distributed version control system (DVCS)** used to track code changes across time.
* It lets multiple developers **collaborate**, **branch**, **merge**, and **revert** code safely.
* Every developer has a **full copy of the repository**, ensuring redundancy and offline access.

---

### ⚙️ **Why Git is Used**

| **Purpose**                   | **Explanation**                                             |
| ----------------------------- | ----------------------------------------------------------- |
| 🧾 **Version Tracking**       | Keeps history of every code change (commits).               |
| 👥 **Collaboration**          | Multiple developers can work simultaneously using branches. |
| 🔄 **Rollback Capability**    | Easily revert to stable versions if something breaks.       |
| 🌿 **Branching & Merging**    | Experiment on isolated branches; merge when ready.          |
| ⚙️ **Integration with CI/CD** | Triggers builds/deployments on commits or PR merges.        |
| ☁️ **Distributed Model**      | Every clone is a backup — no single point of failure.       |

---

### ⚙️ **Example Workflow**

```bash
git clone https://github.com/user/project.git
cd project
git checkout -b feature/login
# make changes
git add .
git commit -m "Add login feature"
git push origin feature/login
```

✅ Team members can review and merge via pull request → keeps code versioned and consistent.

---

### 🧠 **In simple terms:**

> Git is the **backbone of modern DevOps** — it tracks code, enables collaboration, and powers CI/CD workflows across distributed teams.

---
---

## **Q: What’s the difference between Git and GitHub?**

### 🧠 **Overview**

While **Git** is a **tool**, **GitHub** is a **platform**.
Git handles **version control locally**, and GitHub provides a **remote service** to host and manage Git repositories online.

---

### ⚙️ **Comparison Table**

| **Feature**                  | **Git** 🧩                                          | **GitHub** ☁️                                                   |
| ---------------------------- | --------------------------------------------------- | --------------------------------------------------------------- |
| **Type**                     | Distributed version control system (CLI tool).      | Cloud-based hosting platform for Git repositories.              |
| **Where it runs**            | Locally on your machine (CLI).                      | Remotely on GitHub servers (via web UI / API).                  |
| **Purpose**                  | Track code changes, branching, merging, versioning. | Store repositories, enable collaboration (PRs, reviews, CI/CD). |
| **Access**                   | Offline; works without internet.                    | Online; requires internet for push/pull operations.             |
| **Collaboration**            | Manual (via push/pull).                             | Built-in PRs, issues, discussions, workflows.                   |
| **Security**                 | Controlled by local user.                           | Adds user management, orgs, branch protection, permissions.     |
| **CI/CD Support**            | None built-in.                                      | Provides **GitHub Actions** for CI/CD.                          |
| **Examples of alternatives** | Git only.                                           | GitLab, Bitbucket, AWS CodeCommit (all Git-based platforms).    |

---

### ⚙️ **Example Relationship**

You **use Git commands** to interact with repositories hosted on **GitHub**:

```bash
# Local Git commands
git init
git add .
git commit -m "initial commit"

# Connect to GitHub (remote)
git remote add origin https://github.com/user/repo.git
git push -u origin main
```

✅ Git does the versioning; GitHub hosts and syncs the repo for your team.

---

### 🧠 **In short:**

> **Git** = Version control **tool** (local).
> **GitHub** = Cloud **service** built on top of Git for collaboration, storage, and CI/CD integration.
---
---

## **Q: How do you initialize a Git repository?**

### 🧠 **Overview**

You can initialize a new Git repository in two ways:
1️⃣ **Create a new repo locally** (`git init`)
2️⃣ **Clone an existing remote repo** (`git clone`)

---

### ⚙️ **1️⃣ Create a New Local Repository**

```bash
# Step 1: Go to your project directory
cd /path/to/project

# Step 2: Initialize a new Git repository
git init
```

✅ This creates a hidden `.git/` folder — it stores all commit history and configuration.

```bash
Initialized empty Git repository in /path/to/project/.git/
```

---

### ⚙️ **2️⃣ Add and Commit Files**

```bash
# Add all project files to Git
git add .

# Commit your first snapshot
git commit -m "Initial commit"
```

✅ Now Git starts tracking your files.

---

### ⚙️ **3️⃣ Connect to a Remote Repository (e.g., GitHub)**

```bash
git remote add origin https://github.com/user/myrepo.git
git branch -M main
git push -u origin main
```

✅ This links your local repo to GitHub and pushes your first commit.

---

### ⚙️ **4️⃣ Clone Existing Repository (Alternate Way)**

```bash
git clone https://github.com/user/myrepo.git
```

✅ This automatically initializes a `.git` directory and sets `origin` remote.

---

### 🧠 **In short:**

> Use `git init` to start version control in a folder,
> then `git add` → `git commit` → `git push` to track and sync changes.
---
---

## **Q: What are the main Git areas?**

### 🧠 **Overview**

Git uses **three key areas (or states)** to manage your code:
1️⃣ **Working Directory**
2️⃣ **Staging Area (Index)**
3️⃣ **Repository (Local + Remote)**

Each area represents a stage in Git’s **change tracking lifecycle** — from writing code to committing and pushing.

---

### ⚙️ **1️⃣ Working Directory (Workspace)**

* This is your **project folder** on disk.
* You modify, create, or delete files here.
* Changes here are **not tracked** by Git until staged.

📘 **Example:**

```bash
echo "hello" > app.txt
git status
```

Output:

```
Untracked files:
  app.txt
```

---

### ⚙️ **2️⃣ Staging Area (Index)**

* Temporary storage for files **prepared for commit**.
* When you run `git add`, files move from the **working directory → staging area**.
* Allows you to review changes before committing.

📘 **Example:**

```bash
git add app.txt
git status
```

Output:

```
Changes to be committed:
  new file: app.txt
```

---

### ⚙️ **3️⃣ Repository**

#### 🏠 **Local Repository**

* Where committed changes are permanently stored on your machine.
* Created inside `.git/`.
* Each commit = snapshot of project state.

📘 **Example:**

```bash
git commit -m "Add app.txt"
```

✅ File now moves from **staging → local repo**.

#### ☁️ **Remote Repository**

* Hosted on platforms like **GitHub**, **GitLab**, or **Bitbucket**.
* Used for collaboration and backup.
* You push/pull changes between local and remote.

📘 **Example:**

```bash
git push origin main
git pull origin main
```

---

### ⚙️ **4️⃣ Summary Flow Diagram**

```
+----------------+       git add        +----------------+       git commit        +----------------+
| Working Dir    |  ------------------> | Staging Area   |  ------------------>  | Local Repo     |
| (Edit files)   |                     | (Index)        |                      | (.git)         |
+----------------+                     +----------------+                      +----------------+
                                                                                     |
                                                                                     | git push
                                                                                     v
                                                                                +----------------+
                                                                                | Remote Repo    |
                                                                                | (GitHub, etc.) |
                                                                                +----------------+
```

---

### 🧠 **In short:**

> Git has **three main areas** —
> **Working Directory** (where you edit),
> **Staging Area** (where you prepare commits), and
> **Repository** (where history is stored, local & remote).
---
---

## **Q: What are the Common Git Workflow Commands?**

### 🧠 **Overview**

A typical Git workflow moves code through these stages:
➡️ **Working Directory → Staging Area → Local Repo → Remote Repo**
Below are the **most common Git commands** used at each step — with practical examples.

---

### ⚙️ **1️⃣ Initialize or Clone a Repository**

| **Task**               | **Command**            | **Description**                                |
| ---------------------- | ---------------------- | ---------------------------------------------- |
| Initialize a new repo  | `git init`             | Start version control in a directory.          |
| Clone an existing repo | `git clone <repo_url>` | Copy repo (with history) from remote to local. |

📘 Example:

```bash
git clone https://github.com/user/project.git
```

---

### ⚙️ **2️⃣ Check Repository Status**

| **Command**         | **Purpose**                                   |
| ------------------- | --------------------------------------------- |
| `git status`        | Shows modified, staged, and untracked files.  |
| `git diff`          | Shows line-by-line changes (not yet staged).  |
| `git diff --staged` | Shows staged (added) changes ready to commit. |

📘 Example:

```bash
git status
git diff
```

---

### ⚙️ **3️⃣ Stage and Commit Changes**

| **Command**               | **Purpose**                          |
| ------------------------- | ------------------------------------ |
| `git add <file>`          | Stage specific file.                 |
| `git add .`               | Stage all changes in directory.      |
| `git reset <file>`        | Unstage file from staging area.      |
| `git commit -m "message"` | Commit staged changes to local repo. |

📘 Example:

```bash
git add .
git commit -m "Fix login validation issue"
```

---

### ⚙️ **4️⃣ Branching & Switching**

| **Command**              | **Purpose**                      |
| ------------------------ | -------------------------------- |
| `git branch`             | List all branches.               |
| `git branch <name>`      | Create new branch.               |
| `git checkout <name>`    | Switch to branch.                |
| `git checkout -b <name>` | Create and switch to new branch. |
| `git branch -d <name>`   | Delete branch.                   |

📘 Example:

```bash
git checkout -b feature/api
```

---

### ⚙️ **5️⃣ Merging & Rebasing**

| **Command**                 | **Purpose**                                                 |
| --------------------------- | ----------------------------------------------------------- |
| `git merge <branch>`        | Merge branch into current branch.                           |
| `git rebase <branch>`       | Replay commits from one branch on another (linear history). |
| `git log --oneline --graph` | Visualize merge history.                                    |

📘 Example:

```bash
git checkout main
git merge feature/api
```

---

### ⚙️ **6️⃣ Working with Remotes**

| **Command**                   | **Purpose**                                |
| ----------------------------- | ------------------------------------------ |
| `git remote -v`               | View connected remote URLs.                |
| `git remote add origin <url>` | Add remote repo.                           |
| `git fetch`                   | Get latest commits from remote (no merge). |
| `git pull`                    | Fetch + merge changes from remote.         |
| `git push`                    | Push local commits to remote.              |

📘 Example:

```bash
git push origin feature/api
git pull origin main
```

---

### ⚙️ **7️⃣ View History & Changes**

| **Command**                            | **Purpose**                           |
| -------------------------------------- | ------------------------------------- |
| `git log --oneline --graph --decorate` | View commit history.                  |
| `git show <commit_id>`                 | View details of a specific commit.    |
| `git blame <file>`                     | Show who changed each line in a file. |

📘 Example:

```bash
git log --oneline --graph
```

---

### ⚙️ **8️⃣ Undo or Revert Changes**

| **Command**               | **Purpose**                                |
| ------------------------- | ------------------------------------------ |
| `git checkout -- <file>`  | Discard local changes (unstaged).          |
| `git reset --soft HEAD~1` | Undo last commit, keep changes staged.     |
| `git reset --hard HEAD~1` | Undo last commit, discard changes.         |
| `git revert <commit_id>`  | Create new commit to undo specific commit. |

📘 Example:

```bash
git revert 5f3a2b7
```

---

### ⚙️ **9️⃣ Temporary Save (Stashing)**

| **Command**       | **Purpose**                        |
| ----------------- | ---------------------------------- |
| `git stash`       | Save uncommitted work temporarily. |
| `git stash list`  | Show saved stashes.                |
| `git stash apply` | Reapply last stash.                |

📘 Example:

```bash
git stash
git pull origin main
git stash pop
```

---

### ⚙️ **🔟 Tagging (for Releases)**

| **Command**            | **Purpose**             |
| ---------------------- | ----------------------- |
| `git tag v1.0`         | Create lightweight tag. |
| `git push origin v1.0` | Push tag to remote.     |
| `git tag -d v1.0`      | Delete local tag.       |

📘 Example:

```bash
git tag v2.0 && git push origin v2.0
```

---

### ⚙️ **Bonus: Cleaning and Maintenance**

| **Command**     | **Purpose**                               |
| --------------- | ----------------------------------------- |
| `git clean -fd` | Remove untracked files/folders.           |
| `git gc`        | Optimize repo and clean unused data.      |
| `git reflog`    | Show HEAD history (recover lost commits). |

---

### 🧠 **Typical DevOps Git Workflow**

```bash
git clone https://github.com/org/app.git
git checkout -b feature/auth
# develop features
git add .
git commit -m "Add JWT authentication"
git push origin feature/auth
# Create a Pull Request → Merge → Deploy via CI/CD
```

---

### ✅ **In short:**

> Common Git workflow =
> **`clone → branch → add → commit → push → merge → pull`**
> Everything revolves around tracking, collaborating, and deploying stable code versions efficiently.

---
---

## **Q: How do you check commit history in Git?**

### 🧠 **Overview**

Git records every change as a **commit**, and you can view the full or filtered history using `git log` and related commands.
These help you **track who changed what**, **when**, and **why** — essential for debugging, auditing, and CI/CD traceability.

---

### ⚙️ **1️⃣ Basic Command**

```bash
git log
```

✅ Shows commit history from newest to oldest.

**Example Output:**

```
commit a1b2c3d4e5f6
Author: Vasu <vasu@example.com>
Date:   Mon Nov 10 14:20 2025 +0530

    Fix issue with login token expiry
```

---

### ⚙️ **2️⃣ Condensed View (One Line per Commit)**

```bash
git log --oneline
```

✅ Clean summary of commits with short hashes:

```
a1b2c3d fix: update login API timeout
c3d4e5f feat: add user roles
d4e5f6g init: first commit
```

---

### ⚙️ **3️⃣ Visual Graph of Branches**

```bash
git log --oneline --graph --decorate --all
```

✅ Visualizes branch merges and commit flow:

```
* a1b2c3d (HEAD -> main, origin/main) fix: update login API
| * d4e5f6g (feature/auth) add JWT token logic
|/
* c3d4e5f init project
```

---

### ⚙️ **4️⃣ Show Commits by a Specific Author**

```bash
git log --author="vasu"
```

---

### ⚙️ **5️⃣ Limit Number of Commits**

```bash
git log -5
```

✅ Displays only the last 5 commits.

---

### ⚙️ **6️⃣ Show Commit History for a Specific File**

```bash
git log -- <file>
```

✅ Example:

```bash
git log -- app/main.py
```

Shows only commits that modified `main.py`.

---

### ⚙️ **7️⃣ Show Changes Inside Commits**

```bash
git log -p
```

✅ Displays the diff (code changes) for each commit.

---

### ⚙️ **8️⃣ Custom Output Format**

```bash
git log --pretty=format:"%h - %an, %ar : %s"
```

✅ Example Output:

```
a1b2c3d - Vasu, 2 hours ago : fix: login API timeout
```

---

### ⚙️ **9️⃣ Check Commit History Between Branches**

```bash
git log main..feature/auth --oneline
```

✅ Shows commits present in `feature/auth` but not in `main`.

---

### ⚙️ **🔟 GUI Alternatives**

* **`gitk`** → Built-in graphical commit viewer:

  ```bash
  gitk
  ```
* **`git log --stat`** → Shows files changed + lines added/deleted.

---

### 🧠 **Bonus: Combine for Quick DevOps View**

```bash
git log --oneline --decorate --graph --stat -5
```

✅ Displays latest 5 commits with file stats and branch structure.

---

### ✅ **In short:**

> Use `git log` (detailed), `git log --oneline` (summary), and
> `git log --graph` (visual) to explore commit history.
> For file-specific or author-specific history, add `-- <file>` or `--author=<name>`.
---
---

## **Q: What’s `.gitignore` used for?**

### 🧠 **Overview**

The `.gitignore` file tells Git **which files or folders to ignore** —
i.e., not to track, commit, or push to the repository.

It’s essential for keeping your repo **clean**, **secure**, and **lightweight**.

---

### ⚙️ **Purpose**

| **Reason**                            | **Examples**                                        |
| ------------------------------------- | --------------------------------------------------- |
| 🧾 **Avoid tracking temporary files** | Logs, caches, temp builds (`*.log`, `/tmp/`)        |
| 🔐 **Protect sensitive info**         | Secrets, `.env`, config files with credentials      |
| ⚙️ **Exclude build artifacts**        | `node_modules/`, `target/`, `dist/`, `__pycache__/` |
| 🚀 **Reduce repo size**               | Prevent large files like binaries or data dumps     |

---

### ⚙️ **Example `.gitignore` File**

```bash
# Logs
*.log
npm-debug.log*

# Dependency folders
node_modules/
venv/
__pycache__/

# Build outputs
dist/
target/
build/

# Environment / secrets
.env
*.pem
*.key

# IDE / OS files
.vscode/
.idea/
.DS_Store
Thumbs.db
```

---

### ⚙️ **Usage**

1️⃣ Create `.gitignore` in your project root.
2️⃣ Add patterns of files/folders you don’t want Git to track.
3️⃣ Commit the `.gitignore` file itself:

```bash
git add .gitignore
git commit -m "Add .gitignore"
```

---

### ⚙️ **If Files Already Tracked**

If you added a file before adding it to `.gitignore`, Git still tracks it.
Remove from tracking:

```bash
git rm --cached <file>
```

Then commit the removal.

---

### ⚙️ **Pattern Rules**

| **Pattern**    | **Meaning**                                    |
| -------------- | ---------------------------------------------- |
| `*.log`        | Ignore all `.log` files.                       |
| `folder/`      | Ignore entire folder.                          |
| `!config.yaml` | **Don’t ignore** this file (exception).        |
| `**/temp/*`    | Ignore all `temp` folders in any subdirectory. |

---

### 🧠 **In short:**

> `.gitignore` tells Git **what NOT to track** —
> prevents unnecessary, sensitive, or system files from being committed,
> keeping your repository **secure, efficient, and clean**.

---
---

## **Q: How do you create and switch branches in Git?**

### 🧠 **Overview**

Git branches let you **work on features or fixes independently** — without affecting the main codebase.
You can **create**, **switch**, and **merge** branches using a few simple commands.

---

### ⚙️ **1️⃣ Create a New Branch**

```bash
git branch <branch-name>
```

📘 Example:

```bash
git branch feature/login
```

✅ Creates a new branch called `feature/login` based on your current branch (usually `main`).

---

### ⚙️ **2️⃣ Switch to a Branch**

```bash
git checkout <branch-name>
```

📘 Example:

```bash
git checkout feature/login
```

✅ Moves you into the `feature/login` branch (your working directory updates to that branch’s state).

---

### ⚙️ **3️⃣ Create & Switch in One Command**

```bash
git checkout -b <branch-name>
```

📘 Example:

```bash
git checkout -b feature/auth-api
```

✅ Creates **and** switches to the new branch immediately — the most common method.

---

### ⚙️ **4️⃣ List Branches**

```bash
git branch
```

Output:

```
  main
* feature/auth-api
```

✅ `*` marks the current active branch.

---

### ⚙️ **5️⃣ Switch Back to Main**

```bash
git checkout main
```

✅ Returns to the main branch (or `master` if repo uses that name).

---

### ⚙️ **6️⃣ Delete a Branch**

```bash
git branch -d <branch-name>     # Safe delete (only if merged)
git branch -D <branch-name>     # Force delete (unmerged)
```

📘 Example:

```bash
git branch -d feature/login
```

---

### ⚙️ **7️⃣ Create Remote Branch (Push to Remote)**

```bash
git push -u origin <branch-name>
```

📘 Example:

```bash
git push -u origin feature/login
```

✅ Pushes your new branch to GitHub/GitLab and sets upstream tracking.

---

### ⚙️ **Quick Summary Table**

| **Action**      | **Command**                      | **Notes**                  |
| --------------- | -------------------------------- | -------------------------- |
| Create branch   | `git branch feature/api`         | Creates branch locally.    |
| Switch branch   | `git checkout feature/api`       | Switch to existing branch. |
| Create & switch | `git checkout -b feature/api`    | Most used shortcut.        |
| List branches   | `git branch`                     | Shows all local branches.  |
| Push branch     | `git push -u origin feature/api` | Sync to remote.            |
| Delete branch   | `git branch -d feature/api`      | Safe delete after merge.   |

---

### 🧠 **In short:**

> Use `git checkout -b <branch>` to create and switch in one go.
> Branching allows **parallel development** and **safe experimentation** before merging back to main.

---
---

## **Q: How do you merge branches in Git?**

### 🧠 **Overview**

Merging in Git combines changes from one branch into another — usually from a **feature branch → main branch**.
It’s a key part of collaborative workflows like Git Flow or GitHub Flow.

---

### ⚙️ **1️⃣ Switch to the Target Branch**

You must first be on the branch **you want to merge *into*** (often `main` or `develop`).

```bash
git checkout main
```

---

### ⚙️ **2️⃣ Merge the Source Branch**

Run the merge command specifying the branch with the new changes:

```bash
git merge feature/login
```

✅ This applies commits from `feature/login` into `main`.

---

### ⚙️ **3️⃣ Resolve Conflicts (if any)**

If both branches changed the same lines, Git flags a **merge conflict**:

```
<<<<<<< HEAD
current code (main)
=======
incoming code (feature/login)
>>>>>>> feature/login
```

🛠 Fix the file manually, then run:

```bash
git add <file>
git commit
```

---

### ⚙️ **4️⃣ Verify the Merge**

```bash
git log --oneline --graph --decorate
```

✅ Shows a visual merge graph.

---

### ⚙️ **5️⃣ Delete the Feature Branch (Optional)**

After merging successfully:

```bash
git branch -d feature/login      # Safe delete (merged)
git branch -D feature/login      # Force delete (not merged)
```

---

### ⚙️ **6️⃣ Push Merged Changes to Remote**

```bash
git push origin main
```

---

### ⚙️ **Example Workflow**

```bash
git checkout main
git pull origin main
git merge feature/api
# resolve conflicts if any
git push origin main
git branch -d feature/api
```

---

### ⚙️ **Optional: Fast-Forward vs. No-FF Merge**

| **Type**            | **Command**                     | **Behavior**                                    |
| ------------------- | ------------------------------- | ----------------------------------------------- |
| **Fast-forward**    | `git merge feature/api`         | Moves branch pointer forward (no merge commit). |
| **No fast-forward** | `git merge --no-ff feature/api` | Always creates a merge commit (clear history).  |

📘 Example:

```bash
git merge --no-ff feature/api -m "Merge feature/api into main"
```

---

### 🧠 **In short:**

> To merge:
> `git checkout main && git merge feature/xyz`
> Then resolve conflicts → commit → push.
> Use `--no-ff` to preserve feature branch history for better traceability in CI/CD.

---
---

## **Q: How do you view differences between commits or branches in Git?**

### 🧠 **Overview**

Git provides the `git diff` command to compare **changes between commits, branches, or your working directory**.
It’s one of the most used commands for debugging, code review, and validation before merging.

---

### ⚙️ **1️⃣ Compare Working Directory vs. Last Commit**

```bash
git diff
```

✅ Shows unstaged changes (modified files not yet added).

📘 Example Output:

```diff
- console.log("Old code");
+ console.log("Updated code");
```

---

### ⚙️ **2️⃣ Compare Staged Changes vs. Last Commit**

```bash
git diff --staged
```

✅ Displays what’s been added via `git add` but not yet committed.

---

### ⚙️ **3️⃣ Compare Two Commits**

```bash
git diff <commit1> <commit2>
```

📘 Example:

```bash
git diff a1b2c3d d4e5f6g
```

✅ Shows what changed between those two commits.

Get commit IDs via:

```bash
git log --oneline
```

---

### ⚙️ **4️⃣ Compare Two Branches**

```bash
git diff main feature/api
```

✅ Shows changes in `feature/api` relative to `main`.

> 💡 Useful before merging to preview differences.

---

### ⚙️ **5️⃣ Compare File Differences**

```bash
git diff <commit1> <commit2> -- <file>
```

📘 Example:

```bash
git diff HEAD~2 HEAD -- app/main.py
```

✅ Shows changes to `main.py` over the last two commits.

---

### ⚙️ **6️⃣ Compare Local Branch vs. Remote**

```bash
git fetch origin
git diff main origin/main
```

✅ See what’s different between your local branch and remote repo.

---

### ⚙️ **7️⃣ See Which Files Changed Between Commits**

```bash
git diff --name-only <commit1> <commit2>
```

✅ Lists only file names, not content.

---

### ⚙️ **8️⃣ Visual (Graphical) Comparison**

For a clearer visual diff:

```bash
git difftool
```

Or use GUI tools like **GitKraken**, **SourceTree**, or **VS Code**’s built-in diff viewer.

---

### ⚙️ **9️⃣ Compare Commit with Its Parent**

```bash
git diff HEAD~1 HEAD
```

✅ Shows what changed in the most recent commit.

---

### ⚙️ **10️⃣ Summary Comparison Table**

| **Comparison**             | **Command**                    | **Use Case**                  |
| -------------------------- | ------------------------------ | ----------------------------- |
| Working dir ↔️ last commit | `git diff`                     | View unstaged changes         |
| Staged ↔️ last commit      | `git diff --staged`            | View staged changes           |
| Two commits                | `git diff <id1> <id2>`         | Compare any history points    |
| Two branches               | `git diff main feature/api`    | Compare branches before merge |
| File-level                 | `git diff <id1> <id2> -- file` | Diff a single file            |
| Local ↔️ remote            | `git diff main origin/main`    | Check unsynced changes        |

---

### 🧠 **In short:**

> Use `git diff` to compare **working, staged, or committed** changes.
> Example:
>
> ```bash
> git diff main feature/api
> ```
>
> ✅ Quickly reveals what differs before merging or pushing.

---
---

## **Q: What is `git rebase`, and how is it different from `git merge`?**

### 🧠 **Overview**

Both `merge` and `rebase` **combine changes from one branch into another**,
but they do it **differently** in terms of **history structure** and **commit flow**.

---

### ⚙️ **1️⃣ What is `git rebase`?**

`git rebase` moves or **"replays" commits** from one branch on top of another.
It creates a **clean, linear commit history** — as if your work was based on the latest main branch from the start.

📘 **Example:**

```bash
git checkout feature/api
git rebase main
```

✅ This takes all commits from `feature/api` and replays them **after** the latest commit on `main`.

---

### ⚙️ **2️⃣ What is `git merge`?**

`git merge` **combines two branch histories** by creating a new **merge commit** that ties both together.

📘 **Example:**

```bash
git checkout main
git merge feature/api
```

✅ This adds a new commit that merges both branches — preserving the original history (non-linear).

---

### ⚙️ **3️⃣ Visual Difference**

#### **Before merge/rebase:**

```
main:    A --- B --- C
                \
feature:          D --- E
```

#### **After `git merge`:**

```
main:    A --- B --- C ----------- F (merge commit)
                \                 /
feature:          D --- E -------
```

#### **After `git rebase`:**

```
main:    A --- B --- C --- D' --- E'
```

👉 Commits `D` and `E` are **rebased** on top of `C` (new commit hashes).

---

### ⚙️ **4️⃣ Key Differences**

| **Feature**     | **`git merge`**                     | **`git rebase`**                            |
| --------------- | ----------------------------------- | ------------------------------------------- |
| **History**     | Keeps full, branching history       | Creates linear history                      |
| **New commits** | Adds a *merge commit*               | Rewrites commits with new hashes            |
| **Clarity**     | Shows true branch structure         | Makes history cleaner, linear               |
| **Safety**      | Non-destructive (preserves history) | Rewrites history (risky on shared branches) |
| **When to use** | Collaborative merges                | Local cleanup before pushing                |
| **Command**     | `git merge branch`                  | `git rebase branch`                         |

---

### ⚙️ **5️⃣ Real Example Workflow**

#### 🔹 Using Merge (Team-safe)

```bash
git checkout main
git merge feature/login
```

✅ Good for shared/team branches → preserves commit history.

#### 🔹 Using Rebase (Clean local history)

```bash
git checkout feature/login
git rebase main
```

✅ Good before pushing or opening PR → keeps history linear and easy to review.

---

### ⚙️ **6️⃣ Fixing Conflicts During Rebase**

If conflicts occur:

```bash
# Resolve conflicts manually
git add <file>
git rebase --continue
# Abort rebase if needed
git rebase --abort
```

---

### ⚙️ **7️⃣ Best Practice Rule 🧠**

> 🔥 **Never rebase a shared/public branch** — it rewrites history and breaks others’ clones.

✅ Safe to rebase:

* Local feature branches before PR/merge
  ❌ Unsafe to rebase:
* `main`, `develop`, or already-pushed shared branches

---

### 🧩 **Pro Tip**

Use **interactive rebase** to clean commits before pushing:

```bash
git rebase -i HEAD~3
```

→ Lets you squash, edit, or rename last 3 commits.

---

### ✅ **In short:**

> **`merge`** = combines histories, keeps all commits (non-linear).
> **`rebase`** = rewrites history, applies commits sequentially (linear).
> Use **merge** for shared code, **rebase** for clean local branches.
---
---

## **Q: What is `git cherry-pick`?**

### 🧠 **Overview**

`git cherry-pick` lets you **apply a specific commit** from one branch onto another —
instead of merging or rebasing the entire branch.
It’s perfect for **selectively copying fixes or features** without merging all changes.

---

### ⚙️ **1️⃣ Basic Syntax**

```bash
git cherry-pick <commit-hash>
```

✅ This takes the changes from that commit and **creates a new commit** on your current branch.

---

### ⚙️ **2️⃣ Example Workflow**

```bash
# Step 1: Checkout the target branch
git checkout main

# Step 2: Pick a specific commit from another branch
git cherry-pick a1b2c3d
```

✅ This copies commit `a1b2c3d` from (say) `feature/login` and applies it on `main`.

---

### ⚙️ **3️⃣ When to Use `cherry-pick`**

| **Scenario**                     | **Example**                                                                   |
| -------------------------------- | ----------------------------------------------------------------------------- |
| 🐞 **Apply a hotfix**            | Copy a bug fix commit from `develop` to `prod`.                               |
| 🚀 **Promote one feature early** | Move one ready feature commit to `release` branch.                            |
| 🔄 **Sync specific commits**     | Apply a few commits from one long-lived branch to another without full merge. |

📘 Example:

```bash
# Copy only the fix commit
git cherry-pick 7f3a1d2
```

---

### ⚙️ **4️⃣ Cherry-Pick Multiple Commits**

```bash
git cherry-pick <commit1> <commit2> <commit3>
```

or a range:

```bash
git cherry-pick A..B
```

✅ Applies all commits **after A up to B**.

---

### ⚙️ **5️⃣ Conflict Handling**

If there’s a conflict:

```bash
# Resolve conflicts manually
git add <file>
git cherry-pick --continue
```

Abort if needed:

```bash
git cherry-pick --abort
```

---

### ⚙️ **6️⃣ Check Commit Hash Before Picking**

List commits:

```bash
git log --oneline --graph
```

Identify commit hash (e.g., `abc1234`) before running `cherry-pick`.

---

### ⚙️ **7️⃣ Example Visual**

```
develop:   A --- B --- C --- D (fix)
                    \
main:        X --- Y
```

After:

```bash
git checkout main
git cherry-pick D
```

✅ Commit `D` (the fix) is copied onto `main`:

```
main:   X --- Y --- D'
```

(`D'` = new commit with same changes, different hash)

---

### ⚙️ **8️⃣ Best Practices**

✅ Use it for hotfixes, selective merges, or backports.
✅ Avoid cherry-picking large sets (hard to maintain).
✅ Always note the original commit ID in message:

```bash
git cherry-pick -x <commit>
```

Adds a reference like:

```
(cherry picked from commit a1b2c3d4)
```

---

### ✅ **In short:**

> `git cherry-pick` copies **specific commits** from one branch to another,
> creating a new commit with the same changes — ideal for **hotfixes and selective feature promotion**.
---
---

## **Q: How do you undo the last commit (without losing your changes)?**

### 🧠 **Overview**

If you made a commit too early (e.g., forgot files or wrong message) —
you can undo it **without deleting your code changes** using `git reset --soft`.

---

### ⚙️ **1️⃣ Command**

```bash
git reset --soft HEAD~1
```

✅ Moves the HEAD pointer **back one commit**,
✅ Keeps all your changes **staged** (ready to recommit).

---

### ⚙️ **2️⃣ Example Workflow**

```bash
# You just committed something wrong
git commit -m "wrong commit message"

# Undo the commit, keep changes staged
git reset --soft HEAD~1

# Fix message or add files
git add .
git commit -m "correct commit message"
```

✅ No work lost — you just rewrote the last commit cleanly.

---

### ⚙️ **3️⃣ Other Useful Variants**

| **Command**                            | **Effect**                                                 |
| -------------------------------------- | ---------------------------------------------------------- |
| `git reset --soft HEAD~1`              | Undo commit, keep changes **staged**.                      |
| `git reset --mixed HEAD~1` *(default)* | Undo commit, keep changes **unstaged**.                    |
| `git reset --hard HEAD~1`              | ❌ Undo commit **and discard** all changes (use carefully). |

---

### ⚙️ **4️⃣ To Just Edit the Commit Message**

If you only want to change the last commit message:

```bash
git commit --amend -m "new message"
```

✅ Keeps code the same, just fixes message or adds missed files.

---

### ⚙️ **5️⃣ Visual Summary**

```
Before reset:
HEAD -> Commit C1 -> Commit C2 (bad)
Working Dir: clean

After reset --soft HEAD~1:
HEAD -> Commit C1
Staging Area: all C2 changes staged
```

---

### 🧠 **In short:**

> Use
>
> ```bash
> git reset --soft HEAD~1
> ```
>
> to **undo the last commit but keep your changes staged**,
> then fix, add, and recommit safely.
---
---

## **Q: How do you discard local changes in Git?**

### 🧠 **Overview**

You can discard unwanted local modifications depending on **what state** they’re in:

* Unstaged (modified but not added)
* Staged (added to index)
* Untracked (new files not in Git)

Below are the exact commands for each case 👇

---

### ⚙️ **1️⃣ Discard Unstaged Changes (Modified Files Only)**

```bash
git checkout -- <file>
# or for all files:
git checkout -- .
```

✅ Reverts files back to the last committed version.

📘 Example:

```bash
git checkout -- app/config.yaml
```

> Restores `config.yaml` to its last committed state.

---

### ⚙️ **2️⃣ Discard Staged Changes (Unstage but Keep Modifications)**

```bash
git reset HEAD <file>
# or all staged files:
git reset
```

✅ Moves files from **staging area → working directory** (keeps edits, just unstages).

📘 Example:

```bash
git reset HEAD app.py
```

> Unstages `app.py`, but keeps your edits intact.

---

### ⚙️ **3️⃣ Discard *All* Local Changes (Dangerous)**

```bash
git reset --hard
```

✅ Completely resets your working directory and staging area to the last commit.
⚠️ **This permanently deletes all uncommitted changes.**

📘 Example:

```bash
git reset --hard HEAD
```

---

### ⚙️ **4️⃣ Discard Untracked Files (not in Git)**

```bash
git clean -fd
```

✅ Deletes all untracked files and directories (not part of any commit).

📘 Example:

```bash
git clean -fd
```

> Removes build artifacts, temp files, etc.

---

### ⚙️ **5️⃣ Combined Clean Reset (Full Wipe)**

```bash
git reset --hard && git clean -fd
```

✅ Restores repo to a **pristine clean state** — like freshly cloned.

---

### ⚙️ **6️⃣ Safety Check Before Deleting**

Run this before cleaning to see what will be removed:

```bash
git clean -n
```

✅ Dry-run: lists files that would be deleted, without removing them.

---

### ⚙️ **Summary Table**

| **Situation**          | **Command**                         | **Effect**                       |
| ---------------------- | ----------------------------------- | -------------------------------- |
| Undo unstaged edits    | `git checkout -- <file>`            | Revert file to last commit.      |
| Unstage staged file    | `git reset HEAD <file>`             | Keep edits, unstage changes.     |
| Delete all local edits | `git reset --hard`                  | Revert all tracked files.        |
| Delete untracked files | `git clean -fd`                     | Remove files not tracked by Git. |
| Full clean             | `git reset --hard && git clean -fd` | Completely reset workspace.      |

---

### 🧠 **In short:**

> * `git checkout -- <file>` → discard a file’s edits
> * `git reset HEAD <file>` → unstage but keep edits
> * `git reset --hard` → discard everything (⚠ irreversible)
> * `git clean -fd` → remove untracked files

✅ Use these carefully — once discarded, changes **cannot be recovered** (unless committed or stashed).

---

---

## **Q: What is `git stash` used for?**

### 🧠 **Overview**

`git stash` temporarily saves your **uncommitted changes** (both staged and unstaged)
so you can **switch branches, pull updates, or work on something else** —
then **reapply them later** without losing any work.

It’s like a clipboard for your in-progress code 🧰.

---

### ⚙️ **1️⃣ Basic Usage**

```bash
git stash
```

✅ Saves all uncommitted changes and resets your working directory to the last commit.

📘 Example:

```bash
# You were in middle of editing
git stash
# Now workspace is clean
git pull origin main
# Bring your changes back
git stash pop
```

---

### ⚙️ **2️⃣ Check Saved Stashes**

```bash
git stash list
```

📘 Example Output:

```
stash@{0}: WIP on feature/api: 3f4a2c7 add API handler
stash@{1}: WIP on main: e9b1d2a update docs
```

---

### ⚙️ **3️⃣ Apply or Pop a Stash**

| **Command**                 | **Purpose**                                               |
| --------------------------- | --------------------------------------------------------- |
| `git stash apply`           | Apply the latest stash but keep it saved.                 |
| `git stash pop`             | Apply the latest stash and **remove it** from stash list. |
| `git stash apply stash@{n}` | Apply a specific stash by index.                          |

📘 Example:

```bash
git stash apply stash@{1}
```

---

### ⚙️ **4️⃣ Stash Only Certain Files**

```bash
git stash push <file1> <file2>
```

✅ Saves only specified files.

📘 Example:

```bash
git stash push app.py requirements.txt
```

---

### ⚙️ **5️⃣ Stash with Message**

```bash
git stash push -m "WIP: fixing login API"
```

✅ Easier to identify in `git stash list`.

---

### ⚙️ **6️⃣ View Stash Details**

```bash
git stash show -p stash@{0}
```

✅ Shows what changes were stashed.

---

### ⚙️ **7️⃣ Drop or Clear Stashes**

| **Command**                | **Action**               |
| -------------------------- | ------------------------ |
| `git stash drop stash@{0}` | Delete a specific stash. |
| `git stash clear`          | Delete **all** stashes.  |

---

### ⚙️ **8️⃣ Real-World Example**

You’re working on `feature/login`, then a production bug appears on `main`.

```bash
# Save current WIP safely
git stash push -m "WIP: login feature"

# Switch to main branch to fix bug
git checkout main
git pull origin main
# Fix & commit bug
git checkout feature/login
# Reapply saved work
git stash pop
```

✅ You safely switched contexts without losing edits.

---

### ⚙️ **9️⃣ Stash Untracked Files Too**

By default, `git stash` ignores untracked files. To include them:

```bash
git stash -u
# or include ignored files too
git stash -a
```

---

### ⚙️ **Summary Table**

| **Action**            | **Command**                |
| --------------------- | -------------------------- |
| Save current changes  | `git stash`                |
| Save with message     | `git stash push -m "msg"`  |
| List stashes          | `git stash list`           |
| Apply latest stash    | `git stash apply`          |
| Apply + remove stash  | `git stash pop`            |
| Delete specific stash | `git stash drop stash@{n}` |
| Remove all stashes    | `git stash clear`          |

---

### 🧠 **In short:**

> `git stash` = **temporarily shelves your uncommitted work** so you can switch branches or pull updates safely.
> Retrieve later using `git stash pop` or `git stash apply`.

---
---

## **Q: How do you resolve merge conflicts in Git?**

### 🧠 **Overview**

A **merge conflict** happens when two branches modify the **same lines or files**,
and Git can’t automatically decide which version to keep.
You must manually resolve conflicts, then complete the merge.

---

### ⚙️ **1️⃣ Detecting a Conflict**

During a merge or rebase:

```bash
git merge feature/api
```

If there’s a conflict, Git stops and shows:

```
Auto-merging app/config.yaml
CONFLICT (content): Merge conflict in app/config.yaml
Automatic merge failed; fix conflicts and commit the result.
```

✅ The merge is paused until you resolve the conflicts.

---

### ⚙️ **2️⃣ Identify Conflicted Files**

```bash
git status
```

Example output:

```
Unmerged paths:
  both modified:   app/config.yaml
```

---

### ⚙️ **3️⃣ Open and Resolve Conflict Manually**

Git marks conflicting lines in the file:

```diff
<<<<<<< HEAD
current code in main branch
=======
incoming code from feature/api branch
>>>>>>> feature/api
```

🧠 Edit manually — choose one side, or combine logic as needed.

✅ Example after fix:

```yaml
final merged code combining both branches
```

Then mark it as resolved:

```bash
git add app/config.yaml
```

---

### ⚙️ **4️⃣ Continue Merge**

```bash
git commit
```

✅ Git will use the default merge message (or you can edit it).

---

### ⚙️ **5️⃣ If Conflict Happens During Rebase**

After fixing and adding files:

```bash
git rebase --continue
```

To cancel the rebase:

```bash
git rebase --abort
```

---

### ⚙️ **6️⃣ View Merge Conflict Markers**

```bash
git diff
```

Shows all conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`) in files.

---

### ⚙️ **7️⃣ Abort the Merge (if needed)**

If you want to restart merge:

```bash
git merge --abort
```

✅ Returns repo to the state before merge began.

---

### ⚙️ **8️⃣ Using Visual Merge Tools (Optional)**

Git supports GUI merge tools for easier resolution:

```bash
git mergetool
```

Or use IDEs like:

* **VS Code** → built-in merge editor (`Accept Current / Incoming / Both`)
* **IntelliJ / PyCharm / Sublime Merge** → visual side-by-side diff

---

### ⚙️ **9️⃣ Verify Resolution**

After commit:

```bash
git log --oneline --graph
```

✅ Confirms the merge completed.

---

### ⚙️ **10️⃣ Example Workflow Recap**

```bash
# Start merge
git merge feature/login

# View conflicted files
git status

# Edit files manually
# (resolve conflict markers)
git add .

# Finish merge
git commit

# Verify
git log --oneline --graph
```

---

### ⚙️ **11️⃣ Best Practices**

✅ Pull latest changes before starting merges
✅ Commit or stash all local changes before merging
✅ Resolve and test thoroughly before pushing
✅ Avoid rebasing shared branches to reduce conflicts
✅ Use smaller, frequent merges instead of huge ones

---

### 🧠 **In short:**

> When Git shows conflict markers (`<<<<<<<` / `=======` / `>>>>>>>`):
>
> * Open file → edit manually → `git add` → `git commit`.
> * Or abort with `git merge --abort`.
>   ✅ Resolve, test, and push once verified cleanly.
---
---

## **Q: How do you tag a release in Git?**

### 🧠 **Overview**

A **Git tag** marks a specific commit — typically used for **versioning releases** (`v1.0`, `v2.3.1`, etc.).
Tags are like **permanent labels** on commits and are widely used in CI/CD pipelines for deployment triggers or changelogs.

---

### ⚙️ **1️⃣ List Existing Tags**

```bash
git tag
```

✅ Shows all existing tags in the repository.

---

### ⚙️ **2️⃣ Create a Lightweight Tag**

```bash
git tag v1.0
```

✅ Creates a simple pointer to the current commit (no metadata).

📘 Example:

```bash
git tag v2.0
```

---

### ⚙️ **3️⃣ Create an Annotated Tag (Recommended)**

```bash
git tag -a v1.0 -m "Release version 1.0 - production ready"
```

✅ Annotated tags store tagger info, date, and a message — ideal for production releases.

---

### ⚙️ **4️⃣ Tag a Specific Commit**

```bash
git tag -a v1.1 <commit-hash> -m "Release v1.1 hotfix"
```

📘 Example:

```bash
git log --oneline
git tag -a v2.3 1a2b3c4 -m "Release 2.3"
```

✅ Useful when tagging older commits after a patch.

---

### ⚙️ **5️⃣ Verify Tag Details**

```bash
git show v1.0
```

Displays commit details and tag message.

---

### ⚙️ **6️⃣ Push Tags to Remote**

| **Action**        | **Command**              |
| ----------------- | ------------------------ |
| Push a single tag | `git push origin v1.0`   |
| Push all tags     | `git push origin --tags` |

✅ After pushing, tags are visible on GitHub/GitLab under “Releases”.

---

### ⚙️ **7️⃣ Delete Tags**

| **Action**        | **Command**                       |
| ----------------- | --------------------------------- |
| Delete local tag  | `git tag -d v1.0`                 |
| Delete remote tag | `git push origin :refs/tags/v1.0` |

---

### ⚙️ **8️⃣ List Tags by Pattern**

```bash
git tag -l "v2.*"
```

✅ Lists all version 2.x tags.

---

### ⚙️ **9️⃣ Real-World CI/CD Example**

In release pipelines (e.g., GitLab/GitHub Actions), a tag triggers deployment:

```yaml
on:
  push:
    tags:
      - 'v*.*.*'
```

✅ When you push a tag like `v1.2.0`, CI automatically builds & deploys that version.

---

### ⚙️ **10️⃣ Summary Table**

| **Action**             | **Command**                         | **Notes**              |
| ---------------------- | ----------------------------------- | ---------------------- |
| List tags              | `git tag`                           | View existing tags     |
| Create lightweight tag | `git tag v1.0`                      | Simple pointer         |
| Create annotated tag   | `git tag -a v1.0 -m "Release v1.0"` | Preferred for releases |
| Tag specific commit    | `git tag -a v1.1 <hash>`            | Tag old commits        |
| Push tag               | `git push origin v1.0`              | Push to remote         |
| Push all tags          | `git push origin --tags`            | Bulk push              |
| Delete tag             | `git tag -d v1.0`                   | Remove locally         |
| Delete remote tag      | `git push origin :refs/tags/v1.0`   | Remove from remote     |

---

### 🧠 **In short:**

> Use annotated tags for versioning:
>
> ```bash
> git tag -a v1.0 -m "Release version 1.0"
> git push origin v1.0
> ```
>
> ✅ Tags mark stable release points — perfect for CI/CD deployments and rollback reference.
---
---

## **Q: How do you delete a branch locally and remotely in Git?**

### 🧠 **Overview**

When a feature or bug-fix branch is no longer needed (e.g., after merging),
you can delete it both **locally** and **remotely** to keep your repository clean and organized.

---

### ⚙️ **1️⃣ Delete a Local Branch**

```bash
git branch -d <branch-name>
```

✅ Safely deletes a branch that has already been merged into your current branch.

📘 Example:

```bash
git branch -d feature/login
```

**Output:**

```
Deleted branch feature/login (was a1b2c3d).
```

---

### ⚙️ **2️⃣ Force Delete (Unmerged Branch)**

If the branch hasn’t been merged yet and you still want to delete it:

```bash
git branch -D <branch-name>
```

⚠️ **Dangerous:** this will delete the branch even if changes aren’t merged.

📘 Example:

```bash
git branch -D hotfix/debug
```

---

### ⚙️ **3️⃣ Delete a Remote Branch**

```bash
git push origin --delete <branch-name>
```

✅ Removes the branch from the remote repository (e.g., GitHub, GitLab).

📘 Example:

```bash
git push origin --delete feature/login
```

**Alternative (older syntax):**

```bash
git push origin :feature/login
```

---

### ⚙️ **4️⃣ Verify Deletion**

**Local check:**

```bash
git branch
```

**Remote check:**

```bash
git fetch -p
git branch -r
```

✅ `-p` prunes deleted remote branches from your local cache.

---

### ⚙️ **5️⃣ Delete Multiple Local Branches (Optional)**

```bash
git branch | grep 'feature/' | xargs git branch -d
```

✅ Deletes all branches starting with `feature/` that are already merged.

---

### ⚙️ **6️⃣ Summary Table**

| **Action**           | **Command**                       | **Notes**                                 |
| -------------------- | --------------------------------- | ----------------------------------------- |
| Delete local branch  | `git branch -d branch`            | Safe delete (merged only)                 |
| Force delete local   | `git branch -D branch`            | Force delete (unmerged)                   |
| Delete remote branch | `git push origin --delete branch` | Removes from remote repo                  |
| Clean up remote refs | `git fetch -p`                    | Removes deleted branches from local cache |

---

### 🧠 **In short:**

> ✅ Delete locally → `git branch -d feature/api`
> ✅ Delete remotely → `git push origin --delete feature/api`
> ⚠️ Use `-D` only if you’re sure you don’t need the unmerged work.

---
---

## **Q: How do you check which branch you’re on in Git?**

### 🧠 **Overview**

To see your **current branch** in Git — i.e., where `HEAD` is pointing —
you can use simple commands like `git branch` or `git status`.
These help confirm your active working branch before committing, merging, or pushing.

---

### ⚙️ **1️⃣ Basic Command**

```bash
git branch
```

📘 **Output Example:**

```
  main
* feature/login
```

✅ The `*` (asterisk) marks the **current branch** you’re on (`feature/login` here).

---

### ⚙️ **2️⃣ Using `git status`**

```bash
git status
```

📘 **Output Example:**

```
On branch feature/login
Your branch is up to date with 'origin/feature/login'.
```

✅ Displays both the current branch and sync status with remote.

---

### ⚙️ **3️⃣ Show Branch Name Only**

```bash
git rev-parse --abbrev-ref HEAD
```

✅ Outputs just the branch name (useful for scripts or CI pipelines).

📘 Example Output:

```
feature/login
```

---

### ⚙️ **4️⃣ Check Remote Tracking Branch**

```bash
git status -sb
```

✅ Compact view showing both local and remote tracking branches.

📘 Example:

```
## feature/login...origin/feature/login
```

---

### ⚙️ **5️⃣ Visual Check in Log**

```bash
git log --oneline --decorate -1
```

✅ Shows latest commit and branch tag (useful for quick branch + commit check).

📘 Example:

```
a1b2c3d (HEAD -> feature/login, origin/feature/login) add login API
```

---

### ⚙️ **6️⃣ Summary Table**

| **Purpose**                       | **Command**                       | **Output Example**    |
| --------------------------------- | --------------------------------- | --------------------- |
| List all branches, show current   | `git branch`                      | `* main`              |
| Show current branch only          | `git rev-parse --abbrev-ref HEAD` | `main`                |
| Status summary (branch + changes) | `git status`                      | `On branch dev`       |
| Show remote tracking              | `git status -sb`                  | `## dev...origin/dev` |
| View branch via log               | `git log --decorate -1`           | `(HEAD -> dev)`       |

---

### 🧠 **In short:**

> Use `git branch` to list branches — the one marked with `*` is your current branch.
> For scripts or automation, use:
>
> ```bash
> git rev-parse --abbrev-ref HEAD
> ```
>
> ✅ Quick, clean, and CI-friendly.
---
Short answer (2 lines)
Never hard-code credentials — use your CI’s secret store (or OIDC / short-lived tokens), least-privilege service accounts or deploy keys, masked/protected variables, and rotate/audit regularly. Prefer built-in CI tokens (GITHUB_TOKEN, GitLab tokens), or ephemeral SSH keys injected at runtime via the CI credentials manager.

---

## Practical principles (must-follow)

* **Never** commit creds or tokens to repo or images.
* Use **least privilege** tokens (push-only to specific repo, short scope).
* Prefer **ephemeral / short-lived** credentials (OIDC, STS assume-role).
* Store secrets in the CI provider’s **secret vault** (masked, protected).
* Only expose secrets to **protected branches/tags** and trusted runners.
* **Audit & rotate** keys regularly; revoke on compromise.
* Mask secrets in logs and avoid `echo $SECRET` in scripts.
* Use **deploy keys / machine user** accounts for automation, not personal accounts.
* Use **SSH with known_hosts** or HTTPS with token — both OK if handled via CI secrets.

---

## Recommended patterns + examples

### 1) Prefer built-in CI tokens (no secrets)

* **GitHub Actions:** use `GITHUB_TOKEN` (auto-created) with needed permissions.

```yaml
permissions:
  contents: write
jobs:
  push:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Make change
        run: echo "x" >> file.txt && git add file.txt && git commit -m "ci"
      - name: Push
        run: git push
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

* **GitLab CI:** prefer `CI_JOB_TOKEN` or a **Deploy Token** for API/push actions where appropriate.

### 2) HTTPS token (deploy token / PAT) — store as secret / masked var

* Create a **deploy account/token** with minimal scopes (repo:write for push).
* In CI, use masked variable `GIT_TOKEN` and push via HTTPS:

```bash
git config user.email "ci@acme.com"
git config user.name "ci-bot"
git remote set-url origin https://$GIT_TOKEN@github.com/org/repo.git
git push origin HEAD:main
```

* Ensure `GIT_TOKEN` is protected and only available on protected branches.

### 3) SSH deploy key (recommended for repos)

* Create an **SSH key pair** dedicated to CI, add public key as repo Deploy Key (write if needed).
* Store private key in CI secrets and use the SSH agent helper:

```yaml
# GitHub Actions example using actions/checkout + ssh-agent
- uses: webfactory/ssh-agent@v0.7.0
  with:
    ssh-private-key: ${{ secrets.DEPLOY_KEY }}
- run: git push git@github.com:org/repo.git HEAD:main
```

* Add `known_hosts` entry or configure `StrictHostKeyChecking=no` carefully.

### 4) OIDC / Workload Identity (best for cloud creds)

* Use **OIDC** to exchange CI token for cloud role (AWS STS, GCP Workload Identity) — avoids long-lived keys in CI.
* Use that STS credential to authenticate with cloud services or create short-lived git tokens via cloud secret stores if supported.

### 5) Jenkins / self-hosted runners

* Use the **Credentials Plugin** (username/password, secret text, SSH key), bind into job env vars (masked).
* Example (pipeline snippet):

```groovy
withCredentials([string(credentialsId: 'git-pat', variable: 'GIT_PAT')]) {
  sh 'git remote set-url origin https://$GIT_PAT@github.com/org/repo.git'
  sh 'git push origin HEAD:main'
}
```

* Run builds on **ephemeral agents** when possible.

---

## Security controls & hardening

* **Protect CI secrets:** require protected branches to access them.
* **Restrict token scopes** (no repo:admin if only push needed).
* **Use deploy keys per-repo** rather than global credentials.
* **Rotate tokens** on schedule and after maintainer changes.
* **Audit** CI job access and token usage logs.
* **Mask outputs** and set `set -o errexit` and `set -o pipefail` — avoid leaking secrets.
* **Limit runner exposure:** run jobs in isolated ephemeral runners, not shared machines with secrets accessible to untrusted jobs.

---

## Quick checklist to implement now

* [ ] Replace any hard-coded creds in pipelines.
* [ ] Move secrets into CI secret store and mark as protected/masked.
* [ ] Use `GITHUB_TOKEN`/`CI_JOB_TOKEN` where possible.
* [ ] Use SSH deploy keys for repo pushes (store private key in CI).
* [ ] Implement OIDC/short-lived tokens for cloud interactions.
* [ ] Restrict secret availability to protected branches/jobs.
* [ ] Add tagging/rotation policy and audit logs.

---

If you tell me which CI runner you use (GitHub Actions / GitLab CI / Jenkins / GitHub Enterprise), I’ll provide a copy-paste pipeline snippet (including secure push via SSH or HTTPS with protected secrets) tailored to that environment.

---
---

## Q: What is a Detached HEAD State?

### 🧠 Overview

A **detached HEAD** in Git means you’re **not on any branch**, but instead your `HEAD` points directly to a **specific commit (SHA)**.
You can explore or make temporary changes, but new commits won’t belong to any branch unless explicitly attached.

---

### ⚙️ Example / Commands

```bash
# Check out a specific commit (not a branch)
git checkout <commit-id>

# Example
git checkout 3e2a1f4
# HEAD is now detached at 3e2a1f4
```

If you commit in this state:

```bash
git commit -m "Hotfix tested"
# The commit is created but not on any branch
```

To recover or attach it to a branch:

```bash
# Create a new branch to save changes
git switch -c hotfix-temp

# Or reattach to an existing branch
git checkout main
```

---

### 📋 Notes / Table

| Concept       | Description                                               |
| ------------- | --------------------------------------------------------- |
| `HEAD`        | Pointer to the current commit                             |
| Detached HEAD | HEAD points to a commit, not a branch                     |
| Risk          | Commits can be lost if you switch branches without saving |
| Fix           | Create a new branch or reattach to an existing one        |

---

### ✅ Best Practices

* Always create a branch before making commits in detached state.
* Use it safely for testing old commits or debugging builds.
* Commit only after reattaching if you want changes to persist.

---

### 💡 In short

**Detached HEAD = you’re “off the branch”, working directly on a commit.**
Always branch out if you want to keep your changes. 🌿

---
---

## Q: What’s the Difference Between `git reset`, `git revert`, and `git restore`?

### 🧠 Overview

These three Git commands are used to **undo or modify changes**, but they act on **different levels** — commits, staging area, and working directory.

---

### ⚙️ Example / Commands

#### 🧩 1. `git reset` → Move HEAD & optionally modify index/workspace

Used to **undo commits or unstage files**.

```bash
# Undo last commit, keep changes
git reset --soft HEAD~1

# Undo last commit and unstage changes
git reset --mixed HEAD~1

# Undo commit + delete changes permanently
git reset --hard HEAD~1
```

---

#### 🔁 2. `git revert` → Create a new commit that undoes previous one

Safe for shared branches (doesn’t rewrite history).

```bash
# Revert a specific commit by hash
git revert <commit-id>

# Revert multiple commits
git revert HEAD~2..HEAD
```

---

#### 🧹 3. `git restore` → Restore working directory or staging changes

Introduced in Git 2.23 to replace some reset/checkout use cases.

```bash
# Discard local file changes
git restore file.txt

# Unstage a file
git restore --staged file.txt
```

---

### 📋 Comparison Table

| Command       | Affects                  | Rewrites History | Safe for Shared Branches | Typical Use                             |
| ------------- | ------------------------ | ---------------- | ------------------------ | --------------------------------------- |
| `git reset`   | HEAD, index, working dir | ✅ Yes            | ❌ No                     | Undo local commits, move branch pointer |
| `git revert`  | Commit history           | ❌ No             | ✅ Yes                    | Safely undo commits by adding new ones  |
| `git restore` | Working dir / staging    | ❌ No             | ✅ Yes                    | Discard or unstage file changes         |

---

### ✅ Best Practices

* Use **`git revert`** for public branches (safe).
* Use **`git reset`** only on local/private branches.
* Use **`git restore`** to discard or unstage without affecting commits.
* Always check `git status` before applying destructive operations.

---

### 💡 In short

* 🧱 **reset** → move HEAD (rewrite history)
* 🔁 **revert** → add inverse commit (safe undo)
* 🧹 **restore** → discard or unstage files

👉 Think: **reset = rewind**, **revert = safe undo**, **restore = cleanup**.

---
---

## Q: How to find which commit introduced a bug?

### 🧠 Overview

Use **binary search** over commits (primary: `git bisect`) plus targeted tools (`git blame`, `git log -S/-G`) to quickly locate the commit that introduced a regression. Prefer an **automatable, reproducible test** so `git bisect run` can find the culprit reliably.

---

### ⚙️ Examples / Commands

#### 1) Quick check with `git blame` (file-level, when you know the file)

```bash
# See who last changed lines around where the bug manifests
git blame -L <start>,<end> -- path/to/file.py

# Example: blame lines 100-140
git blame -L 100,140 -- src/main.go
```

#### 2) Search by content change (`-S` exact string, `-G` regex)

```bash
# Find commits that added/removed exact string
git log -S"memory leak" --source --all -- path/to/file

# Regex search
git log -G"^func .*Leak" -- path/to/file
```

#### 3) The reliable method — `git bisect` (binary search)

```bash
# Start bisect
git bisect start

# Mark current commit as bad (has bug)
git bisect bad

# Mark a known-good commit (before bug) by SHA or branch
git bisect good v1.2.3   # or <good-sha>

# Manual bisect workflow:
# Git checks out a middle commit. Test it; then:
git bisect good   # if test passes
git bisect bad    # if test fails

# Repeat until git outputs the first bad commit (introducer)
# After finishing:
git bisect reset
```

#### 4) Automate bisect with a test script

Make a script that exits `0` when commit is good and non-zero when bad:

```bash
# bisect-test.sh (make executable)
#!/bin/bash
# return 0 if good (no bug), 1 if bad (bug present)
# Example: run unit test or smoke test
pytest tests/test_regression.py -q
if [ $? -eq 0 ]; then
  exit 0
else
  exit 1
fi
```

Run automated bisect:

```bash
git bisect start
git bisect bad               # current commit has bug
git bisect good v1.2.3       # known-good commit
git bisect run ./bisect-test.sh
# Git will run the script across commits and report the first bad commit
git bisect reset
```

#### 5) If many commits are non-buildable / flaky

```bash
# Skip commits that don't build
git bisect skip <commit-sha>
# Or during bisect, when a commit can't be tested:
git bisect skip
```

#### 6) Save/replay bisect session

```bash
git bisect log > bisect.log
# On another clone:
git bisect replay bisect.log
```

---

### 📋 Method Comparison Table

| Method                |                                              Use-case | Pros                                        | Cons                                                          |
| --------------------- | ----------------------------------------------------: | ------------------------------------------- | ------------------------------------------------------------- |
| `git bisect`          | Reproducible test that distinguishes good/bad commits | Fast (O(log n)), automatable (`bisect run`) | Requires reliable test/build for each commit                  |
| `git blame`           |                      Narrowed file/line is suspicious | Instant file-level author/date context      | Only shows last modifier per line, not necessarily introducer |
| `git log -S/-G`       |                             Search by content changes | Good when bug ties to text/regex changes    | Misses behavioral bugs not tied to text                       |
| Manual `git checkout` |                                Quick local inspection | Easy for tiny histories                     | Slow for long histories, error-prone                          |

---

### ✅ Best Practices

* 🧪 **Create a minimal, deterministic test** that reproduces the bug — `git bisect run` depends on it.
* 🔁 **Isolate environment**: use containers/CI to ensure reproducible builds across commits (e.g., `docker run` to build+test).
* 🧹 **Skip broken commits** that fail to build with `git bisect skip`. Keep note of skipped SHAs.
* 📂 **Narrow range first**: if you can, limit bisect to a subdirectory (`git bisect start -- path/`) or use `--` with `git log` to filter files.
* 🧾 **Record results**: use `git bisect log` and create a branch at the bad commit (`git checkout -b fix/bug-123 <bad-sha>`).
* 👥 **Communicate**: if the introducer is on a team, tag the author in the issue with commit SHA + reproduction steps.
* ⏱️ **Use CI**: For large repos, run bisect in CI/dedicated runner where dependencies and build caches are available.

---

### 💡 Troubleshooting Tips

* If tests are flaky, stabilize tests first (bisect on flaky tests is misleading).
* If the repo uses long build times, create a tiny reproducer (smoke test) and run bisect on that.
* For binary / external dependency issues, bisect commits that changed dependency versions or lockfiles (`package.json`, `go.mod`, `requirements.txt`).

---

### 💡 In short

**Use `git bisect` with a deterministic test to binary-search the failing commit; fallback to `git blame` or `git log -S/-G` for file/content-level clues.** ✅

---
---

## Q: How do you squash multiple commits?

### 🧠 Overview

Squashing combines several commits into one cleaner commit — commonly done with **interactive rebase**, **merge --squash**, or local `reset --soft`. Use interactive rebase for fine-grained control; avoid rewriting public history unless coordinated.

---

### ⚙️ Examples / Commands

#### 1) Interactive rebase (recommended)

Squash the last N commits into one (interactive):

```bash
# Start interactive rebase for last 4 commits
git rebase -i HEAD~4
```

In the editor change:

```
pick 1111111 Commit A
s    2222222 Commit B   # change 'pick' to 's' (squash) or 'f' (fixup)
s    3333333 Commit C
pick 4444444 Commit D
```

Save & close → edit final commit message when prompted.

---

#### 2) Autosquash for fixup! / squash! commits

Create fixup commits then autosquash:

```bash
# mark commit as target
git commit --amend -m "feat: add API"

# later create fixup
git commit --fixup <target-sha>

# run rebase with autosquash
git rebase -i --autosquash HEAD~5
```

---

#### 3) Squash via `git reset --soft` (simple local rewrite)

Combine last 3 commits into one (keeps working tree):

```bash
git reset --soft HEAD~3
git commit -m "feat: combined changes — summary message"
```

---

#### 4) `git merge --squash` (when merging feature branch)

Squash a feature branch into current branch as one commit:

```bash
git checkout main
git merge --squash feature/my-work
git commit -m "feat(feature): all changes from feature/my-work"
```

---

#### 5) Amend last commit (squash a staged change into previous commit)

```bash
# stage files
git add file1 file2
# combine into previous commit
git commit --amend --no-edit   # keep message
# or edit message
git commit --amend
```

---

### 📋 Comparison Table

| Method                  |                                           Use-case | Pros                                              | Cons                                                          |
| ----------------------- | -------------------------------------------------: | ------------------------------------------------- | ------------------------------------------------------------- |
| `git rebase -i`         | Fine-grained multi-commit squash & message editing | Very flexible, interactive                        | Rewrites history — needs care on shared branches              |
| `--autosquash` + rebase |              When using `fixup!`/`squash!` commits | Automates pairing & squashing                     | Requires prior `fixup`/`squash` commit format                 |
| `git reset --soft`      |                    Quick local squash of N commits | Simple, fast                                      | Manual message; rewrites history                              |
| `git merge --squash`    |              Merge feature branch as single commit | Good for cleaning feature branches before merging | No merge commit metadata; author attribution is single commit |
| `git commit --amend`    |                  Add staged changes to last commit | Handy for small fixes                             | Only affects last commit                                      |

---

### ✅ Best Practices

* 🔒 **Do not rewrite public history**: avoid squashing commits already pushed to a shared branch unless you coordinate.
* ✅ Use `git rebase -i` locally to craft clean, logical commits before pushing.
* 🧰 When rewriting pushed history, push with `--force-with-lease` (safer than `--force`):

  ```bash
  git push --force-with-lease origin feature/branch
  ```
* 🧪 Run tests locally after squashing to ensure nothing broke.
* 🧾 Keep useful commit messages — squash into a message that documents the intent and scope.
* 🔁 If unsure, create a backup branch before rewriting:

  ```bash
  git branch backup/feature-before-squash
  ```

---

### 💡 In short

Use `git rebase -i HEAD~N` to interactively squash commits (use `s`/`f`), or `git merge --squash` / `git reset --soft` for simpler flows — **never rewrite public history without coordination; push with `--force-with-lease` if needed**. ✅

---
---

## Q: What’s a Git Submodule?

### 🧠 Overview

A **Git submodule** lets you include one Git repository **inside another** as a dependency — ideal for sharing libraries, configuration templates, or modules across projects. It maintains an independent history and commit reference within the parent repo.

---

### ⚙️ Examples / Commands

#### 1) Add a submodule

```bash
# Add external repo as a submodule under a directory
git submodule add https://github.com/org/common-lib.git libs/common-lib

# Initialize and fetch submodule content
git submodule init
git submodule update
```

Result:

* Creates `.gitmodules` file (tracks submodule URL & path).
* Adds a **fixed commit reference** of the submodule to your main repo.

---

#### 2) Clone a repo with submodules

```bash
# Clone parent + recursively initialize submodules
git clone --recurse-submodules https://github.com/org/main-app.git
```

If you forgot `--recurse-submodules`:

```bash
git submodule update --init --recursive
```

---

#### 3) Pull latest changes for submodules

```bash
# Inside main repo
git submodule update --remote --merge
# or manually inside submodule directory
cd libs/common-lib
git pull origin main
```

---

#### 4) Change submodule URL or branch

```bash
# Change branch tracked by submodule
git config -f .gitmodules submodule.libs/common-lib.branch develop
git submodule sync
```

---

#### 5) Remove a submodule cleanly

```bash
git submodule deinit -f libs/common-lib
rm -rf .git/modules/libs/common-lib
git rm -f libs/common-lib
```

---

### 📋 Key Files & Concepts

| Component        | Description                                                          |
| ---------------- | -------------------------------------------------------------------- |
| `.gitmodules`    | Stores submodule path and remote URL                                 |
| `.git/config`    | Contains local config of submodules                                  |
| Submodule commit | Parent repo tracks a specific commit SHA of the submodule            |
| Detached HEAD    | Submodules are usually in detached HEAD state (at a specific commit) |

---

### ✅ Best Practices

* 📦 Keep submodules **read-only** unless you maintain both parent & child.
* 🔒 Always commit submodule updates in parent repo after pulling changes:

  ```bash
  git add libs/common-lib
  git commit -m "Update submodule common-lib to latest main"
  ```
* 🧰 Prefer **subtrees** or **package registries** (like Nexus/ECR/GitHub Packages) if submodule updates are frequent.
* 🚫 Avoid submodules for tightly coupled codebases — they complicate CI/CD pipelines.
* 🧪 Use `--recurse-submodules` in automation scripts (builds, Dockerfiles, CI).

---

### 💡 In short

**Git submodule = a repository inside another repo** — tracks a specific commit of an external project.
👉 Great for shared dependencies, but manage with care in CI/CD due to sync complexity. ⚙️

---
---

## Q: How do you handle large files in Git?

### 🧠 Overview

Git is not optimized for large binary blobs. Use **Git LFS** (or external storage/artifact registries) to keep your repo fast and history small — combine with `.gitattributes`, sparse/partial clones, and history migration/cleanup when needed.

---

### ⚙️ Examples / Commands

#### 1) Add Git LFS (recommended)

```bash
# Install & enable LFS (one-time per machine)
git lfs install --local

# Track file patterns
git lfs track "*.psd"
git lfs track "assets/**/*.zip"

# Ensure .gitattributes is added
git add .gitattributes
git add path/to/large-file.psd
git commit -m "Add large assets via Git LFS"
git push origin main
```

`.gitattributes` (auto-created by `git lfs track`):

```gitattributes
*.psd filter=lfs diff=lfs merge=lfs -text
assets/**/*.zip filter=lfs diff=lfs merge=lfs -text
```

---

#### 2) Migrate existing large files into LFS

```bash
# Convert past commits for patterns into LFS (rewrites history)
git lfs migrate import --include="*.psd,*.zip" --everything

# Push rewritten history (force required)
git push --force-with-lease origin main
```

> ⚠️ Rewriting history requires coordination — inform teammates and prefer branches or backups.

---

#### 3) Remove big files from history (cleanup)

Use `git filter-repo` (recommended) or BFG:

```bash
# Remove blobs bigger than 100MB from history
git clone --mirror git@github.com:org/repo.git
cd repo.git
git filter-repo --strip-blobs-bigger-than 100M
git push --force --mirror
```

Or BFG:

```bash
# Using BFG to remove >100MB blobs (Java required)
java -jar bfg.jar --strip-blobs-bigger-than 100M repo.git
cd repo.git
git reflog expire --expire=now --all && git gc --prune=now --aggressive
git push --force --mirror
```

---

#### 4) Use partial clone / sparse-checkout for large monorepos

```bash
# Partial clone to avoid downloading blobs
git clone --filter=blob:none --no-checkout git@github.com:org/monorepo.git
cd monorepo
# Sparse-checkout only 'service-a'
git sparse-checkout init --cone
git sparse-checkout set services/service-a
git checkout main
```

---

#### 5) Prefer external artifact storage for build outputs / large binaries

* Upload released binaries/assets to S3/MinIO/GCS or an artifact registry (JFrog, Nexus, GitHub Releases).
* In CI, publish build artifacts to the registry and fetch them in deploy steps.

Example (AWS S3 in CI):

```bash
# CI: upload build artifact
aws s3 cp build/package.zip s3://my-artifacts/${CI_JOB_ID}/package.zip

# Deploy: download artifact
aws s3 cp s3://my-artifacts/${CI_JOB_ID}/package.zip .
```

---

### 📋 Comparison Table

| Option                                |                                  Use-case | Pros                                     | Cons                                       |
| ------------------------------------- | ----------------------------------------: | ---------------------------------------- | ------------------------------------------ |
| **Git LFS**                           |        Large media/assets tracked in repo | Integrates with Git, transparent to devs | Extra quota, needs LFS on CI/clients       |
| **Artifact Registry / S3**            |                   Build outputs, releases | Scales, cheaper, no Git history bloat    | Extra infra + access/auth setup            |
| **Partial clone / sparse-checkout**   |                Large monorepos, big blobs | Avoids downloading unnecessary blobs     | Requires modern Git & repo support         |
| **History rewrite (filter-repo/BFG)** | Remove accidentally committed large files | Cleans repo size                         | Rewrites history → coordinate & force-push |
| **Git-annex / external stores**       |     Very large datasets (scientific data) | Powerful for dataset management          | More complex than Git LFS                  |

---

### ✅ Best Practices

* 📁 **Never** commit large binaries (build outputs, datasets) directly — use `.gitignore` and artifact storage.
* 🧩 Use **Git LFS** for large assets that must version with source (design files, model weights). Ensure CI runners have `git lfs install`.
* 🔁 Plan and **coordinate** before rewriting history; create backups and inform the team.
* 🔍 Monitor repository size & run periodic audits (`git count-objects -vH`, `git-sizer`).
* 🚦 Enforce policies in CI/PRs: reject commits > N MB and scan for large files in pre-commit hooks. Example pre-commit check:

```bash
# simple check in CI / pre-commit
find . -type f -size +50M -not -path "./.git/*" -print && exit 1 || exit 0
```

* 🧾 Store checksums and metadata (filename → S3 path, checksum) in repo for reproducibility.
* 💾 For huge datasets, prefer **dedicated dataset managers** (DVC, git-annex) that integrate with object storage.

---

### 💡 In short

Use **Git LFS** for tracked large assets, move build artifacts to an **artifact registry or S3**, and **avoid committing** big binaries. If large files are already in history, clean them with `git lfs migrate` or `git filter-repo` and coordinate history rewrites. ✅

---
---

## Q: How to Revert a Pushed Commit Safely?

### 🧠 Overview

When a commit has already been **pushed to a shared branch**, use `git revert` — it creates a **new commit that undoes** the changes safely, **without rewriting history**.
Avoid `git reset --hard` or force pushes on shared branches unless absolutely necessary.

---

### ⚙️ Examples / Commands

#### 1️⃣ Safely revert a single pushed commit

```bash
# View commit history
git log --oneline

# Revert a specific commit by SHA
git revert <commit-sha>
# Example
git revert 8c6b1f2

# Push the revert commit
git push origin main
```

✅ This adds a *new* commit reversing the effects of `<commit-sha>`.

---

#### 2️⃣ Revert multiple commits together

```bash
# Revert a range (HEAD~3..HEAD means last 3 commits)
git revert HEAD~3..HEAD

# Push after reverting
git push origin main
```

Each revert is created in reverse order to preserve consistency.

---

#### 3️⃣ Auto-revert without opening editor

```bash
git revert --no-edit <commit-sha>
```

---

#### 4️⃣ Revert a merge commit (special case)

Merge commits need the `-m` option to specify parent branch.

```bash
# Find parent index (1 = main branch, 2 = feature branch)
git log --graph --oneline

# Example: revert merge commit but keep main’s side
git revert -m 1 <merge-commit-sha>
git push origin main
```

---

#### 5️⃣ If revert causes conflicts

```bash
# Resolve conflicts manually
git status
# Edit conflicted files
git add <resolved-file>
git revert --continue
```

---

#### 6️⃣ Undo a previous revert (restore reverted changes)

```bash
# Revert the revert (reapply old changes)
git revert <revert-commit-sha>
git push origin main
```

---

### 📋 Comparison Table

| Method             | Description                                     | Rewrites History | Safe for Shared Branches | Use-case                                     |
| ------------------ | ----------------------------------------------- | ---------------- | ------------------------ | -------------------------------------------- |
| `git revert`       | Creates a new commit that undoes a prior commit | ❌ No             | ✅ Yes                    | Safest method for public branches            |
| `git reset --hard` | Moves HEAD & deletes commits                    | ✅ Yes            | ❌ No                     | Local-only cleanup before push               |
| `git push --force` | Overwrites remote history                       | ✅ Yes            | ⚠️ Dangerous             | Only in private/dev branches after team sync |

---

### ✅ Best Practices

* 🧩 Always use `git revert` for **shared/public branches** (main, master, release).
* 🔒 Use `git reset --hard` + `--force-with-lease` **only** on private or feature branches you own.
* 🧪 Test the revert locally before pushing — ensure the build/tests still pass.
* 🧾 Use `--no-edit` for automation scripts or CI revert jobs.
* 👥 Communicate in PR/issue tracker when reverting, with reason & impact.
* 📦 If reverting a deployment, tag the reverted state for rollback traceability:

  ```bash
  git tag rollback-2025-11-10
  git push origin rollback-2025-11-10
  ```

---

### ⚙️ CI/CD Example (Auto Revert Job)

```yaml
# GitHub Actions example
jobs:
  auto-revert:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      - name: Revert a bad commit
        run: |
          git revert --no-edit ${{ inputs.commit_sha }}
          git push origin main
```

---

### 💡 In short

Use **`git revert <sha>`** to undo a pushed commit — it’s **non-destructive**, keeps history intact, and is **safe for team workflows**.

> 🚫 Avoid `git reset` or `--force` on shared branches — revert instead. ✅

---
---

## Q: What’s the Difference Between `origin` and `upstream` in Git?

### 🧠 Overview

Both `origin` and `upstream` are **remote aliases (URLs)** in Git.

* **`origin`** → your own remote (the repo you cloned or push to).
* **`upstream`** → the original source repository (usually the one you forked from).

---

### ⚙️ Examples / Commands

#### 1️⃣ Typical fork workflow

```bash
# Clone your fork (your remote = origin)
git clone git@github.com:vasu/my-fork.git
cd my-fork

# Add the original repo as upstream
git remote add upstream git@github.com:org/project.git
```

Now check remotes:

```bash
git remote -v
```

Output:

```
origin    git@github.com:vasu/my-fork.git (fetch)
origin    git@github.com:vasu/my-fork.git (push)
upstream  git@github.com:org/project.git (fetch)
upstream  git@github.com:org/project.git (push)
```

---

#### 2️⃣ Sync your fork with upstream

```bash
# Fetch latest changes from upstream
git fetch upstream

# Merge into your main branch
git checkout main
git merge upstream/main

# Or rebase for cleaner history
git rebase upstream/main

# Push to your fork (origin)
git push origin main
```

---

#### 3️⃣ Update your local feature branch from upstream

```bash
git checkout feature/api
git fetch upstream
git rebase upstream/main
```

---

#### 4️⃣ Change or remove remotes

```bash
# Change remote URL
git remote set-url origin git@github.com:vasu/my-fork.git

# Remove remote
git remote remove upstream
```

---

### 📋 Comparison Table

| Remote       | Points to                               | Purpose                       | Push Allowed  | Common Use                         |
| ------------ | --------------------------------------- | ----------------------------- | ------------- | ---------------------------------- |
| `origin`     | Your personal repo (fork or main clone) | Your default remote           | ✅ Yes         | Push branches, create PRs          |
| `upstream`   | The original source project             | Sync latest code              | ⚠️ Usually No | Fetch changes from main project    |
| Custom names | Any other repo                          | Flexible use (CI/CD, mirrors) | Optional      | Deployments, mirrors, CI pipelines |

---

### ✅ Best Practices

* 🧭 Always name your fork’s remote `origin` and the main project `upstream` — it’s a community convention.
* 🔄 Regularly sync your fork:

  ```bash
  git fetch upstream
  git rebase upstream/main
  git push origin main
  ```
* 🚫 Don’t push directly to `upstream` unless you’re a maintainer.
* 💾 For safety, set `upstream` as fetch-only:

  ```bash
  git remote set-url --push upstream no_push
  ```
* 🧰 Automate syncing in CI/CD if your fork mirrors the upstream project.

---

### 💡 In short

* 🏠 **`origin` = your repo (you push here)**
* 🌍 **`upstream` = source repo (you pull from here)**
  Used together to keep forks and originals in sync — **fetch from upstream, push to origin.** ✅

---
---

## Q: How do you enforce code reviews and branch protection?

### 🧠 Overview

Enforce reviews and protect branches by combining **repository branch-protection rules**, **required CI/status checks**, **CODEOWNERS**, and **approval rules** (GitHub/GitLab). Automate enforcement in CI and block direct pushes to protected branches so merges only happen via approved pull/merge requests.

---

### ⚙️ Examples / Commands

#### 1) GitHub — quick UI checklist (manual)

1. Repo → Settings → Branches → Add rule.
2. Fill **Branch name pattern** (e.g., `main`, `release/*`).
3. Enable: `Require pull request reviews before merging`, `Require status checks to pass`, `Require review from Code Owners`, `Require linear history`, `Include administrators` (optional).
4. Save.

#### 2) GitHub — `gh` CLI (create branch protection rule)

```bash
# Example: require PR reviews + status checks (using REST via gh api)
gh api \
  -X PUT /repos/:owner/:repo/branches/main/protection \
  -f required_status_checks='{"strict":true,"contexts":["ci/build","ci/test"]}' \
  -f required_pull_request_reviews='{"dismiss_stale_reviews":true,"required_approving_review_count":2}' \
  -f enforce_admins=true
```

#### 3) GitHub — CODEOWNERS (require owner reviews)

Create `.github/CODEOWNERS`:

```text
# .github/CODEOWNERS
# Require review from backend-team for src/backend/**
src/backend/ @org/backend-team
docs/ @org/docs-team
```

Commit and push — enable *Require review from Code Owners* in branch-protection.

#### 4) GitHub Actions — make check names match protection contexts

```yaml
# .github/workflows/ci.yml
name: ci/build
on: [push, pull_request]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run tests
        run: pytest -q
```

Use `name: ci/build` so branch protection references `ci/build` as a required status check.

#### 5) GitLab — protected branches & approval rules (UI & CLI)

UI: Project → Settings → Repository → Protected branches → Protect branch (choose role restrictions).
Example with approvals:

```bash
# GitLab API: add approval rule (curl example)
curl --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
  -X POST "https://gitlab.com/api/v4/projects/:id/approval_rules" \
  -d "name=Security Review" \
  -d "approvals_required=1" \
  -d "user_ids[]=123"
```

#### 6) Prevent direct pushes (server-side / pre-receive)

* Use Git host branch protection (recommended).
* For self-hosted Git, configure **pre-receive hooks** to reject non-PR pushes to `main`:

```bash
#!/bin/bash
# pre-receive hook: reject direct pushes to main
while read oldrev newrev refname; do
  branch=${refname#refs/heads/}
  if [ "$branch" = "main" ]; then
    echo "Direct pushes to main are disabled. Create a PR."
    exit 1
  fi
done
exit 0
```

---

### 📋 Quick Rules / Table

|             Capability |                GitHub               |          GitLab          |    Self-hosted Git    |
| ---------------------: | :---------------------------------: | :----------------------: | :-------------------: |
|   Require PR approvals |       ✅ Branch protection rule      |     ✅ Approval rules     |   ✅ Pre-receive hook  |
|      Require CI checks |       ✅ Required status checks      |  ✅ Pipeline must succeed | ✅ Integrate CI + hook |
|     Require CODEOWNERS | ✅ `.github/CODEOWNERS` + protection | ✅ `CODEOWNERS` supported |  ✅ Custom enforcement |
| Enforce signed commits |      ✅ `Require signed commits`     |       ✅ Push rules       |   ✅ Server-side hook  |
|    Disallow force-push |       ✅ `prevent force pushes`      |  ✅ protect branch option |   ✅ pre-receive hook  |

---

### ✅ Best Practices

* 🔒 **Protect main/release branches**: require PRs, ≥1-2 approvals, and passing CI.
* 🧭 **Use CODEOWNERS** for automatic reviewer assignment and require code-owner reviews.
* 🧪 **Require named CI status checks** (match the exact workflow/job names) and set `strict` to prevent merging when branch is behind.
* 🧾 **Deny force-pushes** and enable `Include administrators` only if you want admins bound by the same rules.
* 🔐 **Require signed commits** and/or enforce conventional commits if you use automated changelogs.
* 🧰 **Enforce small PRs** (<= X files / lines) in CI to keep reviews fast. Example check: fail PR if >500 LOC changed.
* ♻️ **Auto-merge only after all checks & approvals**: use platform auto-merge (merge when pipeline succeeds).
* 📣 **Document the policy** in `CONTRIBUTING.md` and add PR templates to remind contributors.
* 🧪 **Test enforcement in a staging repo** before applying to production repos.
* 🧾 **Audit & alert**: enable audit logs for branch-protection changes and notify Slack/Teams for config changes.

---

### ⚙️ Practical snippets

**PR template (`.github/PULL_REQUEST_TEMPLATE.md`)**

```markdown
## What/Why
- Summary of change

## Checklist
- [ ] Tests added/updated
- [ ] Code owner review requested (if applicable)
- [ ] CI ✅
```

**Enforce minimal approvals in CI (example script)**

```bash
# script/require-approvals.sh
PR_ID=$1
# Use GitHub API to count approvals (example)
approvals=$(gh api repos/:owner/:repo/pulls/$PR_ID/reviews --jq 'map(select(.state=="APPROVED")) | length')
if [ "$approvals" -lt 1 ]; then
  echo "Not enough approvals: $approvals"
  exit 1
fi
```

---

### 💡 In short

Enforce code reviews and branch protection by combining **branch protection rules** (block direct pushes), **required CI/status checks**, **CODEOWNERS**, and **approval rules**. Automate with `gh`/API, CI checks, and pre-receive hooks for self-hosted setups — document the policy and audit changes. ✅

---
---

## 🧭 **Git Commands Summary (Quick Reference Guide)**

A concise, DevOps-friendly cheat sheet for daily Git operations — ideal for CI/CD, troubleshooting, and interviews.

---

| 🧩 **Action**                         | ⚙️ **Command**                               | 💡 **Description / Notes**                                |
| ------------------------------------- | -------------------------------------------- | --------------------------------------------------------- |
| **Initialize repo**                   | `git init`                                   | Create a new Git repository in the current directory.     |
| **Clone repo**                        | `git clone <url>`                            | Download an existing repository to your local system.     |
| **Add file(s)**                       | `git add <file>`                             | Stage file(s) for the next commit. Use `.` for all.       |
| **Commit changes**                    | `git commit -m "message"`                    | Save staged changes with a message.                       |
| **Push changes**                      | `git push origin <branch>`                   | Upload commits to remote branch (e.g., `main`).           |
| **Pull updates**                      | `git pull origin <branch>`                   | Fetch + merge remote branch into local.                   |
| **Fetch only**                        | `git fetch origin`                           | Download commits without merging.                         |
| **Create branch**                     | `git checkout -b feature/new`                | Create and switch to a new branch.                        |
| **Switch branch**                     | `git switch <branch>`                        | Move between branches.                                    |
| **Merge branch**                      | `git merge feature/new`                      | Merge specified branch into current one.                  |
| **Rebase branch**                     | `git rebase main`                            | Replay commits on top of another branch. Cleaner history. |
| **Delete branch (local)**             | `git branch -d feature/new`                  | Delete a local branch (safe delete).                      |
| **Delete branch (remote)**            | `git push origin --delete feature/new`       | Remove a branch from remote.                              |
| **View branches**                     | `git branch -a`                              | List all local and remote branches.                       |
| **View history**                      | `git log --oneline --graph --decorate --all` | Compact, visual commit history.                           |
| **Show changes (diff)**               | `git diff`                                   | Compare working directory vs. staged changes.             |
| **Show staged diff**                  | `git diff --cached`                          | Compare staged vs. last commit.                           |
| **View status**                       | `git status`                                 | See tracked/untracked files and staging status.           |
| **Undo staged file**                  | `git restore --staged <file>`                | Unstage file (keep changes).                              |
| **Discard local changes**             | `git restore <file>`                         | Revert file to last committed state.                      |
| **Undo last commit (keep changes)**   | `git reset --soft HEAD~1`                    | Moves HEAD back by one commit, keeps files.               |
| **Undo last commit (remove changes)** | `git reset --hard HEAD~1`                    | Deletes last commit and changes.                          |
| **Stash changes**                     | `git stash push -m "temp work"`              | Save uncommitted changes temporarily.                     |
| **Apply stash**                       | `git stash pop`                              | Reapply and remove latest stash.                          |
| **List stashes**                      | `git stash list`                             | View saved stashes.                                       |
| **Tag a release**                     | `git tag -a v1.0 -m "Release 1.0"`           | Create annotated tag for a version.                       |
| **Push tags**                         | `git push origin --tags`                     | Upload tags to remote.                                    |
| **View remote URLs**                  | `git remote -v`                              | Show fetch/push URLs for all remotes.                     |
| **Add remote**                        | `git remote add origin <url>`                | Link local repo to remote.                                |
| **Rename remote**                     | `git remote rename origin upstream`          | Rename a remote.                                          |
| **Revert a commit safely**            | `git revert <commit-sha>`                    | Undo commit by adding a new inverse commit.               |
| **Find bug commit**                   | `git bisect start`                           | Start binary search for buggy commit.                     |
| **Squash commits**                    | `git rebase -i HEAD~N`                       | Combine multiple commits into one.                        |
| **Check blame**                       | `git blame <file>`                           | See who last modified each line.                          |
| **Show file history**                 | `git log -p <file>`                          | See commit-by-commit changes to a file.                   |

---

### ⚡️ **Pro Tips for CI/CD & Collaboration**

* 🧠 Use `git fetch --prune` to remove deleted remote branches.
* 🧩 Use `git pull --rebase` to avoid unnecessary merge commits.
* 🔒 Protect `main`/`master` with branch protection and required reviews.
* 🧰 Clean local clutter:

  ```bash
  git branch --merged | grep -v main | xargs git branch -d
  ```
* 🧾 Track credentials securely via **Git Credential Manager** or CI secrets.
* 🌍 Always configure identity:

  ```bash
  git config --global user.name "Vasu"
  git config --global user.email "vasu@example.com"
  ```

---

### 💡 In short

| Goal                   | Recommended Command                              |
| ---------------------- | ------------------------------------------------ |
| Undo safely            | `git revert <sha>`                               |
| Clean history          | `git rebase -i HEAD~N`                           |
| Sync with main         | `git fetch upstream && git rebase upstream/main` |
| Temporary save         | `git stash push`                                 |
| Track changes visually | `git log --oneline --graph --decorate --all`     |

---

✅ **Keep your Git workflow clean, traceable, and CI-friendly.**
Ideal for interviews, production pipelines, and version-controlled infrastructure (Terraform, Helm, CDK, etc.).

---
# Scenario Based Questions

---

## Q: Accidentally committed a secret key

### 🧠 Overview

If a secret (API key, private key, token, password) was committed — **assume it’s compromised**. First **rotate/revoke** the secret immediately, then **remove** it from Git history, update CI/secret stores, and communicate the incident. Do **not** rely on history-cleaning alone — rotate first.

---

### ⚙️ Step-by-step Response (practical, ordered)

1. ✅ **Rotate / Revoke the secret (FIRST & FAST)**

   * Immediately revoke the leaked credential in the provider (AWS, GitHub, GCP, DB, third-party).
   * Create a replacement secret and update any services that used the old key.

```bash
# Example: AWS IAM - create new access key (one-liner returns JSON)
aws iam create-access-key --user-name deploy-user

# Example: AWS IAM - disable & delete old key
aws iam update-access-key --access-key-id AKIAOLD... --status Inactive --user-name deploy-user
aws iam delete-access-key --access-key-id AKIAOLD... --user-name deploy-user
```

> 🛑 **Do this before you try to clean Git history.** Cleaning alone doesn't stop abuse.

---

2. 🔍 **Find all occurrences in repo & history**

* Search working tree and history for obvious secrets:

```bash
# Search working tree
grep -RIn "AKIA\|SECRET\|password" .

# Search commit history for string (cheap)
git log --all -S 'my-secret-substring' --pretty=format:'%h %an %ad %s'
```

* Use specialized scanners (locally / CI): `git-secrets`, `detect-secrets`, `truffleHog`, `gitleaks`.

```bash
# Example: run detect-secrets scan
detect-secrets scan > .secrets.baseline
detect-secrets audit .secrets.baseline
```

---

3. 🧹 **Remove secret from current tree (temporary quick step)**

> This *does not* remove it from history — it prevents future pulls from immediately seeing it.

```bash
# Remove file and commit (if secret is in a file)
git rm --cached path/to/secret.file
echo "path/to/secret.file" >> .gitignore
git add .gitignore
git commit -m "Remove leaked secret and add to .gitignore"
git push origin main
```

---

4. 🧨 **Permanently remove secret from Git history**
   Choose one: **git-filter-repo** (recommended), **BFG** (easy), or `git filter-branch` (legacy). These rewrite history — coordinate with the team.

#### Using `git-filter-repo` (recommended)

```bash
# 1. Mirror clone (safer)
git clone --mirror git@github.com:org/repo.git repo.git
cd repo.git

# 2. Remove a file from entire history
git filter-repo --path path/to/secret.file --invert-paths

# OR replace secret values (replacements.txt format: literal==>replacement)
# replacements.txt example content:
# AKIAEXAMPLE==>REMOVED_BY_FILTER_REPO
git filter-repo --replace-text ../replacements.txt

# 3. Push cleaned repo back (force)
git push --force --mirror origin
```

#### Using **BFG Repo-Cleaner**

```bash
# Mirror clone
git clone --mirror git@github.com:org/repo.git
cd repo.git

# Delete files (or use --replace-text)
java -jar bfg.jar --delete-files secret.txt
# or to replace secrets listed in passwords.txt
java -jar bfg.jar --replace-text ../passwords.txt

# Cleanup and push
git reflog expire --expire=now --all && git gc --prune=now --aggressive
git push --force --mirror origin
```

> ⚠️ After history rewrite: all collaborators must reclone or carefully `fetch` + reset. Communicate steps below.

---

5. 🔁 **Coordinate force-push fallout & recovery for collaborators**

* Announce rewrite to team (PR, Slack, ticket). Provide concrete steps.
* Recommended steps for each contributor (simplest: reclone):

```text
# Easiest & safest
rm -rf repo
git clone git@github.com:org/repo.git

# Or: rebase local branches on top of rewritten main (advanced)
git fetch origin
git checkout my-branch
git rebase --onto origin/main <old-base> my-branch
```

* If you must preserve forks, consider contacting fork owners or use `git filter-repo --replace-refs` strategies.

---

6. 🔐 **Replace secrets with secure secret management**

* Move secrets to: AWS Secrets Manager, HashiCorp Vault, GCP Secret Manager, or GitHub Actions Secrets / GitLab CI variables.
* Update CI/CD to read secrets from those stores, not from repo files.

```bash
# Example: GitHub Actions - set secret via gh CLI
gh secret set PROD_DB_PASSWORD --body "$PROD_DB_PASSWORD"
```

---

7. 🧪 **Validate pipelines & repos after cleaning**

* Run CI builds, smoke tests, and deploy to a staging environment with new credentials.
* Re-run secret scanners to confirm absence:

```bash
gitleaks detect
trufflehog --repo-path=. filesystem
```

---

8. 📣 **Incident response & communication**

* Create an incident ticket (Jira/Ticketing) with timeline, secret type, scope, rotated keys, and remediation steps.
* Notify security/ops and any external provider if required (e.g., notify third-party if token abused).
* Audit logs where possible (CloudTrail, Git server logs) for suspicious use of leaked secret.

---

### 📋 Quick Decision Table

| Action                            |             Do it now?             | Reason                                  |
| --------------------------------- | :--------------------------------: | --------------------------------------- |
| Rotate/revoke leaked key          |            ✅ Immediately           | Stops active misuse                     |
| Remove from repo (commit)         |           ✅ After rotate           | Prevent future checkouts but not enough |
| Rewrite history (filter-repo/BFG) | ✅ After rotate & team coordination | Removes secret from history             |
| Force-push rewritten history      |      ✅ Only after coordination     | Required to update remote               |
| Scan repo + forks                 |                  ✅                 | Ensure no other exposure                |
| Move secrets to secret manager    |                  ✅                 | Long-term solution                      |
| Inform stakeholders               |                  ✅                 | Compliance & security tracking          |

---

### ✅ Best Practices (prevent recurrence)

* Use secret scanning in CI (Gitleaks, truffleHog, GitHub secret scanning).
* Enforce pre-commit hooks: `detect-secrets`, `git-secrets`.
* Store credentials in secret stores (Vault, Secrets Manager) and environment variables in CI.
* Add a `SECURITY.md` & `CONTRIBUTING.md` with handling rules for secrets.
* Educate devs: never hardcode creds, use templates with placeholders.
* Use short-lived credentials and RBAC: least privilege for keys.
* Automate rotation where possible.

---

### 💡 In short

1. **Rotate/revoke the key immediately.**
2. **Search** for all exposures.
3. **Remove from repo** and **rewrite history** (git-filter-repo/BFG) and `--force-with-lease` push.
4. **Update CI/secret store** to use new secrets and scan again.
5. **Communicate** and document the incident. ✅

---

If you tell me the type of secret (AWS access key, GitHub token, private SSH key, DB password), I can give the exact provider-specific revoke/rotate commands and an example `git-filter-repo` replacements file you can run immediately.

---
---

## Q: How to Sync a Forked Repo with Upstream Changes

### 🧠 Overview

When you fork a repo (e.g., from an open-source project), your fork can fall behind the **upstream** source.
Syncing ensures your fork’s `main` (or `master`) matches the latest upstream commits — while keeping your branches clean and conflict-free.

---

### ⚙️ Step-by-Step Commands

#### 1️⃣ Add upstream remote (only once)

```bash
# Verify current remotes
git remote -v

# Add the original source repo as 'upstream'
git remote add upstream https://github.com/original-org/project.git

# Verify
git remote -v
```

Example output:

```
origin    https://github.com/vasu/my-fork.git (fetch)
upstream  https://github.com/original-org/project.git (fetch)
```

---

#### 2️⃣ Fetch latest upstream changes

```bash
git fetch upstream
```

This downloads branches and tags from the upstream repo, but doesn’t merge yet.

---

#### 3️⃣ Checkout your fork’s main branch

```bash
git checkout main
```

---

#### 4️⃣ Merge or rebase upstream changes

**Option A: Merge (safer, preserves history)**

```bash
git merge upstream/main
```

**Option B: Rebase (cleaner history)**

```bash
git rebase upstream/main
```

If conflicts occur:

```bash
# Fix conflicts, then continue
git add <resolved-files>
git rebase --continue
```

---

#### 5️⃣ Push the updated main branch to your fork

```bash
git push origin main
```

Now your fork’s `main` matches the upstream repo.

---

#### 6️⃣ Sync other branches (optional)

```bash
# Rebase your feature branch onto updated main
git checkout feature/api
git rebase main
git push origin feature/api --force-with-lease
```

---

### ⚙️ Automate Sync with GitHub CLI (easy mode)

```bash
# Ensure gh CLI is installed & authenticated
gh repo sync vasu/my-fork --source upstream --branch main
```

✅ This pulls from upstream and pushes to your fork’s origin automatically.

---

### 🧩 Example Workflow Summary

```bash
# One-time setup
git remote add upstream https://github.com/original-org/project.git

# Regular sync steps
git fetch upstream
git checkout main
git rebase upstream/main   # or merge
git push origin main
```

---

### 📋 Quick Reference Table

| Action              | Command                                               | Purpose                             |
| ------------------- | ----------------------------------------------------- | ----------------------------------- |
| Add upstream remote | `git remote add upstream <url>`                       | Link your fork to the original repo |
| Fetch changes       | `git fetch upstream`                                  | Download latest commits             |
| Merge               | `git merge upstream/main`                             | Preserve both histories             |
| Rebase              | `git rebase upstream/main`                            | Linear, cleaner commit history      |
| Push fork update    | `git push origin main`                                | Sync forked repo on GitHub          |
| Auto sync           | `gh repo sync <fork> --source upstream --branch main` | Simplified GitHub CLI sync          |

---

### ✅ Best Practices

* 🔄 **Rebase over merge** for cleaner, linear history (preferred for feature branches).
* 🧩 Sync regularly — before starting new work or opening PRs.
* 🚫 Avoid force-push on shared branches unless you own the fork alone.
* 🧪 Always verify CI passes after syncing upstream.
* 📦 For CI/CD forks, automate sync using a scheduled GitHub Action:

```yaml
# .github/workflows/sync.yml
name: Sync Fork
on:
  schedule:
    - cron: "0 6 * * *"   # Daily at 6 AM
jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Sync from upstream
        run: gh repo sync vasu/my-fork --source upstream --branch main
```

---

### 💡 In short

**Add upstream → fetch → rebase/merge → push.**
That’s how you keep your fork aligned with the source project — clean, conflict-free, and CI-ready. ✅

---
---

## Q: Want to revert a deployment commit in CI

### 🧠 Overview

If a deployed commit is bad, **revert the commit in Git (safe)** or **trigger an environment rollback** (Kubernetes/Helm/Cloud provider). Prefer `git revert` + CI-driven deploy of the revert, or use your platform’s built-in rollback (faster). Always rotate secrets, run tests, and notify stakeholders.

---

### ⚙️ Quick decision flow

1. **Is the bug code-only and CI can redeploy automatically?** → `git revert` → push → CI deploys revert.
2. **Do you need instant rollback at runtime?** → Use platform rollback (kubectl/helm/CodeDeploy).
3. **Was the commit already pushed/merged to main?** → Always use `git revert` (safe, non-history-rewriting).

---

### 🔁 Option A — Safe Git revert (recommended for CI-driven deploys)

```bash
# 1. Find bad commit (sha)
git log --oneline --graph

# 2. Create revert commit (non-interactive for automation)
git revert --no-edit <bad-sha>

# 3. Push revert to remote
git push origin main

# 4. CI picks up push and deploys revert automatically
```

If the bad commit is a **merge commit**:

```bash
# find merge commit sha
git show --pretty=short <merge-sha>
# revert specifying parent (1 = main)
git revert -m 1 <merge-sha> --no-edit
git push origin main
```

**CI notes**

* Ensure branch-protection permits CI user to push/merge revert (use a PR if required).
* For automation, use `--no-edit` to skip editor.

---

### ⚙️ Option B — Create a revert PR (safer for protected branches)

```bash
# create a new branch with revert
git checkout -b revert/bad-deploy
git revert -m 1 <merge-sha> -m "Revert: cause <issue/id>"   # for merge commits
# or git revert <bad-sha>
git push origin revert/bad-deploy
# open PR → required approvals & CI run → merge to main → CI deploys
```

Use PR when branch protection / approvals / audits are required.

---

### 🔧 Option C — Runtime rollback (immediate recovery, platform-specific)

#### Kubernetes (Deployment)

```bash
# show revision history
kubectl rollout history deployment/my-app -n prod

# rollback to previous revision
kubectl rollout undo deployment/my-app -n prod

# check status
kubectl rollout status deployment/my-app -n prod
```

#### Helm

```bash
# list releases
helm history my-app -n prod

# rollback to release revision 3
helm rollback my-app 3 -n prod

# verify
kubectl get pods -n prod -l app=my-app
```

#### AWS CodeDeploy / EB / Lambda

* Use console or CLI to redeploy previous application revision or use saved artifact (S3) to re-deploy.

```bash
# Example: redeploy previous version for CodeDeploy (requires appSpec info)
aws deploy create-deployment --application-name MyApp \
  --deployment-group-name MyGroup \
  --s3-location bucket=my-bucket,key=artifacts/previous.zip,bundleType=zip
```

---

### 📋 Comparison Table

| Method                                   |  Speed | Auditability |  Risk  | When to use                                         |
| ---------------------------------------- | -----: | :----------: | :----: | --------------------------------------------------- |
| `git revert` → CI deploy                 | Medium |     High     |   Low  | Preferred for traceable, safe undo                  |
| Revert PR (protected branches)           |   Slow |   Very high  |   Low  | When approvals required                             |
| `kubectl rollout undo` / `helm rollback` |   Fast |    Medium    | Medium | Immediate recovery (config/state aware)             |
| `git reset` + force-push                 |   Fast |      Low     |  High  | Avoid on shared branches; only for private branches |

---

### ✅ Best Practices (practical)

* 🔁 **Prefer `git revert`** over history rewrite on shared branches. Use `--no-edit` in automation.
* 🧪 **Run smoke tests** in a staging environment before re-deploying or after rollback.
* 🏷️ **Tag release revisions** (`git tag`, Helm chart version, Kubernetes annotation) so rollbacks reference artifacts, not arbitrary commits.
* 🔐 **Ensure CI deploy user has minimal required perms**; use `--force-with-lease` only on private feature branches.
* 🧾 **Record incident**: commit SHA, rollback action, timeline, tests run, and author.
* 🔁 **Automate revert-deploy**: add a job in CI to create revert commit or trigger platform rollback via API.
* 📣 **Notify** stakeholders and open a postmortem if the incident is production-impacting.

---

### ⚙️ CI examples

#### GitHub Actions — auto-deploy on revert (simplified)

```yaml
name: Deploy
on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build & Deploy
        run: |
          ./scripts/build.sh
          ./scripts/deploy-prod.sh
```

Trigger: push of the revert commit will run this pipeline.

#### Jenkins pipeline snippet — create revert via job input

```groovy
pipeline {
  agent any
  parameters {
    string(name: 'BAD_SHA', defaultValue: '', description: 'Commit SHA to revert')
  }
  stages {
    stage('Revert commit') {
      steps {
        sh """
          git fetch origin
          git checkout main
          git revert --no-edit ${params.BAD_SHA}
          git push origin main
        """
      }
    }
  }
}
```

---

### 💡 Troubleshooting

* If `git revert` yields conflicts: resolve, `git add` then `git revert --continue`.
* If CI doesn’t deploy revert: check branch protection, CI trigger rules, and whether the revert commit changed protected files that block automation.
* If automated rollback fails: check image/artifact availability (use tagged artifacts for reproducible rollback).

---

### 💡 In short

* For traceable, safe undo: **`git revert <sha>` → push → CI deploys revert**. ✅
* For immediate runtime recovery: **`kubectl rollout undo`** or **`helm rollback`**, then follow up with a Git revert to keep history consistent. ⚡

---
---

## Q: Pushed the wrong branch to remote

### 🧠 Overview

If you pushed a wrong branch (or commits) to a remote, act based on **branch sensitivity**:

* If it’s a **protected/shared branch** (e.g., `main`) → **don’t force-rewrite**; revert safely.
* If it’s a **personal/feature branch** you own → you can remove or replace it (use `--force-with-lease` when rewriting).
  Always communicate and coordinate if others may be affected.

---

### ⚙️ Quick Actions (choose the one that fits)

#### A) You pushed a personal/feature branch by mistake and want to remove it

```bash
# Delete remote branch (explicit)
git push origin --delete wrong-branch

# Or older style
git push origin :wrong-branch
```

#### B) You pushed commits to your fork/feature branch and want to replace with local correct history

```bash
# Ensure local branch has the desired commits
git checkout correct-branch

# Force-push safely (use --force-with-lease)
git push --force-with-lease origin correct-branch
```

#### C) You accidentally pushed to a protected/shared branch (e.g., main)

Do **NOT** force-push. Instead **revert** the bad commit(s) so history stays intact:

```bash
# Find the bad commit
git log --oneline

# Revert a specific commit (creates a new commit that undoes it)
git revert <bad-sha> --no-edit

# Push revert (CI will redeploy if configured)
git push origin main
```

If multiple commits: `git revert <sha1>..<shaN>` or revert range carefully (Git will create a revert commit per commit).

#### D) You pushed the wrong branch but want to rename remote branch to correct name

```bash
# Push local branch as a new remote branch name
git push origin local-branch:correct-remote-branch

# Delete the old wrong remote name
git push origin --delete wrong-branch
```

#### E) You need to recover a deleted remote branch (someone deleted it)

```bash
# Get the last commit SHA (from reflog, other clones, or CI artifact)
# Recreate branch locally
git checkout -b wrong-branch <last-known-sha>
git push origin wrong-branch
```

---

### 📋 Decision / Action Table

|                          Situation | Action                                                                                         |
| ---------------------------------: | :--------------------------------------------------------------------------------------------- |
|       Wrong personal branch pushed | Delete remote (`git push --delete`) or force-replace (`--force-with-lease`)                    |
|          Wrong commits on **main** | `git revert <sha>` → push (safe)                                                               |
|       Need to rename remote branch | `git push origin local:remote` + delete old remote                                             |
| Sensitive data accidentally pushed | Rotate secrets immediately, then clean history (git-filter-repo/BFG) and coordinate force-push |
|               Team may have pulled | Communicate & ask teammates to `git fetch` and rebase or reclone as needed                     |

---

### ✅ Best Practices & Safety Tips

* 🔐 **Never use `--force` blindly** on shared branches. Prefer `--force-with-lease`.

  ```bash
  git push --force-with-lease origin feature/branch
  ```
* 🧾 **Communicate**: post the incident in Slack/PR/issue with required actions for collaborators.
* 🔁 **If history rewritten**, ask collaborators to reclone or run:

  ```bash
  git fetch origin
  git checkout their-branch
  git rebase --onto origin/main <old-base> their-branch
  ```

  (Or simply `git clone` fresh to avoid mistakes.)
* 🧪 **Run CI** and smoke tests after pushing corrections.
* ⚠️ **If secrets were pushed**, rotate the secret immediately before any history cleanup.
* 🗂️ **Protect important branches** with branch protection rules to block accidental pushes.
* 📦 **Prefer PRs** for merges to protected branches; disable direct pushes where possible.

---

### ⚙️ Example workflows

**Remove wrong remote branch and push correct branch**

```bash
# delete wrong remote branch
git push origin --delete wrong-branch

# push correct local branch to remote
git checkout correct-branch
git push origin correct-branch
```

**Safe replace of your remote feature branch with local version**

```bash
# ensure local branch has desired state
git checkout feature/fix
git fetch origin
# push using lease to avoid accidentally stomping remote changes
git push --force-with-lease origin feature/fix
```

**Revert changes pushed to main (safe, recommended)**

```bash
# revert commit on main
git checkout main
git pull origin main
git revert --no-edit <bad-commit-sha>
git push origin main
```

---

### 💡 In short

If it’s a **shared/protected branch** → **revert** the bad commit and push.
If it’s your **own feature branch** → **delete or force-replace** the remote branch (`--force-with-lease`).
Always **communicate**, **run CI**, and **rotate secrets** if any sensitive data was pushed. ✅

---
---

## Q: Conflict during rebase

### 🧠 Overview

During a `git rebase`, Git reapplies commits one-by-one and may stop when changes clash with the base — that’s a **rebase conflict**. Resolve by inspecting conflicting files, choosing the correct content (ours/theirs), staging the resolution, then `git rebase --continue`. If things go wrong, `git rebase --abort` returns you to the pre-rebase state.

---

### ⚙️ Common Commands & Step-by-step Resolution

#### 1) Rebase started and hit a conflict

```bash
git rebase origin/main
# Rebase stops with conflict message
# Check status to see conflicted files
git status
```

#### 2) Inspect conflicts

```bash
# See conflict markers in files
less path/to/conflicted-file

# Show exactly conflicted hunks
git diff
```

#### 3) Resolve manually (edit file, remove markers), then:

```bash
git add path/to/conflicted-file
git rebase --continue
```

#### 4) Useful helpers

```bash
# Use mergetool (configured tool like meld, vimdiff, kdiff3)
git mergetool
# After resolving:
git add <file>
git rebase --continue

# If you want to skip applying the current patch entirely
git rebase --skip

# Abort rebase and return to original branch state
git rebase --abort
```

#### 5) Take one side wholesale

```bash
# Keep your branch's version (ours)
git checkout --ours -- path/to/file
git add path/to/file
git rebase --continue

# Take the base/upstream version (theirs)
git checkout --theirs -- path/to/file
git add path/to/file
git rebase --continue
```

> Note: during a rebase, **ours** = the branch you are rebasing onto? (behavior differs vs merge). Use `git status` to be safe and test in a small example if unsure.

#### 6) Automate repetitive conflict resolutions

```bash
# Enable reuse recorded resolutions (saves time if same conflicts reappear)
git config --global rerere.enabled true

# For interactive rebases where you want strategy favoring theirs:
git rebase -X theirs origin/main
# or
git rebase -s recursive -X theirs origin/main
```

#### 7) If you get stuck or want a safe fallback

```bash
# Abort and return to original branch state
git rebase --abort

# Or, save current work and start over
git stash push -m "pre-rebase-work"
git rebase origin/main
git stash pop
```

#### 8) Recover if history got messy

```bash
# Find your previous HEAD
git reflog

# Restore to a safe ref (example)
git reset --hard HEAD@{5}
```

---

### 📋 Quick Troubleshooting Table

| Symptom                     | Command / Action                                                     |
| --------------------------- | -------------------------------------------------------------------- |
| See which files conflict    | `git status`                                                         |
| View conflict details       | `git diff` or open file to inspect markers `<<<<<<<`                 |
| Use GUI merge tool          | `git mergetool`                                                      |
| Keep branch changes (ours)  | `git checkout --ours <file>` → `git add` → `git rebase --continue`   |
| Keep base/upstream (theirs) | `git checkout --theirs <file>` → `git add` → `git rebase --continue` |
| Skip current patch          | `git rebase --skip`                                                  |
| Abort rebase entirely       | `git rebase --abort`                                                 |
| Avoid repeat conflict pain  | `git config --global rerere.enabled true`                            |
| Favor theirs automatically  | `git rebase -X theirs <upstream>` *(use cautiously)*                 |

---

### ✅ Best Practices (practical & production-ready)

* 🧾 **Create a backup branch** before rebasing:

  ```bash
  git branch backup/my-branch-before-rebase
  ```
* 🔄 **Rebase frequently** on small sets of commits to reduce conflict surface.
* 🔁 Use `git rebase --autostash` when your local working tree has changes:

  ```bash
  git rebase --autostash origin/main
  ```
* 🧹 **Enable `rerere`** to auto-apply recorded resolutions for repeated conflicts.
* 🧪 Test locally after `git rebase --continue` — run unit/smoke tests before pushing.
* 🔒 On shared branches, prefer merging in production branches; rebase only on private/topic branches.
* 🧰 Use `--force-with-lease` if you must update remote after rewriting history, to avoid stomping others:

  ```bash
  git push --force-with-lease origin feature/branch
  ```
* 📣 **Communicate** to teammates if you rewrite history (announce and provide recovery steps).

---

### 💡 In short

When a rebase conflicts: inspect files (`git status`, `git diff`), resolve conflicts manually or with `git mergetool`, `git add` resolved files, then `git rebase --continue`. Use `git rebase --abort` to back out. Prefer small, frequent rebases, enable `rerere`, and always backup before rewriting history. ✅

---
