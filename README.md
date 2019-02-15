# git-outline

**DISCLAIMER: this program is a work in progress and is subject to breaking changes**

`git-outline` is a shell script that recurses over directories and checks status of
the git repositories. It can be used to quickly ensure that all underlying
repositories are clean and synced.

# Testing
Enter `test` directory and run `make clean all run-fetch` to test the output of the
command on a set of test repositories. You can also run tests for a specific
group, for example `make clean loose run`. For more details please check
[Makefile](https://github.com/jakubstefanski/git-outline/blob/master/test/Makefile).
