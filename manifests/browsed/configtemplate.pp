class cups::browsed::configtemplate (
  $file='/etc/cups/cups-browsed.conf',
  $service='cups-browsed',
  $values=undef,
) {
  file { "$file":
    ensure  => file,
    content => template('cups/cups-browsed.erb'),
    mode    => 0644,
  }
}
