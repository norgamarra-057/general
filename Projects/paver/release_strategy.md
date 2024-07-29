[Branches]: release_strategy.md#branches
[Releases]: release_strategy.md#releases

# Release strategy

## Sources
Our release strategy follows the generic guidelines of the FreeBSD release model described under the following links:
 * https://www.freebsd.org/doc/en/books/dev-model/release-branches.html
 * https://www.bsdcan.org/2009/schedule/attachments/81_bsdcan2009-slides.pdf

## Version control
 * We use git
 * API/ABI versions manifest as branches
 * Releases use tags

## Release schedule
 * We aim to release new releases quarterly

## Branches
[Branches] are git branches which represent a current set of standards that act as API/ABI versions. Changes which break backward compatibility at a system level must only be released as a new branch. [Releases] are based on branches, the number in the release name indicates the branch the release ties to.

### Format
Branches are named:
```
stable-###
```
 * each branch is prefixed with "stable-"
 * the branch name contains three digits "###" which represent the version of the API

### Synopsis
 * stable-001
 * stable-002

### Examples for API change 
 * zpool layout changes
   * 2 pools -> 3 pools
   * changing the name of a zpool
 * file system layout changes
   * /var/groupon -> /grpn
 * system firewall changes
   * pf -> ipfw

## Releases
[Releases] use (annotated) git tags and represent milestones in the life of the project. Releases are cut quarterly and may include new features that do not break backward compatibility at a system level but might introduce backward incompatibility at a much more isolated level.

### Format
Releases are named:
```
release-###-####Q#
```
 * each release is prefixed with "release-"
 * the following three digits "###" refer to the API version (branch) that the release ties to
 * the release name ends with "-####Q#" there the first four digits refer to the current year and the last digit represents the quarter of the release

### Synopsis
 * release-001-2014Q3 (ties to branch stable-001)
 * release-002-2015Q4 (ties to branch stable-002)

### Examples for release level changes
 * introduction of new features
   * new role
 * changing a single role in a way that doesn't break other roles

## Development 
When you have a change:
 * make sure it is based off of a stable branch
 * highlight new features, if any
 * submit it as a PR (pull request)
 * resolve potential merge conflicts ahead of time
 * structure your changes (smaller commits are welcome)

Changes will also be merged into our development branch (master).

