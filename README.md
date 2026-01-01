Ansible Role: ZSH
=========
[![CI](https://github.com/brianhartsock/ansible-role-zsh/actions/workflows/ci.yml/badge.svg)](https://github.com/brianhartsock/ansible-role-zsh/actions/workflows/ci.yml)

Simple role to install ZSH and ZSH completions.

Requirements
------------

Role has been tested on Ubuntu 22.04, 24.04, and Mac OSX Sonoma. Although any operating system with a ZSH package should work.

On Ubuntu, the role should be run as root with `become: true`. This is not required for OSX.

Role Variables
--------------
Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# Specify the URL to pull the debian package for ZSH completions
- zsh_completions_deb_url: ...

# Whether or not to install completions
- zsh_install_completions: false
```

Dependencies
------------

_No role dependencies, however..._

Homebrew is used for OSX to install ZSH.


Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - brianhartsock.zsh
           become: true

License
-------

MIT

Author Information
------------------

Created with love by [Brian Hartsock](http://blog.brianhartsock.com).
