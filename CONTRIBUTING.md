# How to Contribute

We want to make contributing to this project as approachable and transparent as
possible.

## Any contributions you make will be under the MIT Software License

In short, when you submit code changes, your submissions are understood to be under the same [MIT License](http://choosealicense.com/licenses/mit/) that covers the project. Feel free to contact us if that's a concern.

## Code of Conduct

Kroger has adopted a Code of Conduct that we expect project participants to adhere to. Please [read the full text](CODE_OF_CONDUCT.md) so that you can understand what actions will and will not be tolerated.

## Our Development Process

We use GitHub to track issues and feature requests, as well as accept pull requests.

### Proposing a Change

If you intend to change the public API, or make any non-trivial changes to the implementation, we recommend filing an issue.
This lets us reach an agreement on your proposal before you put significant effort into it.

If you’re only fixing a bug we still recommend to file an issue detailing what you’re fixing.
This is helpful in case we don’t accept that specific fix but want to keep track of the issue.

### Pull Requests

We actively welcome your pull requests.

- Fork the repo and create your branch from `main`.
- Make commits of logical units.
- Write meaningful, descriptive commit messages.
- If you've added code that should be tested, add tests. Changes that lower test coverage may not be considered for merge.
- If you've changed APIs, update the documentation.
- Ensure the test suite passes.
- Make sure your code lints.
- All CI pipelines must pass.

### Code Reviews

All submissions, including submissions by project members, require review. We
use GitHub pull requests for this purpose. Consult
[GitHub Help](https://help.github.com/articles/about-pull-requests/) for more
information on using pull requests.

## Issues

We use GitHub issues to track public bugs. Please ensure your description is clear and has sufficient instructions to be able to reproduce the issue.

If possible please provide a minimal demo of the problem.

### Write bug reports with detail, background, and sample code

**Great Bug Reports** tend to have:

- A quick summary and/or background
- Steps to reproduce
  - Be specific!
  - Give sample code if you can
- What you expected would happen
- What actually happens
- Notes (possibly including why you think this might be happening, or stuff you tried that didn't work)

## Issue Triage

Here are some tags that we're using to better organize issues in this repo:

* `good first issue` - Good candidates for someone new to the project to contribute.
* `help wanted` - Issues that should be addressed and which we would welcome a
PR for but may need significant investigation or work.
* `support` - Request for help with a concept or piece of code but this isn't an
issue with the project.
* `needs more info` - Missing repro steps or context for both project issues \&
support questions.
* `discussion` - Issues where folks are discussing various approaches and ideas.
* `question` - Something that is a question specifically for the maintainers.
* `documentation` - Relating to improving documentation for the project.
- Browser \& OS-specific tags for anything that is specific to a particular
environment (e.g. `chrome`, `firefox`, `macos`, `android` and so forth).

## Stability

Our philosophy regarding API changes is as follows:
 * We will avoid changing APIs and core behaviors in general
 * In order to avoid stagnation we will allow for API changes in cases where there is no other way to achieve a high priority bug fix or improvement.
 * When there is an API change:
    * Changes will have a well documented reason and migration path
    * When deprecating a pattern, these steps will be followed:
        * We will test the change internally first at Kroger
        * A version will be released that supports both, with deprecation warnings
        * The following version will fully remove the deprecated pattern