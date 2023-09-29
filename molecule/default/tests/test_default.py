def test_zsh_installed(host):
    f = host.file('/bin/zsh')

    assert f.exists


def test_zsh_completions_installed(host):
    f = host.file('/usr/share/zsh/site-functions')

    assert f.exists
