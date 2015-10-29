class cups (
  $package_ensure       = $cups::params::package_ensure,
  $package_name         = $cups::params::package_name,
  $package_cups_browsed = $cups::params::package_cups_browsed,
  $devel_package_ensure = $cups::params::devel_package_ensure,
  $devel_package_name   = $cups::params::devel_package_name,
  $service_ensure       = $cups::params::service_ensure,
  $service_enabled      = $cups::params::service_enabled,
  $service_name         = $cups::params::service_name,
  $service_cups_browsed = $cups::params::service_cups_browsed,
  $cups_lpd_enable      = $cups::params::cups_lpd_enable,
  $package_cups_lpd     = $cups::params::package_cups_lpd,
  $config_file          = $cups::params::config_file,
  $cups_browsed_enable  = $cups::params::cups_browsed_enable,
) inherits cups::params {

  include '::cups::install'
  include '::cups::service'
  if $cups::cups_browsed_enable == true {
    include '::cups::browsed::service'
  }
  $printers_hash = hiera_hash(cups::printers, "Hash doesn't exist(no YAML data for cups::printers)")
  $printers_default = { ensure => present }
  if is_hash($printers_hash) {
    create_resources('printer', hiera_hash(cups::printers), $printers_default)
  }
  if $cups::cups_lpd_enable {
    include '::cups::config'
  }
}
