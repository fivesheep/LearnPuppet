file { "/etc/motd":
  ensure => present,
  source => "file:///data/etc/motd",
  mode => "0644",
  owner => "root",
}