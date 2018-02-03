ZSH
=========

[![Build Status](https://travis-ci.org/brianhartsock/ansible-role-homebrew.svg?branch=master)](https://travis-ci.org/brianhartsock/ansible-role-homebrew)

Simple role to install ZSH and ZSH completions.

Requirements
------------

Role has been tested on Ubuntu 16.04 and Mac OSX High Sierra. Although any operating system with a ZSH package should work.

On Ubuntu, the role should be run as root with `become: true`. This is not required for OSX.

Role Variables
--------------

None

Dependencies
------------

None

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
