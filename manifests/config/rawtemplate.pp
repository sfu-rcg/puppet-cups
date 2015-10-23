define cups::config::rawtemplate (
  $file        = $name,
  $service     = 'cups-browsed',
  $values      = undef,
  $chmod_value = 0644
) {
  validate_re($file, '^/etc/cups/', "This class will only modify files inside the /etc/cups/ directory")
  if ($file == '/etc/cups/cupsd.conf') {
    $_chmod_value = 0640
  }
  else {
    $_chmod_value = $chmod_value
  }
  if ($::osfamily == 'RedHat' and $::operatingsystemmajrelease == 6 and $file == '/etc/cups/cupsd.conf') {
    $includeFile = [ 'Include /etc/cups/cups-browsed.conf' ]
    $_values = split(inline_template("<%= (@values+@includeFile).join(',') %>"),',')
  }
  else {
    $_values = $values
  }

  case $::operatingsystem {
    CentOS: {
      case $::operatingsystemmajrelease {
        7: {
          $cups_browsed_package = 'cups'
        } # 7
      } # ::operatingsystemmajrelease
    } # CentOS
    Fedora: {
      $cups_browsed_package = 'cups-filters'
    } # Fedora
    Ubuntu: {
      $cups_browsed_package = 'cups-browsed'
    } # Ubuntu
    default: {
      fail("Unsupported platform.")
    } # default
  } # ::operatingsystem

  file { "$file":
    ensure  => file,
    content => template('cups/cups-browsed.erb'),
    mode    => $_chmod_value,
    notify  => Service["${service}"],
    require => Package[$cups_browsed_package],
  }
}
