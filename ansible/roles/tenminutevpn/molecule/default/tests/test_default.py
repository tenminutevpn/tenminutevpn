"""Role testing files using testinfra."""


def test_users(host):
    """Validate users."""
    assert host.user("tenminutevpn").exists
    assert host.user("tenminutevpn").group == "tenminutevpn"
