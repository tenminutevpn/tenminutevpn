"""Role testing files using testinfra."""


def test_service(host):
    service = host.service("squid")
    # FIXME: https://github.com/pytest-dev/pytest-testinfra/issues/757
    # assert service.exists
    assert not service.is_running
    assert not service.is_enabled

def test_config(host):
    config = host.file("/etc/dnsmasq.conf")
    assert config.exists
