class pam::lockout::config inherits pam::lockout {

  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  case $pam::params::pam_lockout
  {
    'faillock':
    {
      if($pam::params::authconfig_systemauth_custom_file)
      {
        file { $pam::params::authconfig_systemauth_custom_file:
          ensure  => 'present',
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
          content => template($pam::params::authconfig_systemauth_template),
        }
      }

      if($pam::params::authconfig_password_custom_file)
      {
        file { $pam::params::authconfig_password_custom_file:
          ensure  => 'present',
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
          content => template($pam::params::authconfig_password_template),
        }
      }
    }
    default:
    {
      fail("${pam::params::pam_lockout} currently not implemented")
    }
  }

}
