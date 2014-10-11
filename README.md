git-deploy
==========

Git helpers for application deployment

## Usages

##### Push the current branch to a remote repository.

```
sh deploy.sh
```

##### Merge the current branch into the `target` and push both to a remote repository.

```
sh deploy.sh target
```

##### Merge the `source` branch into the `target` and push both to a remote repository.

```
sh deploy.sh target source
```
----
Each command also merge `origin/master` into the `source` and/or `target` branch so you will have your branch up to date with production state.
