# == Define: cups::config::rawtemplate
#
# This defined type enables the user to createcupsd.conf and cups-browsed.conf files with the
# content of their choosing
#
# === Parameters
#
# [*ensure*]
#   Controls presence of the file that you're templating
#
# [*file*]
#   The file to write to, we only support files inside /etc/cups directory with this define
#
# [*values*]
#   Array of lines which you wish to write to the file
#
# [*service*]
#   The service you wish to refresh/restart when the file gets changed(most likely cups or cups-browsed)
#   Even if cups-browsed is another name on your OS, we tend to reference the service via cups-browsed
#
# [*chmod_value*]
#   File mode for the templated file, we will force 0640 if it's cupsd.conf though as that seems to be 
#   requried on that file
#
# === Authors
#
# * Adam S <mailto:asa188@sfu.ca>
#
define cups::config::rawtemplate (
  $ensure      = file,
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
  $_chmod_value = $file ? {
    '/etc/cups/cupsd.conf' => '0640',
    default                => $chmod_value,
  }
  if ($::osfamily == 'RedHat' and $::operatingsystemmajrelease == 6 and $file == '/etc/cups/cupsd.conf') {
    $include_file = [ 'Include /etc/cups/cups-browsed.conf' ]
    $_values = union($values, $include_file)
  }
  else {
    $_values = $values
  }

  file { $file:
    ensure  => $ensure,
    content => template('cups/cups-browsed.erb'),
    mode    => $_chmod_value,
    notify  => Service[$service],
    require => Package[$_package_cups_browsed],
  }
}
