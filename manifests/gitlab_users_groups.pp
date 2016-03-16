# == Class: gitlab_add_users_to_groups
class gitlab_add_users_to_groups ( $gitlab_groups_users_list = hiera('gitlab::groups_users_list') ) {
  $gitlab_groups_users_list.each { |$groupname, $users_list|
    $users_list.each { |$user_email|
      gitlab::group_user { "${groupname}_${user_email}":
        user_email => $user_email,
        groupname  => $groupname,
      }
    }
  }
}
