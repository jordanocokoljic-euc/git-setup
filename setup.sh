#!/usr/bin/env sh

set -eu

prompt() {
  printf '%s ' "$1"
  if [ -r /dev/tty ]; then
    IFS= read -r "$2" < /dev/tty
  else
    IFS= read -r "$2" || true
  fi
}

if ! command -v op >/dev/null; then
  echo '"op" not found, please install with: brew install 1password-cli'
  exit 1
fi

if ! command -v gh >/dev/null; then
  echo '"gh" not found, please install with: brew install gh'
  exit 1
fi

if ! command -v git >/dev/null; then
  echo '"git" not found, please install with: brew install git'
  exit 1
fi

if ! gh auth status >/dev/null; then
  echo 'Please authenticate with GitHub: gh auth login --git-protocol ssh --hostname github.com --skip-ssh-key --web -s admin:public_key'
  exit 1
fi

git_name="$(id -F)"
git_email="$(id -un)@eucalyptus.vc"

echo "Press enter to use the value in brackets" 
prompt "Please enter your name [$git_name]:" set_name 
prompt "Please enter your email [$git_email]:" set_email

if [ -n "$set_name" ]; then git_name="$set_name"; fi
if [ -n "$set_email" ]; then git_email="$set_email"; fi

git config --global user.name "$git_name"
git config --global user.email "$git_email"

op item create --category ssh --title 'GitHub SSH Key' --vault 'Employee' >/dev/null
echo 'Created SSH Key in 1Password'

pub_key="$(op item get 'GitHub SSH Key' --fields 'public key')"
echo "$pub_key" | gh ssh-key add --title '1Password SSH Key' >/dev/null
echo 'Added SSH Key to GitHub'

echo "$git_email $pub_key" >> ~/.config/git/allowed_signers
git config --global gpg.format ssh
git config --global user.signingkey "$pub_key"
git config --global gpg.ssh.allowedSignersFile ~/.config/git/allowed_signers
git config --global gpg.ssh.program '/Applications/1Password.app/Contents/MacOS/op-ssh-sign'
git config --global commit.gpgsign true
echo 'Configured Git to use the SSH key for signing commits'

git config --global init.defaultBranch main

echo 'Please configure SSO for the 1Password SSH Key in GitHub to authorise it for use in the Eucalyptus organization: https://github.com/settings/keys'
echo 'Please check that SSH signing has been configured correctly: https://github.com/jordanocokoljic-euc/git-setup-check'
