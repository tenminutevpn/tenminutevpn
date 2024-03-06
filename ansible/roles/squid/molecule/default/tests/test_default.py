"""Role testing files using testinfra."""


def test_squid_script_exists(host):
    with host.sudo():
        assert host.file("/usr/local/bin/squid-init.sh").exists
