"""Role testing files using testinfra."""


def test_users(host):
    """Validate users."""
    assert host.user("tenminutevpn").exists
    assert host.user("tenminutevpn").group == "tenminutevpn"


def test_wireguard(host):
    """Check if WireGuard is installed."""
    assert host.package("wireguard").is_installed


def test_wireguard_configuration(host):
    with host.sudo():
        assert host.file("/etc/wireguard/wg0.conf").exists
        assert host.file("/etc/wireguard/wg0.conf").is_file

        assert host.file("/root/.wireguard/client.conf").exists
        assert host.file("/root/.wireguard/client.conf").is_file


def test_wireguard_port(host):
    with host.sudo():
        assert host.socket("udp://51820").is_listening
