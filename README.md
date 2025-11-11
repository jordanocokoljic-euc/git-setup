# git-setup

A small script that sets Git, Github, and 1Password up for working at Eucalyptus.

It requires that [Git (`git`)](https://git-scm.com/), the [GitHub CLI (`gh`)](https://cli.github.com/),
and the [1Password CLI (`op`)](https://developer.1password.com/docs/cli/) are
installed. If these are not installed, then the script will prompt you to
install them with [Homebrew (`brew`)](https://brew.sh/).

You don't need to have authenticated with `gh`, as the script will prompt you
with the appropriate options to ensure it can operate.

## Usage
You can clone and execute, or you can:

```sh
curl -s https://raw.githubusercontent.com/jordanocokoljic-euc/git-setup/refs/heads/main/setup.sh | sh
```
