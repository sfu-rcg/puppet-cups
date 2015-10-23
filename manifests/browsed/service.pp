# See README.md for details.
class cups::browsed::service {

  # Since CUPS 1.6, there is a separate daemon responsible for discovering
  # network printers using Avahi and optionally the legacy CUPS protocol.

  case $::operatingsystem {
    CentOS: {
      case $::operatingsystemmajrelease {
        7: {
          if !defined(Package["cups"]) {
            package { 'cups':
              ensure => present,
            }
          }
          service { 'cups-browsed':
            ensure  => running,
            pattern => 'cups-browsed',
            enable  => true,
            require => Package['cups'],
          }
        } # end 7
        default: {
          fail("Unsupported platform.")
        } # end default
      } # end ::operatingsystemmajrelease
    } # end CentOS

    Fedora: {
      case $::operatingsystemmajrelease {
        22: {
          if !defined(Package['cups-filters']) {
            # don't ask me why cups-browsed is provided by cups-filters
            package { ['cups-filters']:
              ensure => present,
            }
          }
          service { 'cups-browsed':
            provider => 'systemd',
            ensure   => running,
            pattern  => 'cups-browsed',
            enable   => true,
            require  => Package['cups-filters'],
          }
        } # end 22
        default: {
          fail("Unsupported platform.")
        } # end default
      } # end ::operatingsystemmajrelease
    } # end Fedora

    Ubuntu: {
      case $::operatingsystemmajrelease {
        # facter 2.3 reports major release number as 15.04, 15.10.
        # thanks for nothing, facter.

        /^15\./: {
          if !defined(Package['cups-browsed']) {
            package { ['cups-browsed']:
              ensure => present,
            }
          }
          service { 'cups-browsed':
            provider => 'systemd',
            ensure   => running,
            pattern  => 'cups-browsed',
            enable   => true,
            require  => Package['cups-browsed'],
          }
        } # end 15.x
        default: {
          fail("Unsupported platform.")
        } # end default
      } # end ::operatingsystemmajrelease
    } # end Ubuntu
  } # end ::operatingsystem
}
