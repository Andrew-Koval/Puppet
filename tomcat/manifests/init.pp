# Class: tomcat
# ===========================
#
# Full description of class tomcat here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'tomcat':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2017 Your name here, unless otherwise noted.
#
class tomcat {
    group { 'tomcat':
        ensure => 'present',
        gid    => '91',
    }

    user { 'tomcat':
        ensure  => 'present',
        comment => 'Apache Tomcat',
        gid     => '91',
        groups  => 'tomcat',
        home    => '/usr/share/tomcat',
        shell   => '/sbin/nologin',
        uid     => '91',
    }

    exec {'wget_tomcat':
        command => "/bin/wget -q https://www-us.apache.org/dist/tomcat/tomcat-7/v7.0.77/bin/apache-tomcat-7.0.77.tar.gz -O /usr/share/apache-tomcat-7.0.77.tar.gz",
    }

    exec {'extract_tomcat':
        command => "/usr/bin/tar -xvf /usr/share/apache-tomcat-7.0.77.tar.gz -C /usr/share",
    }

    file { '/usr/share/tomcat':
        ensure => 'link',
        target => '/usr/share/apache-tomcat-7.0.77',
    }

    file { '/etc/systemd/system/':
        ensure => directory,
        mode => '0755',
        owner => 'root',
        group => 'root',
    }

    file { "/etc/systemd/system/tomcat.service":
        mode => "0644",
        owner => 'root',
        group => 'root',
        source => 'puppet:///modules/tomcat/tomcat.service',
    }
    
    exec {'restart_daemon-reload':
        command => "/usr/bin/systemctl daemon-reload",
    }

    service { 'tomcat':
        ensure => 'running',
    }
   
    service { 'puppet':
        enable => true,
    }

}
