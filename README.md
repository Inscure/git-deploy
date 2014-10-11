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
sh deploy.sh target_branch
```

##### Merge the `source` branch into the `target` and push both to a remote repository.

```
sh deploy.sh target source

