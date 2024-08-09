# How to contribute

Thank you for investing your time in contributing to our project!

---

## Issues

### Solve an issue

See [existing issues](https://github.com/cisco-open/ansible-collection-sdwan/issues) and feel free to work on any.

### Create a new issue

Firstly [search if an issue already exists](https://github.com/cisco-open/ansible-collection-sdwan/issues).

If issue related to your problem/feature request doesn't exist, create new issue.
There are 3 issue types:

- Bug report
- Feature Request
- Report a security vulnerability

Select one from [issue form](https://github.com/cisco-open/ansible-collection-sdwan/issues/new/choose).

### Create PR

When you're finished with the changes, create a pull request, also known as a PR.

---

## Release process

According to [release workflow inside .github workflows](../.github/workflows/release-from-tag.yml) collection publication to Ansible Galaxy will happen when admin of the repository will push new tag.
This tag must match version used in [galaxy.yml](../galaxy.yml) file.
Release will happen only if desired version was not published on Ansible Galaxy yet.
