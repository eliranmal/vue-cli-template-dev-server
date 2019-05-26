# contributing guide

first of all, thank you for considering contributing to this project. you're awesome just for reading these words :purple_heart:

there are many ways to contribute, all are welcome; from improving the documentation, fixing bugs and submitting issues,
to writing new features, auditing code reviews and testing for platform support.


## house rules

as a contributor, you're expected generally what a human is (be respectful, considerate, etc.), but you also hold
other responsibilities:

- **be**ing **open minded** is a big part what *open* means when we talk about *open source*.  
**be welcoming** to newcomers and **encourage diverse** new contributors from all backgrounds.
diversity of approaches is what helps us grow :seedling:
- **own the code**. it's no one's and everyone's. 
- **be transparent** and create issues for any changes that you wish to make. discuss things openly and get community feedback.


## first time here?

if you're unsure where to begin, the [issues page][2] is a good place to start.
the ones labeled with <kbd>[good first issue][1]</kbd> are simpler ones, while issues labeled
<kbd>[help wanted][4]</kbd> typically require greater involvement and proficiency.

have your own ideas for a contribution? even better! just make sure your change has not been proposed yet (look through
open issues as well as pull-requests).

that's it, you're ready! feel free to reach for help, we all thrive through sharing :octocat:


## development workflow

1. create your own fork of the repository, and clone it locally.
1. on your forked repository, create a new branch off of the master branch, following the conventions [mentioned below][13].
1. make changes to the code. follow the conventions in the [code style][10] section.
1. commit your changes. please follow this [commit message style][11].
1. repeat previous two steps until you run out of coffee.
1. make new coffee.
1. repeat steps 3 through 6 until you're satisfied.
1. test your changes to ensure platform compatibility. currently only bsd/mac is supported, but POSIX-compatible
implementations are generally preferred.
1. [open a pull request][3] against the upstream repository.


## conventions

### code style

*these are all recommendations, i will never reject pull requests based on style alone*

- keep code formatted, indent with tabs, not spaces.
- prefer functional style; keep functions pure and concise, use stdin for function input and chain operations with pipes.
arguments serve for passing options.


### commit message

loosely follow the [conventionalcommits][5] conventions<sup>\[[1][7]]</sup>. the important bits are:

- use the appropriate structure for the commit message.
- explicitly state when you're making a `BREAKING_CHANGE`, so we can bump the major version.

also, please don't use `fixes` or `closes` in commit messages, they will auto-close the issue/PR, and we want to leave 
that decision to the community.


### naming branches

use `feature` as prefix for branches that add features or make enhancements, or `fix` for bug fixes (e.g. `fix/bad-karma`).


## notes

1. *in contrast to conventionalcommits' recommendations, you should not squash your commits. we like to keep everything
in the commit history.*





[1]: https://github.com/eliranmal/vue-cli-template-dev-server/labels/good%20first%20issue
[2]: https://github.com/eliranmal/vue-cli-template-dev-server/issues
[3]: https://github.com/eliranmal/vue-cli-template-dev-server/compare
[4]: https://github.com/eliranmal/vue-cli-template-dev-server/labels/help%20wanted
[5]: https://www.conventionalcommits.org/
[7]: #notes
[10]: #code-style
[11]: #commit-message
[12]: #pull-requests
[13]: #naming-branches

