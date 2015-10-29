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
    CentOS => undef,
    Fedora => 'cups-filters',
    Ubuntu => 'cups-browsed',
  }
  # Browsed Class verification for whether supported or not
  case $::operatingsystem {
    CentOS: {
      $browsed_support = $::operatingsystemmajrelease ? {
        '7'       => true,
        default => false,
      }
    } # end CentOS
    Fedora: {
      $browsed_support = $::operatingsystemmajrelease ? {
        '22'      => true, 
        default => false,
      }
    } # end Fedora
    Ubuntu: {
      $browsed_support = $::operatingsystemmajrelease ? {
        /^15\.\d+$/ => true,
        default     => false,
      }
    } # end Ubuntu
    default: {
      $browsed_support = false
    }
  } # end ::operatingsystem
}
