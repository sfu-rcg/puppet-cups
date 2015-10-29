# Enables the user to create cupsd.conf and cups-browsed.conf files
# with the content of their choosing
# $file is the file you'll write to
# $values is an array of lines you want to write to the file
# $service is the service you want to refresh when the file gets changed, 
#   this should be cups or cups-browsed only most likely
# $chmod_value is for file mode, we will force 0640 if it's cupsd.conf though as that is required on that file
define cups::config::rawtemplate (
  $file        = $name,
  $values      = [],
  $service     = 'cups-browsed',
  $chmod_value = '0644',
) {
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
    notify  => Service[$service],
    require => Package[$_package_cups_browsed],
  }
}
