#
class pam::ttyaudit (
                      $disable = [],
                      $enable  = [ '*' ],
                    ) inherits pam::params {

  if($enable!=undef)
  {
    validate_array($enable)
  }

  Exec {
    path => '/sbin:/bin:/usr/sbin:/usr/bin',
  }

  #    command => "sed '/pam_tty_audit.so/d' -i /etc/pam.d/sshd; echo 'session required pam_tty_audit.so enable=${enable}' >> /etc/pam.d/sshd",
  #    unless  => "grep 'session required pam_tty_audit.so enable=${enable}' /etc/pam.d/sshd",
  exec { 'afegint pam_tty_audit sshd':
    command => inline_template('sed \'/pam_tty_audit.so/d\' -i /etc/pam.d/sshd; echo \'session required pam_tty_audit.so<% if any?(@disable) %> disable=<%= @disable.join(\',\') %><% end %> enable=<%= @enable.join(\',\') %>\' >> /etc/pam.d/sshd'),
    unless  => inline_template('grep \'session required pam_tty_audit.so<% if any?(@disable) %> disable=<%= @disable.join(\',\') %><% end %> enable=<%= @enable.join(\',\') %>\' /etc/pam.d/sshd'),
  }


}
