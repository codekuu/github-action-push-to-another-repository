# github-action-push-to-another-repository

Inspiration and majority of the code came from https://github.com/cpina/github-action-push-to-another-repository/.
Customized it to be more suitable for going around the limit of 1 Cloudflare pages connection to a repository.
You can use this action to push test/staging/development branch in a production repository to a test/staging/development repository and connect cloudflare pages. 

There are different variables to setup the behaviour:

## Inputs

### `destination-github-username` (argument)
For the repository `https://github.com/codekuu/github-action-push-to-another-repository` is `codekuu`.

### `destination-repository-name` (argument)
For the repository `https://github.com/codekuu/github-action-push-to-another-repository` is `github-action-push-to-another-repository`

*Warning:* this Github Action currently deletes all the files and directories in the destination repository. The idea is to copy from an `output` directory into the `destination-repository-name` having a copy without any previous files there.

### `user-email` (argument)
The email that will be used for the commit in the destination-repository-name.

### `user-name` (argument) [optional]
The name that will be used for the commit in the destination-repository-name. If not specified, the `destination-github-username` will be used instead.

### `destination-repository-username` (argument) [optional]
The Username/Organization for the destination repository, if different from `destination-github-username`. For the repository `https://github.com/codekuu/github-action-push-to-another-repository` is `codekuu`.

### `target-branch` (argument) [optional]
The branch name for the destination repository. It defaults to `main`.

### `commit-message` (argument) [optional]
The commit message to be used in the output repository. Optional and defaults to "Update from $REPOSITORY_URL@commit".

The string `ORIGIN_COMMIT` is replaced by `$REPOSITORY_URL@commit`.

### `target-directory` (argument) [optional]
The directory to wipe and replace in the target repository.  Defaults to wiping the entire repository

### `API_TOKEN_GITHUB` (environment)
E.g.:
  `API_TOKEN_GITHUB: ${{ secrets.API_TOKEN_GITHUB }}`

Generate your personal token following the steps:
* Go to the Github Settings (on the right hand side on the profile picture)
* On the left hand side pane click on "Developer Settings"
* Click on "Personal Access Tokens" (also available at https://github.com/settings/tokens)
* Generate a new token, choose "Repo". Copy the token.

Then make the token available to the Github Action following the steps:
* Go to the Github page for the repository that you push from, click on "Settings"
* On the left hand side pane click on "Secrets"
* Click on "Add a new secret" and name it "API_TOKEN_GITHUB"

## Example usage
```yaml
      - name: Pushes to another repository
        uses: codekuu/github-action-push-to-another-repository@main
        env:
          API_TOKEN_GITHUB: ${{ secrets.API_TOKEN_GITHUB }}
        with:
          destination-github-username: 'codekuu'
          destination-repository-name: 'pandoc-test-output'
          user-email: carles3@pina.cat
          target-branch: main
```

