import pytest


def test_zsh_installed(host):
    f = host.file('/bin/zsh')

    assert f.exists


def test_zsh_completions_installed(host):

    if not host.ansible.get_variables().get('zsh_install_completions'):
        pytest.skip('Skipping since zsh_install_completions is false')

    f = host.file('/usr/share/zsh/site-functions')

    assert f.exists
