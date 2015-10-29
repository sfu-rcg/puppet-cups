define cups::config::rawtemplate (
  $file        = $name,
  $values      = [],
  $chmod_value = '0644',
) {
  if $::cups::browsed_support == true {
    validate_re($file, '^/etc/cups/', 'This class will only modify files inside the /etc/cups/ directory')
    validate_array($values)
    $_package_cups_browsed = $cups::package_cups_browsed ? {
      undef   => 'cups',
      default => 'cups-browsed',
    }
    if ($file == '/etc/cups/cupsd.conf') {
      $_chmod_value = '0640'
    }
    else {
      $_chmod_value = $chmod_value
    }
    if ($::osfamily == 'RedHat' and $::operatingsystemmajrelease == 6 and $file == '/etc/cups/cupsd.conf') {
      $include_file = [ 'Include /etc/cups/cups-browsed.conf' ]
      $_values = union($values, $include_file)
    }
    else {
      $_values = $values
    }

    file { $file:
      ensure  => file,
      content => template('cups/cups-browsed.erb'),
      mode    => $_chmod_value,
      notify  => Service['cups-browsed'],
      require => Package[$_package_cups_browsed],
    }
  }
}
