# See README.md for details.
class cups::browsed::service {

  # Since CUPS 1.6, there is a separate daemon responsible for discovering
  # network printers using Avahi and optionally the legacy CUPS protocol.

  # Report to the server and client that browsed from this module is unsupported on those operating systems and don't execute the class
  if $::cups::browsed_support == true {
    if $cups::package_cups_browsed {
      package { 'cups-browsed':
        name   => $cups::package_cups_browsed,
        ensure => present,
      }
    }

    $_package_cups_browsed = $cups::package_cups_browsed ? {
      undef   => 'cups',
      default => 'cups-browsed',
    }

    service { 'cups-browsed':
      name    => $::cups::service_cups_browsed,
      ensure  => running,
      pattern => 'cups-browsed',
      enable  => true,
      require => Package[$_package_cups_browsed],
    }
  }
  else {
    $_unsup_message = "${::operatingsystem} ${::operatingsystemrelease} not supported by browsed section of the cups module"
    notice($_unsup_message)
    notify { $_unsup_message: withpath => true }
  }
}
