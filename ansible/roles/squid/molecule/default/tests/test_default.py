"""Role testing files using testinfra."""


def test_squid_script_exists(host):
    with host.sudo():
        assert host.file("/usr/local/bin/squid-init.sh").exists


def test_squid_cloud_init_script_exists(host):
    with host.sudo():
        assert host.file("/etc/cloud/cloud.cfg.d/98_squid.cfg").exists
