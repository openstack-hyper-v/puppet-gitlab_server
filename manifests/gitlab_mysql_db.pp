class gitlab_mysql_db ( $gitlab_db_list = hiera('gitlab::mysql::db_list') ) {
  create_resources('mysql::db', $gitlab_db_list)
}
