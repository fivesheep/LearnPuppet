$puppet_collection_package = "puppetlabs-release-pc1-trusty.deb"

file { "/etc/motd":
  ensure => present,
  source => "file:///data/etc/motd",
  mode => "0644",
  owner => "root",
}

file { "/root/deb":
  ensure => directory,
  mode => "0700",
}

exec { "download-puppet-collection":
  command => "wget -q https://apt.puppetlabs.com/$puppet_collection_package",
  cwd => "/root/deb",
  path => ['/usr/bin',],
  creates => "/root/deb/$puppet_collection_package",
  require => File['/root/deb']
}

file { "/root/deb/$puppet_collection_package":
  ensure => present,
  mode => "0644",
  require => Exec["download-puppet-collection"],
}

exec { 'install-puppet-collection':
  command => "dpkg -i /root/deb/$puppet_collection_package && apt-get update",
  path => ['/bin', '/usr/bin', '/usr/sbin', '/sbin'],
  require => File["/root/deb/$puppet_collection_package"],
}

package {"puppetserver":
  ensure => installed,
  require => Exec['install-puppet-collection'],
}
