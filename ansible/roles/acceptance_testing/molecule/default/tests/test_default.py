"""Role testing files using testinfra."""


def test_users(host):
    """Validate users."""
    assert host.user("tenminutevpn").exists
    assert host.user("tenminutevpn").group == "tenminutevpn"


def test_wireguard(host):
    """Check if WireGuard is installed."""
    with host.sudo():
        assert host.package("wireguard").is_installed
        assert host.file("/etc/wireguard/wg0.conf").exists
        assert host.file("/etc/wireguard/wg0.conf").is_file
        assert host.socket("udp://51820").is_listening


def test_squid(host):
    with host.sudo():
        assert host.package("squid").is_installed
        assert host.file("/etc/squid/squid.conf").exists
        assert host.file("/etc/squid/squid.conf").is_file
        assert host.service("squid").is_enabled
        assert host.service("squid").is_running
        assert host.socket("tcp://3128").is_listening
