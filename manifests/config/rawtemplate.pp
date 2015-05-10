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
  file { "$file":
    ensure  => file,
    content => template('cups/cups-browsed.erb'),
    mode    => $_chmod_value,
    notify  => Service["${service}"],
  }
}
