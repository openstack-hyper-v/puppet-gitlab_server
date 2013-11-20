class gitlab_import_repos (
  $repo_home = hiera('gitlab::gitlab_repodir'),
) {
  exec {'Import bare repos':
      command     => 'bundle exec rake gitlab:import:repos RAILS_ENV=production',
      provider    => 'shell',
      cwd         => "${repo_home}/gitlab",
      user        => $git_user,
      require     => Package['bundler'],
  }
}

