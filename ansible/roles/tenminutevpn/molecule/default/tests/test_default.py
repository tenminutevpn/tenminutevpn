"""Role testing files using testinfra."""


def test_users(host):
    """Validate users."""
    assert host.user("tenminutevpn").exists
    assert host.user("tenminutevpn").group == "tenminutevpn"


def test_wireguard(host):
    """Check if WireGuard is installed."""
    assert host.package("wireguard").is_installed
