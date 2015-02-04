# == Class: jmeter
#
# This class installs the latest stable version of JMeter.
#
# === Examples
#
#   class { 'jmeter': }
#
class jmeter(
  $jmeter_version         = '2.12',
  $jmeter_plugins_install = False,
  $jmeter_plugins_version = '1.2.0',
  $jmeter_plugins = ['Standard'],
) {

  Exec { path => '/bin:/usr/bin:/usr/sbin' }

  $jdk_pkg = $::osfamily ? {
    debian => 'openjdk-6-jre-headless',
    redhat => 'java-1.6.0-openjdk'
  }

  package { $jdk_pkg:
    ensure => present,
  }

  exec { 'download-jmeter':
    command => "wget -P /root http://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${jmeter_version}.tgz",
    creates => "/root/apache-jmeter-${jmeter_version}.tgz"
  }

  exec { 'install-jmeter':
    command => "tar xzf /root/apache-jmeter-${jmeter_version}.tgz && mv apache-jmeter-${jmeter_version} jmeter",
    cwd     => '/usr/share',
    creates => '/usr/share/jmeter',
    require => Exec['download-jmeter'],
  }

  if str2bool($jmeter_plugins_install) {
    jmeter::plugin { $jmeter_plugins:
      version => $jmeter_plugins_version,
    }
  }
}
