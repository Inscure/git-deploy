git-deploy
==========

Bash script for better GIT application deployment.

## Installation

You can download this package as an ZIP archive or use Composer to install in your PHP project.

#### Composer

```
{
    "require": {
        "git-deploy/git-deploy": "1.0.0-beta.1"
    },
    "config": {
        "bin-dir": "bin"
    }
}
```

## Usages

You should run the script via GIT Bash or Unix terminal.

##### Push the current branch to a remote repository.

```
sh ./bin/deploy.sh
```

##### Merge the current branch into the `target` and push both to a remote repository.

```
sh ./bin/deploy.sh target
```

##### Merge the `source` branch into the `target` and push both to a remote repository.

```
sh ./bin/deploy.sh target source
```
----
Each command also merge `origin/master` into the `source` and/or `target` branch so you will have your branch up to date with production state.
