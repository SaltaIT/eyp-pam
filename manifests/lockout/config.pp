class pam::lockout::config inherits pam::lockout {

  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  case $pam::params::pam_lockout
  {
    'faillock':
    {
      # ln -sf /etc/pam.d/system-auth-local /etc/pam.d/system-auth
      # ln -sf /etc/pam.d/password-auth-local /etc/pam.d/password-auth

      if($pam::params::authconfig_systemauth_custom_file)
      {
        file { $pam::params::authconfig_systemauth_custom_file:
          ensure  => 'present',
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
          content => template($pam::params::authconfig_systemauth_template),
        }

        file { $pam::params::real_systema_auth_conf:
          ensure  => 'link',
          target  => $pam::params::authconfig_systemauth_custom_file,
          require => File[$pam::params::authconfig_systemauth_custom_file],
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

        file { $pam::params::real_password_auth_conf:
          ensure  => 'link',
          target  => $pam::params::authconfig_password_custom_file,
          require => File[$pam::params::authconfig_password_custom_file],
        }
      }
    }
    'tally2':
    {
      # sed 's/\(^account.*pam_unix\.so.*$\)/\naccount required pam_tally2.so\n\n\1\n/'
      exec { 'update commond account':
        command => "sed 's/\\(^account.*pam_unix\\.so.*$\\)/\\naccount required pam_tally2.so\\n\\n\\1\\n/' -i /etc/pam.d/common-account",
        unless  => "grep -P 'account required pam_tally2.so'",
      }
    }
    default:
    {
      fail("${pam::params::pam_lockout} currently not implemented")
    }
  }

}
