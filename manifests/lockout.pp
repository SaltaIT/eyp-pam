# faillock
# 4.1.2 - https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Security_Guide/chap-Hardening_Your_System_with_Tools_and_Services.html#sect-Security_Guide-Workstation_Security-Account_Locking
#
# pam_tally2
# http://myexperienceswithunix.blogspot.com.es/2016/09/locking-user-accounts-with-pam-faillock.html
#
class pam::lockout (
                      $manage_package        = true,
                      $package_ensure        = 'installed',
                      $manage_service        = true,
                      $manage_docker_service = true,
                      $service_ensure        = 'running',
                      $service_enable        = true,
                      $even_deny_root        = false,
                      $unlock_time           = '900',
                      $deny_failed           = '5',
                      $silent_preauth        = true,
                      $silent_authfail       = false,
                      $user_whitelist        = undef,
                    ) inherits pam::params{

  include ::pam

  if($user_whitelist!=undef)
  {
    validate_array($user_whitelist)
  }

  Class['::pam'] ->
  class { '::pam::lockout::install': } ->
  class { '::pam::lockout::config': } ->
  Class['::pam::lockout']

}
