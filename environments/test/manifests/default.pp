exec { "apt-get update":
  path => "/usr/bin",
}

include apt

apt::source { "elasticsearch_repo":
        location        => "http://packages.elastic.co/elasticsearch/2.x/debian",
        release         => "stable",
        repos           => " main",
        include     => { src => false },
}

class { "elasticsearch": 
  version => '2.2.0',
  java_install => true,
  require => Exec["apt-get update"],
}

package { "apache2": 
  ensure => present,
  require => Exec["apt-get update"],
}

elasticsearch::instance { 'es-01':
  config => {
    'network.host' => '0.0.0.0'
  },
  init_defaults => {
    'ES_HEAP_SIZE' => '4g'
  },
}

elasticsearch::plugin { 'lmenezes/elasticsearch-kopf':
  instances => 'es-01',
}

elasticsearch::plugin { 'license':
  instances => 'es-01',
}

elasticsearch::plugin { 'marvel-agent':
  instances => 'es-01',
  require => Elasticsearch_plugin['license'],
}

class { 'kibana': 
  version => '4.4.0',
}

exec { 'kibana-marvel-plugin':
  command => '/opt/kibana/bin/kibana plugin --install elasticsearch/marvel/latest',
  logoutput => true,
  creates => '/opt/kibana/installedPlugins/marvel',
  require => Class['kibana'],
  user => 'root',
}

exec { 'kibana-sense-plugin':
   command => '/opt/kibana/bin/kibana plugin --install elastic/sense',
   creates => '/opt/kibana/installedPlugins/sense',
   require => Class['kibana'],
   user => 'root',
}
