class gitlab_clone_repos ( 
  $gitlab_repo_url_base = hiera('gitlab::repo_url_base'),
  $gitlab_repo_list = hiera('gitlab::repo_list'),
  $repo_root = "${gitlab::gitlab_repodir}/repositories",
) {
  $gitlab_repo_list.each { |$groupname, $repos|
    $repos.each { |$repo_name, $repo_source|
      if $repo_name =~ /.*\.git$/ {
        $real_name = $repo_name
      } else {
        $real_name = "${repo_name}.git"
      }
      vcsrepo {"${repo_root}/${groupname}/${real_name}":
        ensure => bare,
        provider => git,
        source => "${gitlab_repo_url_base}${repo_source}",
      }
    }
  }
}
