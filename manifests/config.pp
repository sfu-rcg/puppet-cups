# Configures LPD for cups if requested
class cups::config {
  if $cups::cups_lpd_enable {
    file { '/etc/xinetd.d/cups-lpd':
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => $cups::config_file,
    }
  }
}
