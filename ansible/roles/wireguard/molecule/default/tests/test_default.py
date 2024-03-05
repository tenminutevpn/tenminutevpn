"""Role testing files using testinfra."""


def test_wireguard_package(host):
    """Check if WireGuard is installed."""
    assert host.package("wireguard").is_installed


def test_wireguard_scripts(host):
    """Check if WireGuard scripts are installed."""
    for script in ["wireguard-keygen.sh", "wireguard-init.sh"]:
        assert host.file(f"/usr/local/bin/{script}").exists
        assert host.file(f"/usr/local/bin/{script}").is_file
        assert host.file(f"/usr/local/bin/{script}").mode == 0o744


def test_wireguard_cloudinit(host):
    assert host.file("/etc/cloud/cloud.cfg.d/99_wireguard.cfg").exists


def test_wireguard_configuration(host):
    assert not host.file("/etc/wireguard/wg0.conf").exists
