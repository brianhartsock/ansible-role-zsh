import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']
).get_hosts('all')


def test_zsh_installed(host):
    f = host.file('/bin/zsh')

    assert f.exists


def test_zsh_completions_installed(host):
    f = host.file('/usr/share/zsh/site-functions')

    assert f.exists
