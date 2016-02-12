# Params for cups module
class cups::params {
  $package_ensure = present
  $package_name = 'cups'

  $devel_package_ensure = undef
  $devel_package_name = "${package_name}-devel"

  $service_ensure = 'running'
  $service_enabled = true
  $service_name = 'cups'
  $service_cups_browsed = 'cups-browsed'

  $cups_lpd_enable = false
  $cups_lpd_ensure = 'running'
  $package_cups_lpd = 'cups-lpd'
  $config_file = 'puppet:///modules/cups/cups-lpd'
  $cups_browsed_enable = false
  $package_cups_browsed = $::operatingsystem ? {
    'CentOS' => undef,
    'Fedora' => 'cups-filters',
    'Ubuntu' => 'cups-browsed',
  }
  # Browsed Class verification for whether supported or not
  $browsed_support = $::operatingsystem ? {
    'CentOS' => $::operatingsystemmajrelease ? {
      '7'     => true,
      default => false,
    },
    'Fedora' => $::operatingsystemmajrelease ? {
      '22'    => true,
      default => false,
    },
    'Ubuntu' => $::operatingsystemmajrelease ? {
      /^15\.\d+$/ => true,
      /^16\.\d+$/ => true,
      default     => false,
    },
    default => false
  } # end ::operatingsystem
}
