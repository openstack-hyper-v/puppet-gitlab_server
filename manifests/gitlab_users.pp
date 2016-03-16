# == Class gitlab_server::gitlab_users
class gitlab_users ( $gitlab_user_list = hiera('gitlab::user_list') ) {
  $::gitlab_user_list.each { |$val| create_resources('gitlab::user', $val) }
}
