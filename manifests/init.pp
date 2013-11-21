class gitlab_server {
  class { 'apt': }
  class { 'redis': }
  class { 'nginx': require => Class['redis'], }
  
  class {
    'ruby':
      version         => $ruby_version,
      rubygems_update => false;
  }

  class { 'ruby::dev': require => Class['ruby'], }

  if $::lsbdistcodename == 'precise' {
    package {
      ['build-essential','libssl-dev','libgdbm-dev','libreadline-dev',
      'libncurses5-dev','libffi-dev','libcurl4-openssl-dev','ruby1.9.1-dev']:
        ensure => installed;
    }

    $ruby_version = '4.9'

    # As silly as this looks, it actually is necessary, 
    #  as 1.9.1 will break yaml parsing in the hiera files, 
    #  but 1.8 (auto-default) will fail to run the gitlab install code.
    exec {
      'ruby-version':
        command     => '/usr/bin/update-alternatives --set ruby /usr/bin/ruby1.9.1',
        user        => root,
        logoutput   => 'on_failure',
        before      => Class['gitlab'],
        require     => Package['ruby1.9.1-dev'];
      'gem-version':
        command     => '/usr/bin/update-alternatives --set gem /usr/bin/gem1.9.1',
        user        => root,
        logoutput   => 'on_failure',
        before      => Class['gitlab'],
        require     => Package['ruby1.9.1-dev'];
    }
  } else {
    $ruby_version = '1:1.9.3'
  }
  
  class { 'mysql::server': }
  class { 'gitlab_mysql_db': require  => Class['mysql::config'], }
  
  class { 'gitlab': require => [Class['nginx'],Class['gitlab_mysql_db']], }
  
  class { 'gitlab_clone_repos': require => Class['gitlab'], }
  class { 'gitlab_import_repos': require => Class['gitlab_clone_repos'], }
  class { 'gitlab_users': require => Class['gitlab_import_repos'], }
  class { 'gitlab_add_users_to_groups': require => [Class['gitlab_import_repos'], Class['gitlab_users']], }
  
  # Cripple the built-in admin account after installation to avoid security issues later...
  class { 'gitlab_cripple_admin': require => Class['gitlab_add_users_to_groups'], }
}

