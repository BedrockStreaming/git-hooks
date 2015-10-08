# m6web/git-hooks

Collection of hooks git used by M6Web tech team

## Check-coke.sh

[coke](https://github.com/M6Web/Coke) is designed to validate entire project.
For large project, with hight amont of files, coke execution could take several minutes.

In an other way, we want to check there is no code standard violation before put code update in git, and a way is to have a git pre-commit hook to execute coke.

To keep commit fast, but execute coke, the check-coke.sh will look for files to be commited and execute code standard check only on it.

#### Installation

Go in your project .git/hooks folder and edit (or create if not exists) a `pre-commit` file, made it executable (`chmod u+x pre-commit`), and add this line in the file:

```shell
#!/bin/bash

<path to this project clone>/check-coke.sh
```

## Check-composer.sh

This hooks check if composer.lock file change on git operation, and launch `composer install` command.

This allow to always work on last vendors versions defined in your project composer.lock, even if one of your teammate update the dependencies.

### Installation

Go in your project .git/hooks folder and edit (or create if not exists) theses files:
* `post-merge`
* `post-rewrite`
* `post-checkout`

Made it executable (`chmod u+x pre-commit`), and add this line in each file:

```shell
#!/bin/bash

<path to this project clone>/check-composer.sh
```
