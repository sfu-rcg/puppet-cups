# See README.md for details.
class cups::browsed::service {

  # Since CUPS 1.6, there is a separate daemon responsible for discovering
  # network printers using Avahi and optionally the legacy CUPS protocol.

  validate_re ($::operatingsystem, 'CentOS', 'cups-browsed only exists with SystemD cups in CentOS')
  validate_re ($::operatingsystemmajrelease, '7', 'cups-browsed only exists with SystemD cups in CentOS')

  package {'cups':
    ensure => present,
  }

  service {'cups-browsed':
    ensure  => running,
    pattern => 'cups-browsed',
    enable  => true,
    require => Package['cups'],
  }

}
