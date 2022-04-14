#!/bin/sh -l

set -e  # if a command fails it stops the execution
set -u  # script fails if trying to access to an undefined variable

echo "[+] Action start"
DESTINATION_GITHUB_USERNAME="$1"
DESTINATION_REPOSITORY_NAME="$2"
GITHUB_SERVER="$3"
USER_EMAIL="$4"
USER_NAME="$5"
DESTINATION_REPOSITORY_USERNAME="$6"
TARGET_BRANCH="$7"
TARGET_DIRECTORY="${8}"

if [ -z "$DESTINATION_REPOSITORY_USERNAME" ]
then
	DESTINATION_REPOSITORY_USERNAME="$DESTINATION_GITHUB_USERNAME"
fi

if [ -z "$USER_NAME" ]
then
	USER_NAME="$DESTINATION_GITHUB_USERNAME"
fi

CLONE_DIR=$(mktemp -d)

echo "[+] Cloning destination git repository $DESTINATION_REPOSITORY_NAME to get the .git folder."
# Setup git
git config --global user.email "$USER_EMAIL"
git config --global user.name "$USER_NAME"

{
	git clone --single-branch --branch "$TARGET_BRANCH" "https://$USER_NAME:$API_TOKEN_GITHUB@$GITHUB_SERVER/$DESTINATION_REPOSITORY_USERNAME/$DESTINATION_REPOSITORY_NAME.git" "$CLONE_DIR"
} || {
	echo "::error::Could not clone the destination repository. Command:"
	echo "::error::git clone --single-branch --branch $TARGET_BRANCH https://$USER_NAME:the_api_token@$GITHUB_SERVER/$DESTINATION_REPOSITORY_USERNAME/$DESTINATION_REPOSITORY_NAME.git $CLONE_DIR"
	echo "::error::(Note that the USER_NAME and API_TOKEN is redacted by GitHub)"
	echo "::error::Please verify that the target repository exist AND that it contains the destination branch name, and is accesible by the API_TOKEN_GITHUB"
	exit 1

}

echo "[+] Removing the current .git folder."
rm -rf .git/

echo "[+] Copying the remote git folder to the current folder."
cp -r "$CLONE_DIR/.git" . 

echo "[+] Deleting .github to not get a loop of actions."
rm -rf .github

echo "[+] Deleting the cloned folder"
rm -rf "$CLONE_DIR"

echo "[+] Setting target repository as safe.directory (https://github.blog/2022-04-12-git-security-vulnerability-announced/)"
git config --global --add safe.directory /github/workspace

echo "[+] Adding git commit"
git add .

echo "[+] Committing everything with a standard message"
git commit -m "Committing stuff"

echo "[+] git status:"
git status

echo "[+] Pushing git commit"
# --set-upstream: sets de branch when pushing to a branch that does not exist
git push "https://$USER_NAME:$API_TOKEN_GITHUB@$GITHUB_SERVER/$DESTINATION_REPOSITORY_USERNAME/$DESTINATION_REPOSITORY_NAME.git" --set-upstream "$TARGET_BRANCH" --force
