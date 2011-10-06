class newrelic::server($license_key) {
	package { "newrelic-repo":
		provider => rpm,
		source => "http://beta.newrelic.com/d/newrelic-repo-5-3.noarch.rpm",
		ensure => latest,
	}

	file { "/etc/yum.repos.d/newrelic.repo":
		content => retrieve('http://beta.newrelic.com/d/beta.repo'),
		ensure => present,
		require => Package["newrelic-repo"],
	}

	package { "newrelic-server-monitor":
		ensure => latest,
		require => File["/etc/yum.repos.d/newrelic.repo"],
	}

	file { "/etc/newrelic/server-monitor.cfg":
		content => template("newrelic/server-monitor.cfg.erb"),
		owner => root,
		group => root,
		ensure => present,
		subscribe => Package["newrelic-server-monitor"],
	}

	service { "newrelic-server-monitor":
		enable => true,
		ensure => running,
		subscribe => [Package["newrelic-server-monitor"], File["/etc/newrelic/server-monitor.cfg"]],
	}
}
