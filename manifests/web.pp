exec {'apt-update':
  command => '/usr/bin/apt-get update'
}

package {['htop', 'openjdk-8-jre', 'tomcat8', 'mysql-server']:
  ensure  => installed,
  require => Exec['apt-update']
}

service { 'tomcat8':
  ensure     => running,
  enable     => true,
  hasstatus  => true,
  hasrestart => true,
  require    => Package['tomcat8']
}

service { 'mysql':
  ensure     => running,
  enable     => true,
  hasstatus  => true,
  hasrestart => true,
  require    => Package['mysql-server']
}

exec {'musicjungle':
  command => 'mysqladmin -uroot create musicjungle',
  unless  => 'mysql -u root musicjungle',
  path    => '/usr/bin',
  require => Service['mysql']
}

exec {'musicjungle_user_and_password':
  command => 'mysql -uroot -e "GRANT ALL PRIVILEGES ON * TO \'musicjungle\'@\'%\' IDENTIFIED BY \'123456\';" musicjungle',
  unless  => 'mysql -umusicjungle -p123456 musicjungle',
  path    => '/usr/bin',
  require => Exec['musicjungle']
}

file {'/var/lib/tomcat8/webapps/vraptor-musicjungle.war':
  source  => '/vagrant/manifests/vraptor-musicjungle.war',
  owner   => 'tomcat8',
  group   => 'tomcat8',
  mode    => '0644',
  require => Package['tomcat8'],
  notify  => Service['tomcat8']
}

file {'/var/lib/tomcat8/webapps/vraptor-segunda-aplicacao.war':
  source  => '/vagrant/manifests/vraptor-musicjungle.war',
  owner   => 'tomcat8',
  group   => 'tomcat8',
  mode    => '0644',
  require => Package['tomcat8'],
  notify  => Service['tomcat8']
}

file_line {'production':
  file    => '/etc/default/tomcat8',
  line    => 'JAVA_OPTS="$JAVA_OPTS -Dbr.com.caelum.vraptor.environment=production"',
  require => Package['tomcat8'],
  notify  => Service['tomcat8']
}

define file_line($file, $line) {
    exec { "/bin/echo '${line}' >> '${file}'":
        unless => "/bin/grep -qFx '${line}' '${file}'"
    }
}
