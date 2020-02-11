class { 'pam::lockout': }

class { 'pam::wheel': }

class { 'pam::lockout': }

class { 'pam::cracklib':
  minlen => '7',
}

class { 'pam::unix':
  remember => '10',
}
