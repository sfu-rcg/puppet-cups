# See README.md for details.
define cups::browsed::config (
  $ensure='present',
  $file='/etc/cups/cups-browsed.conf',
  $service='cups-browsed',
  $section=undef,
  $key=undef,
  $value=undef,
) {

  $real_key = $key ? {
    undef   => $name,
    default => $key,
  }

  # Append a / to section if passed
  $real_section = $section ? {
    undef   => '',
    default => "${section}/",
  }

  case $ensure {

    'present': {
      if $value {
        $changes = [
          "set ${real_section}directive[.='${real_key}'] '${real_key}'",
          "set ${real_section}directive[.='${real_key}']/arg '${value}'",
        ]
      } else {
        fail ('You must provide a value')
      }
    }

    'absent': {
      $changes = "rm ${real_section}directive[.='${real_key}']"
    }

    default: { fail ("Wrong value for ensure: ${ensure}") }
  }

  augeas {"Manage ${name} in ${file}":
    incl    => $file,
    lens    => 'Cups.lns',
    changes => $changes,
    notify  => Service[$service],
  }
}
