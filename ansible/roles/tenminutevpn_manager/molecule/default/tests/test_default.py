"""Role testing files using testinfra."""


def test_tenminutevpn_manager(host):
    """ Validate tenminutevpn_manager is installed """
    f = host.file("/usr/bin/tenminutevpn-manager")

    assert f.exists
    assert f.user == "root"
    assert f.group == "root"
    assert f.mode == 0o755
