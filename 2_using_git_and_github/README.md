# Using git and GitHub
Git and github allow easy sharing of code with others in research.

## git

### Branches
Changes in a repo as branchers in a tree. Multiple branches can be made from the main branch.

<img src=docs/git_branches.png width="50%"></img>

> Here the `master` branch on `My Computer` has changes diverged from `origin/master` `git.outcompany.com`. These need to resolved before merging.

Make a new branch with your name.
```bash
git checkout -b $USER
```

### Making changes
Changes can be made by modifying text in a git repository.

`git` can tell you what changes you have done since a previous commit.

The status of the repo.
```bash
git status
```

```
On branch main
Your branch is up to date with 'origin/main'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        new file:   0_getting_started/README.md
        new file:   0_getting_started/images/github.png
        new file:   0_getting_started/images/ssh_key.png
        new file:   0_getting_started/images/user_settings.png
        new file:   1_using_git_and_github/README.md
        new file:   1_using_git_and_github/docs/git_branches.png
        modified:   README.md

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   0_getting_started/README.md
        modified:   1_using_git_and_github/README.md
        modified:   README.md

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        0_getting_started/images/fork.png
```
> My `git status` output as I'm writing this.

Let's add your name to the `README.md` as an exercise.

Using nano, vim, or whatever text editor you'd like, add your name under the __Completed by__ section.
```bash
nano README.md
# vim README.md
```

### Storing changes
Now that those changes have been made, we can commit them to your branch.
```bash
git add README.md
```

Then commit those changes and add a useful message. This is important as it's much easier to check a commit message than search through many lines of code.
```bash
git commit -m "Added my name to README."
```

### Pushing changes
After commiting your changes, you can push your local branch to your remote.
```bash
git push -u origin main
```

## GitHub

### Pull request
Finally, we'll open a pull-request (PR) to merge those changes into the main branch.

![](docs/pr.png)
![](docs/pr_changes.png)

Congrats! What you've just done is the core workflow of open-source software development!

In short, we've:
* Created a fork of an existing repository.
* Created a new branch.
* Made some changes.
* Opened a pull-request to merge our changes.
    * Typically, you should open an issue addressing the issue/improvement you hope to fix/implement before you do this.
